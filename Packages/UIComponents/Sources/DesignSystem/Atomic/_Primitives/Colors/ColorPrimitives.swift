//
//  ColorPrimitives.swift
//  UIComponents
//
//  Created by Eric Silverberg on 3/29/26.
//

import SwiftUI

public enum ColorPrimitives {
    public enum White {
        public static let _100 = Color(hex: 0xFFFFFF)
        public static let _85 = Color(hex: 0xFFFFFF, alpha: 0.85)
        public static let _60 = Color(hex: 0xFFFFFF, alpha: 0.6)
        public static let _25 = Color(hex: 0xFFFFFF, alpha: 0.25)
        public static let _15 = Color(hex: 0xFFFFFF, alpha: 0.15)
    }

    public enum Black {
        public static let _100 = Color(hex: 0x000000)
        public static let _85 = Color(hex: 0x000000, alpha: 0.85)
        public static let _60 = Color(hex: 0x000000, alpha: 0.6)
        public static let _25 = Color(hex: 0x000000, alpha: 0.25)
        public static let _15 = Color(hex: 0x000000, alpha: 0.15)
    }

    public enum DarkGray {
        public static let _100 = Color(hex: 0x1E1E1E)
        public static let _60 = Color(hex: 0x1E1E1E, alpha: 0.6)
        public static let _25 = Color(hex: 0x1E1E1E, alpha: 0.25)
        public static let _15 = Color(hex: 0x1E1E1E, alpha: 0.15)
    }

    public enum MidGray {
        public static let _100 = Color(hex: 0x4D4D4D)
        public static let _60 = Color(hex: 0x4D4D4D, alpha: 0.6)
        public static let _25 = Color(hex: 0x4D4D4D, alpha: 0.25)
        public static let _15 = Color(hex: 0x4D4D4D, alpha: 0.15)
    }

    public enum LightGray {
        public static let _100 = Color(hex: 0xD2D2D2)
        public static let _60 = Color(hex: 0xD2D2D2, alpha: 0.6)
        public static let _25 = Color(hex: 0xD2D2D2, alpha: 0.25)
        public static let _15 = Color(hex: 0xD2D2D2, alpha: 0.15)
    }

    public enum LightestGray {
        public static let _100 = Color(hex: 0xEAEAEE)
    }

    public enum RedPro {
        public static let _100 = Color(hex: 0xFFFD_DDDD)
        public static let _300 = Color(hex: 0xFFF5_6F6F)
        public static let _500 = Color(hex: 0xFFEE_0002)
        public static let _700 = Color(hex: 0xFFCC_0000)
        public static let _900 = Color(hex: 0xFF66_0000)
    }

    public enum BlueFree {
        public static let _100 = Color(hex: 0xFFCE_E1F4)
        public static let _300 = Color(hex: 0xFF6F_B1F7)
        public static let _500 = Color(hex: 0xFF00_72EF)
        public static let _700 = Color(hex: 0xFF07_5EDE)
        public static let _900 = Color(hex: 0xFF00_07AF)
    }

    public enum Malachite {
        public static let _100 = Color(hex: 0xFFCA_FAE3)
        public static let _300 = Color(hex: 0xFF7E_E7B4)
        public static let _500 = Color(hex: 0xFF06_D16F)
        public static let _700 = Color(hex: 0xFF00_A756)
        public static let _900 = Color(hex: 0xFF00_713A)
    }

    public enum LatexPurple {
        public static let _100 = Color(hex: 0xFFEF_E0FE)
        public static let _300 = Color(hex: 0xFFAC_68F0)
        public static let _500 = Color(hex: 0xFF77_08E7)
        public static let _700 = Color(hex: 0xFF54_04A5)
        public static let _900 = Color(hex: 0xFF2F_0E50)
    }

    public enum BearHoney {
        public static let _100 = Color(hex: 0xFFFF_E1BA)
        public static let _300 = Color(hex: 0xFFF5_B866)
        public static let _500 = Color(hex: 0xFFE9_A142)
        public static let _700 = Color(hex: 0xFFDA_7C00)
        public static let _900 = Color(hex: 0xFF8E_5304)
    }

    public enum RedFree {
        public static let _100 = Color(hex: 0xFFFD_D3D8)
        public static let _300 = Color(hex: 0xFFF8_274A)
        public static let _500 = Color(hex: 0xFFE8_082D)
        public static let _700 = Color(hex: 0xFFB6_0000)
        public static let _900 = Color(hex: 0xFF84_0014)
    }

    public enum PurplePro {
        public static let _100 = Color(hex: 0xFFF8_BFFF)
        public static let _300 = Color(hex: 0xFFB4_42C3)
        public static let _500 = Color(hex: 0xFF8C_1A9B)
        public static let _700 = Color(hex: 0xFF64_0073)
        public static let _900 = Color(hex: 0xFF4B_0056)
    }

    public enum Orange {
        public static let _100 = Color(hex: 0xFFEA_E3DF)
        public static let _300 = Color(hex: 0xFFED_CFBF)
        public static let _500 = Color(hex: 0xFFEC_7C3C)
        public static let _700 = Color(hex: 0xFFBB_4C0C)
        public static let _900 = Color(hex: 0xFF77_3008)
    }

    public enum Emerald {
        public static let _100 = Color(hex: 0xFFCA_FAE3)
        public static let _300 = Color(hex: 0xFF7E_E7B4)
        public static let _500 = Color(hex: 0xFF06_D16F)
        public static let _700 = Color(hex: 0xFF00_A756)
        public static let _900 = Color(hex: 0xFF00_713A)
    }

    public static let transparent = Color.clear
}

extension Color {
    @inlinable public init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }

    public func asUIColor() -> UIColor {
        UIColor(self)
    }
}
