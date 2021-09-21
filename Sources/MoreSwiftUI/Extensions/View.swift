import SwiftUI

public extension View {
    func log(_ value: Any) -> some View {
#if DEBUG
        print(value)
#endif
        return self
    }
    
    func safeTopPadding() -> some View {
        self.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
    }
    
    func safeBottomPadding() -> some View {
        self.padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
    }
    
    /// Don't use this. It's bad.
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
    
    /// Don't use this. It's bad.
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
    
    /// Don't use this. It's bad.
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
    
    /// Don't use this. It's bad.
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
