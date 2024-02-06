import SwiftUI

// System colors from UIKit that were mysteriously left out of SwiftUI
@available(iOS 15.0, *)
public extension Color {
    // primary and secondary already exist, tied to label and secondaryLabel
    static let tertiary = Color(uiColor: .tertiaryLabel)
    static let quaternary = Color(uiColor: .quaternaryLabel)
    
    static let label = Color(uiColor: .label)
    static let label2 = Color(uiColor: .secondaryLabel)
    static let label3 = Color(uiColor: .tertiaryLabel)
    static let label4 = Color(uiColor: .quaternaryLabel)
    
    static let link = Color(uiColor: .link)
    
    static let placeholder = Color(uiColor: .placeholderText)
    
    static let separator = Color(uiColor: .separator)
    static let opaqueSeparator = Color(uiColor: .opaqueSeparator)
    
    static let background = Color(uiColor: .systemBackground)
    static let background2 = Color(uiColor: .secondarySystemBackground)
    static let background3 = Color(uiColor: .tertiarySystemBackground)
    
    static let groupedBackground = Color(uiColor: .systemGroupedBackground)
    static let groupedBackground2 = Color(uiColor: .secondarySystemGroupedBackground)
    static let groupedBackground3 = Color(uiColor: .tertiarySystemGroupedBackground)
    
    
    static let fill = Color(uiColor: .systemFill)
    static let fill2 = Color(uiColor: .secondarySystemFill)
    static let fill3 = Color(uiColor: .tertiarySystemFill)
    static let fill4 = Color(uiColor: .quaternarySystemFill)
    
    static let lightText = Color(uiColor: .lightText)
    static let darkText = Color(uiColor: .darkText)
}

#if canImport(UIKit)
import UIKit
@available(iOS 15.0, *)
public extension Color {
    init(light: String, dark: String) {
        self.init(uiColor: .init(light: .init(light), dark: .init(dark)))
    }
    
    init(both: String) {
        self.init(uiColor: .init(both))
    }
}

public extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traits in
            switch traits.userInterfaceStyle {
                case .dark: dark
                default: light
            }
        }
    }
    
    convenience init(_ hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            self.init()
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        
        return NSString(format: "#%06x", rgb) as String
    }
}
#endif

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var string = try container.decode(String.self)
        // RGB → RGBA
        if string.count == 7 { string.append("FF") }
        
        let scanner = Scanner(string: string)
        guard let hash = scanner.scanCharacter(), hash == "#" else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected leading #")
        }
        
        var rgba: UInt64 = 0
        guard scanner.scanHexInt64(&rgba) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unreadable hex data")
        }
        
        let r = CGFloat((rgba & 0xFF00_0000) >> 24) / 255.0
        let g = CGFloat((rgba & 0x00FF_0000) >> 16) / 255.0
        let b = CGFloat((rgba & 0x0000_FF00) >> 8) / 255.0
        let a = CGFloat((rgba & 0x0000_00FF) >> 0) / 255.0
        
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    public func encode(to encoder: Encoder) throws {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if let cg = cgColor?.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil), let cmp = cg.components, cmp.count == 4 {
            r = cmp[0]
            g = cmp[1]
            b = cmp[2]
            a = cmp[3]
        }
        
        let R = Int(round(r * 255))
        let G = Int(round(g * 255))
        let B = Int(round(b * 255))
        let A = Int(round(a * 255))
        
        var container = encoder.singleValueContainer()
        if A < 255 {
            try container.encode(String(format: "#%02X%02X%02X%02X", R, G, B, A))
        }
        else {
            try container.encode(String(format: "#%02X%02X%02X", R, G, B))
        }
    }
}
