import DomainModels
import Foundation

extension Country {
    var imageName: String {
        if countryName == "Antigua & Barbuda" {
            return "antigua"
        } else if countryName == "Barbados" {
            return "barbados"
        }  else if countryName == "Dominica" {
            return "dominica"
        }  else if countryName == "Grenada" {
            return "grenada"
        }  else if countryName == "Guyana" {
            return "guyana"
        }  else if countryName == "Jamaica" {
            return "jamaica"
        }  else if countryName == "St. Kitts & Nevis" {
            return "saintKitts"
        }  else if countryName == "St. Lucia" {
            return "saintLucia"
        }  else if countryName == "St. Vincent & Grenadines" {
            return "saintVincent"
        } else {
            return ""
        }
    }
}
