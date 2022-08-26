import SwiftUI

/// Use this in Forms to keep the label aligned with others. For custom contents that do not have their own label.
public struct LabeledControl<L: View, C: View>: View {
    public var label: () -> L
    public var contents: () -> C
    
    public init(label: @escaping () -> L, _ contents: @escaping () -> C) {
        self.label = label
        self.contents = contents
    }
    
    @State private var wholeFrame = CGRect.zero
    @State private var contentFrame = CGRect.zero
    public var body: some View {
        HStack {
            label()
            contents().labelsHidden().measureLocalFrame(into: $contentFrame)
        }
        .measureLocalFrame(into: $wholeFrame)
        .alignmentGuide(.leading, computeValue: { _ in wholeFrame.width - contentFrame.width })
    }
}
