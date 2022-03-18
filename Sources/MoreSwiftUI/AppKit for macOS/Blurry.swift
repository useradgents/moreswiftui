import SwiftUI

#if os(macOS)
public struct Blurry: NSViewRepresentable {
    public var material: NSVisualEffectView.Material
    
    public init(material: NSVisualEffectView.Material = .sidebar) {
        self.material = material
    }
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let vev = NSVisualEffectView()
        vev.material = material
        return vev
    }
    
    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}
#endif
