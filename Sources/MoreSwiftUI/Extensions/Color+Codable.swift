import SwiftUI

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
