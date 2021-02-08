import SwiftUI
import Slab

public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation(percent value: Double) {
        appendInterpolation(value, using: NumberFormatter.percentageFormatter)
    }
    
    mutating func appendInterpolation(euros value: Double) {
        appendInterpolation(value, using: NumberFormatter.euroFormatter)
    }
    
    mutating func appendInterpolation(_ value: Double, using formater: NumberFormatter) {
        if let result = formater.string(from: NSNumber(value: value)) {
            appendLiteral(result)
        }
    }
}
