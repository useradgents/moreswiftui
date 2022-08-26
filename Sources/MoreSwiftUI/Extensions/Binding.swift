import SwiftUI

public extension Binding {
    @inlinable static func get<T>(_ getter: @escaping () -> T) -> Binding<T> {
        Binding<T>(get: getter, set: { _ in })
    }
    
    /// Promote a `Binding<Value?>` to a `Binding<Value>`, "securely"
    /// (quotation marks because once the initial unwrap has passed, all subsequent unwraps are assumed to succeed.)
    /// Use this in "child views", where the parent view decides to show the child based
    /// on the ".some"-ness of an optional value.
    @inlinable func unwrap<Wrapped>() -> Binding<Wrapped>? where Optional<Wrapped> == Value {
        guard wrappedValue != nil else { return nil }
        return Binding<Wrapped>(get: { wrappedValue! }, set: { self.wrappedValue = $0 })
    }
    
    /// Force-promote a `Binding<Value?>` to a `Binding<Value>`
    @inlinable func forceUnwrap<Wrapped>() -> Binding<Wrapped> where Optional<Wrapped> == Value {
        return Binding<Wrapped>(get: { wrappedValue! }, set: { self.wrappedValue = $0 })
    }
    
    @inlinable func nilIfEmpty() -> Binding<String> where String? == Value {
        Binding<String>(
            get: { wrappedValue ?? "" },
            set: { wrappedValue = $0.nilIfEmpty }
        )
    }
    


    /**
     If you have @State var selection: Int = 0
     and you want a Binding<Bool> for every item of a list
     use $selection.equals(4) for item 4
     */
    @inlinable func equals(_ value: Value) -> Binding<Bool> where Value: Hashable {
        Binding<Bool>.init(
            get: { wrappedValue == value },
            set: { if $0 { wrappedValue = value }}
        )
    }


    /**
     If you have @State var selection: [Whatever] = [whatever1, whatever4]
     (works with arrays or sets)
     and you want a Binding<Bool> for every item of a list
     user $selection.contains(whatever2) for item 2
     */
    @inlinable func contains<T: Hashable>(_ value: T) -> Binding<Bool> where Value == [T] {
        Binding<Bool>.init(
            get: { wrappedValue.contains(value) },
            set: {
                if $0 { if !wrappedValue.contains(value) { wrappedValue.append(value) }}
                else { wrappedValue.removeAll(where: { $0 == value }) }
            }
        )
    }

    @inlinable func contains<T: Hashable>(_ value: T) -> Binding<Bool> where Value == Set<T> {
        Binding<Bool>.init(
            get: { wrappedValue.contains(value) },
            set: {
                if $0 { wrappedValue.insert(value) }
                else { wrappedValue.remove(value) }
            }
        )
    }

    /// Create a Binding suitable for using in previews
    @inlinable static func mock(_ value: Value) -> Self {
        var value = value
        return Binding(get: { value }, set: { value = $0 })
    }
    
    /// Wrapper to listen to didSet of Binding
    @inlinable func didSet(_ didSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
        return .init(get: { self.wrappedValue }, set: { newValue in
            let oldValue = self.wrappedValue
            self.wrappedValue = newValue
            didSet((newValue, oldValue))
        })
    }
    
    /// Wrapper to listen to willSet of Binding
    @inlinable func willSet(_ willSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
        return .init(get: { self.wrappedValue }, set: { newValue in
            willSet((newValue, self.wrappedValue))
            self.wrappedValue = newValue
        })
    }
    
}



@inlinable public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
