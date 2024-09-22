import Foundation

let packagesFolderName = "Packages"
let layers = ["Logic", "Repositories", "ViewModels"]

let patterns = [
    ("@Factory\\s+public\\s+final\\s+class\\s+(\\w+)", "transient"),
    ("@Factory\\s+final\\s+public\\s+class\\s+(\\w+)", "transient"),
    ("@WeakFactory\\s+public\\s+final\\s+class\\s+(\\w+)", "weak"),
    ("@WeakFactory\\s+final\\s+public\\s+class\\s+(\\w+)", "weak"),
    ("@Single\\s+public\\s+final\\s+class\\s+(\\w+)", "container"),
    ("@Single\\s+final\\s+public\\s+class\\s+(\\w+)", "container"),
]

func findProjectRoot(from directory: String) -> String? {
    let fileManager = FileManager.default
    var currentDirectory = directory

    while true {
        if let contents = try? fileManager.contentsOfDirectory(atPath: currentDirectory) {
            for item in contents {
                if item.hasSuffix(".xcodeproj") || item.hasSuffix(".xcworkspace") {
                    return currentDirectory
                }
            }
        }

        let parentDirectory = (currentDirectory as NSString).deletingLastPathComponent
        if parentDirectory == currentDirectory {
            // We've reached the root directory of the file system
            break
        }
        currentDirectory = parentDirectory
    }

    return nil
}

func findSwiftFiles(in directory: String) -> [String] {
    var swiftFiles: [String] = []
    if let contents = try? FileManager.default.contentsOfDirectory(atPath: directory) {
        for item in contents {
            let itemPath = "\(directory)/\(item)"
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: itemPath, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    swiftFiles.append(contentsOf: findSwiftFiles(in: itemPath))
                } else if item.hasSuffix(".swift") {
                    swiftFiles.append(itemPath)
                }
            }
        }
    }
    return swiftFiles
}

func generateAutoregisters(in swiftFiles: [String]) -> String {
    var autoregisters: [String] = []
    var regexes: [(NSRegularExpression, String)] = []

    for (pattern, scope) in patterns {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        regexes.append((regex, scope))
    }

    for file in swiftFiles {
        let content = try! String(contentsOfFile: file, encoding: .utf8)

        for (regex, scope) in regexes {
            let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
            for match in matches {
                if let range = Range(match.range(at: 1), in: content) {
                    let className = String(content[range])
                    let scopeText = ".\(scope)"
                    autoregisters.append("self.autoregister(\(className).self, initializer: \(className).init).inObjectScope(\(scopeText))")
                    print("Auto registering \(className) in \(scope) scope")
                }
            }
        }
    }

    return autoregisters.sorted().joined(separator: "\n\t\t")
}

func createContainerExtension(for packageName: String, autoRegisters: String) -> String {
    return """
import Swinject
import SwinjectAutoregistration

// This file was auto-generated
public extension Container {
    func inject\(packageName)Generated() -> Container {
        \(autoRegisters)
        return self
    }
}

"""
}

func writeToFile(_ content: String, to file: String) {
    do {
        try content.write(toFile: file, atomically: true, encoding: .utf8)
    } catch {
        print("Failed writing to file \(file)")
    }
}

func writeLayer(packageName: String, layerName: String) {
    let rootDirectory = findProjectRoot(from: FileManager.default.currentDirectoryPath)!
    let directory = "\(rootDirectory)/\(packagesFolderName)/\(packageName)/Sources/\(layerName)"
    let swiftFiles = findSwiftFiles(in: directory)
    let autoRegisters = generateAutoregisters(in: swiftFiles)
    let containerExtension = createContainerExtension(for: layerName, autoRegisters: autoRegisters)
    writeToFile(containerExtension, to: "\(directory)/DI/Container+\(layerName)+Generated.swift")
}

for layer in layers {
  writeLayer(packageName: layer, layerName: layer)
  print("Done with \(layer)")
}
