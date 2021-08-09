import SwiftUI

public struct ReportingScrollView<Content>: View where Content: View {
    let axes: Axis.Set
    let showIndicators: Bool
    @Binding var contentOffset: CGPoint
    @Binding var contentSize: CGSize
    @Binding var scrollViewSize: CGSize
    
    let content: Content
    
    public init(_ axes: Axis.Set = .vertical, showIndicators: Bool = true, contentOffset: Binding<CGPoint>? = nil, contentSize: Binding<CGSize>? = nil, scrollViewSize: Binding<CGSize>? = nil, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        self._contentOffset = contentOffset ?? .constant(.zero)
        self._contentSize = contentSize ?? .constant(.zero)
        self._scrollViewSize = scrollViewSize ?? .constant(.zero)
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { outerProxy in
            ScrollView(self.axes, showsIndicators: self.showIndicators) {
                ZStack(alignment: .topLeading) {
                    GeometryReader { innerProxy in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: CGPoint(
                                x: outerProxy.frame(in: .global).minX - innerProxy.frame(in: .global).minX,
                                y: outerProxy.frame(in: .global).minY - innerProxy.frame(in: .global).minY
                            )
                        )
                    }
                    VStack {
                        self.content
                    }
                }
                .background(GeometryReader { contentBackground in
                    Color.clear.preference(
                        key: ContentSizePreferenceKey.self,
                        value: contentBackground.size
                    )
                })
            }
            .background(GeometryReader { scrollBackground in
                Color.clear.preference(
                    key: OuterSizePreferenceKey.self,
                    value: scrollBackground.size
                )
            })
            
            // Bubble them up
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.contentOffset = value
            }
            .onPreferenceChange(ContentSizePreferenceKey.self) { value in
                self.contentSize = value
            }
            .onPreferenceChange(OuterSizePreferenceKey.self) { value in
                self.scrollViewSize = value
            }
        }
    }
}

fileprivate struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGPoint
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        let next = nextValue()
        value = CGPoint(x: value.x + next.x, y: value.y + next.y)
    }
}

fileprivate struct ContentSizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        value = CGSize(width: value.width + next.width, height: value.height + next.height)
    }
}

fileprivate struct OuterSizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        value = CGSize(width: value.width + next.width, height: value.height + next.height)
    }
}
 
