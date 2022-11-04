import SwiftUI

extension Path {
    public init(lineFrom startPoint: CGPoint, to endPoint: CGPoint) {
        self.init()
        self.move(to: startPoint)
        self.addLine(to: endPoint)
    }
    
    public init(lineBetween points: [CGPoint]) {
        self.init()
        points.first.map { self.move(to: $0) }
        points[1...].forEach { self.addLine(to: $0) }
    }
}
