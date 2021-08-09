import SwiftUI

public struct LazyView<Content: View>: View {
    let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}

public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

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

public extension View {
    func log(_ value: Any) -> some View {
        #if DEBUG
        print(value)
        #endif
        return self
    }
    
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
    @ViewBuilder
    func ifLet<V, Transform: View>(
        _ value: V?,
        transform: (Self, V) -> Transform
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifLet<V, Transform: View, TransformElse: View>(
        _ value: V?,
        transform: (Self, V) -> Transform,
        else elseTransform: (Self) -> TransformElse
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            elseTransform(self)
        }
    }
}

