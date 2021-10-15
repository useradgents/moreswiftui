import SwiftUI
import Slab

public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation(percent value: Double) {
        appendInterpolation(value, using: NumberFormatter.percentage)
    }
    
    mutating func appendInterpolation(euros value: Double) {
        appendInterpolation(value, using: NumberFormatter.euros)
    }
    
    mutating func appendInterpolation(euros value: Decimal) {
        appendInterpolation(value, using: NumberFormatter.euros)
    }
    
    mutating func appendInterpolation(_ value: Double, using formater: NumberFormatter) {
        if let result = formater.string(from: NSNumber(value: value)) {
            appendLiteral(result)
        }
    }
    
    mutating func appendInterpolation(_ value: Float, using formater: NumberFormatter) {
        if let result = formater.string(from: NSNumber(value: value)) {
            appendLiteral(result)
        }
    }
    
    mutating func appendInterpolation(_ value: Decimal, using formater: NumberFormatter) {
        if let result = formater.string(from: value as NSNumber) {
            appendLiteral(result)
        }
    }
    
    mutating func appendInterpolation(_ value: Int, using formater: NumberFormatter) {
        if let result = formater.string(from: NSNumber(value: value)) {
            appendLiteral(result)
        }
    }
    
    public mutating func appendInterpolation(_ value: Date, using formatter: DateFormatter) {
        appendLiteral(formatter.string(from: value))
    }
}
