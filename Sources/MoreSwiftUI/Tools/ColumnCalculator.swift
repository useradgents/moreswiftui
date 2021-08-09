import SwiftUI

public struct ColumnCalculator<Content>: View where Content: View {
    let maximumColumnWidth: CGFloat
    let content: (Int) -> Content
    
    public init(maximumColumnWidth: CGFloat, @ViewBuilder content: @escaping (Int) -> Content) {
        self.maximumColumnWidth = maximumColumnWidth
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geo in
            let columns = Int(ceil(geo.size.width / maximumColumnWidth))
            content(columns)
        }
    }
}
