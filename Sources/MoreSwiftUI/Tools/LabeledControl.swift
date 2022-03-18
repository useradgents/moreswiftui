import SwiftUI

/// Use this in Forms to keep the label aligned with others. For custom contents that do not have their own label.
public struct LabeledControl<L: View, C: View>: View {
    public var label: () -> L
    public var contents: () -> C
    
    public init(label: @escaping () -> L, _ contents: @escaping () -> C) {
        self.label = label
        self.contents = contents
    }
    
    @State private var frame = CGRect.zero
    public var body: some View {
        HStack {
            label()
            contents().measureLocalFrame(into: $frame)
        }.alignmentGuide(.leading, computeValue: { $0.width - frame.width })
    }
}
