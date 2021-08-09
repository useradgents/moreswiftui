import SwiftUI

public struct FrameMeasurer: ViewModifier {
    struct Key: PreferenceKey {
        typealias Value = CGRect
        static var defaultValue: CGRect = .zero
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            value = nextValue()
        }
    }
    
    var frameGetter: (GeometryProxy) -> CGRect
    @Binding var binding: CGRect
    
    public func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { p in
                Color.clear
                    .preference(key: Key.self, value: frameGetter(p))
                    .onPreferenceChange(Key.self, perform: { binding = $0 })
            })
    }
}

public extension View {
    func measureFrame(into binding: Binding<CGRect>, with frameGetter: @escaping (GeometryProxy) -> CGRect) -> some View {
        self.modifier(FrameMeasurer(frameGetter: frameGetter, binding: binding))
    }
    
    func measureFrame(into binding: Binding<CGRect>, fromCoordinateSpaceNamed name: String) -> some View {
        self.modifier(FrameMeasurer(frameGetter: { $0.frame(in: .named(name)) }, binding: binding))
    }
    
    func measureGlobalFrame(into binding: Binding<CGRect>) -> some View {
        self.modifier(FrameMeasurer(frameGetter: { $0.frame(in: .global) }, binding: binding))
    }
    
    func measureLocalFrame(into binding: Binding<CGRect>) -> some View {
        self.modifier(FrameMeasurer(frameGetter: { $0.frame(in: .local) }, binding: binding))
    }
}
