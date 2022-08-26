import SwiftUI

extension View {
    public func withFrameDebugger(_ name: String, _ color: Color, _ align: Alignment = .topLeading, _ supplementaryText: (() -> String)? = nil) -> some View {
        self.modifier(FrameDebugger(name: name, color: color, alignment: align, supplementaryText: supplementaryText))
    }
}

struct FrameDebugger: ViewModifier {
    @State private var frame: CGRect = .zero
    var name: String
    var color: Color
    var alignment: Alignment
    var padded: Bool
    
    var supplementaryText: (() -> String)?
    
    init(name: String, color: Color, alignment: Alignment = .topLeading, padded: Bool = false, supplementaryText: (() -> String)? = nil) {
        self.name = name
        self.color = color
        self.alignment = alignment
        self.padded = padded
        self.supplementaryText = supplementaryText
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, macOS 12.0, *) {
            content
                .padding(padded ? 1 : 0)
                .measureLocalFrame(into: $frame)
                .border(color, width: 1)
                .overlay(
                    Text(text)
                        .font(.caption2)
                        .padding(3)
                        .background(color, ignoresSafeAreaEdges: []),
                    alignment: alignment
                )
        } else {
            content
                .padding(padded ? 1 : 0)
                .measureLocalFrame(into: $frame)
                .border(color, width: 1)
                .overlay(
                    Text(text)
                        .font(.caption2)
                        .padding(3)
                        .background(color),
                    alignment: alignment
                )
        }
    }
    
    private var text: String {
        var ret = "\(name) — \(frame.size.width, using: .decimal)×\(frame.size.height, using: .decimal)"
        if let supplementaryText = supplementaryText {
            ret += "\n" + supplementaryText()
        }
        return ret
    }
}
