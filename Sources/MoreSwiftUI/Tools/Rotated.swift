import SwiftUI

private struct SizeKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func captureSize(in binding: Binding<CGSize>) -> some View {
        overlay(GeometryReader { proxy in
            Color.clear.preference(key: SizeKey.self, value: proxy.size)
        })
        .onPreferenceChange(SizeKey.self) { size in binding.wrappedValue = size }
    }
}

struct Rotated<Rotated: View>: View {
    var view: Rotated
    var angle: Angle
    
    init(_ view: Rotated, angle: Angle = .degrees(-90)) {
        self.view = view
        self.angle = angle
    }
    
    @State private var size: CGSize = .zero
    
    var body: some View {
        // Rotate the frame, and compute the smallest integral frame that contains it
        let newFrame = CGRect(origin: .zero, size: size)
            .offsetBy(dx: -size.width/2, dy: -size.height/2)
            .applying(.init(rotationAngle: CGFloat(angle.radians)))
            .integral
        
        return view
            .fixedSize()                    // Don't change the view's ideal frame
            .captureSize(in: $size)         // Capture the size of the view's ideal frame
            .rotationEffect(angle)          // Rotate the view
            .frame(width: newFrame.width,   // And apply the new frame
                   height: newFrame.height)
    }
}

struct Askew<Skewed: View>: View {
    var view: Skewed
    var angle: Angle
    
    init(_ view: Skewed, angle: Angle = .degrees(10)) {
        self.view = view
        self.angle = angle
    }
    
    @State private var size: CGSize = .zero
    
    var body: some View {
        let newFrame = CGRect(origin: .zero, size: size)
            .offsetBy(dx: -size.width/2, dy: -size.height/2)
            .applying(.skew(degrees: CGFloat(angle.degrees)))
            .integral
        
        return view
            .fixedSize()
            .captureSize(in: $size)
            .transformEffect(.skew(degrees: CGFloat(angle.degrees)))
            .transformEffect(.init(translationX: newFrame.height * tan(angle.radians) / 2, y: 0))
            .frame(width: newFrame.width, height: newFrame.height)
    }
    
    
}

extension View {
    public func rotated(_ angle: Angle) -> some View {
        Rotated(self, angle: angle)
    }
    
    public func askew(_ angle: Angle) -> some View {
        Askew(self, angle: angle)
    }
}


extension CGAffineTransform {
    static func skew(degrees: CGFloat) -> CGAffineTransform {
        var t = CGAffineTransform.identity
        t.c = tan(-degrees * CGFloat.pi / 180)
        return t
    }
}
