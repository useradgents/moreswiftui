import SwiftUI

public extension Binding {
    /// Promote a `Binding<Value?>` to a `Binding<Value>`, "securely"
    /// (quotation marks because once the initial unwrap has passed, all subsequent unwraps are assumed to succeed.)
    /// Use this in "child views", where the parent view decides to show the child based
    /// on the ".some"-ness of an optional value.
    func unwrap<Wrapped>() -> Binding<Wrapped>? where Optional<Wrapped> == Value {
        guard wrappedValue != nil else { return nil }
        return Binding<Wrapped>(get: { wrappedValue! }, set: { self.wrappedValue = $0 })
    }
    
    /// Force-promote a `Binding<Value?>` to a `Binding<Value>`
    func forceUnwrap<Wrapped>() -> Binding<Wrapped> where Optional<Wrapped> == Value {
        return Binding<Wrapped>(get: { wrappedValue! }, set: { self.wrappedValue = $0 })
    }
    
    /// Create a Binding suitable for using in previews
    static func mock(_ value: Value) -> Self {
        var value = value
        return Binding(get: { value }, set: { value = $0 })
    }
    
    /// Wrapper to listen to didSet of Binding
    func didSet(_ didSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
        return .init(get: { self.wrappedValue }, set: { newValue in
            let oldValue = self.wrappedValue
            self.wrappedValue = newValue
            didSet((newValue, oldValue))
        })
    }
    
    /// Wrapper to listen to willSet of Binding
    func willSet(_ willSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
        return .init(get: { self.wrappedValue }, set: { newValue in
            willSet((newValue, self.wrappedValue))
            self.wrappedValue = newValue
        })
    }
    
}

public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
