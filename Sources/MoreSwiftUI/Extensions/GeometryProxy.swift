import SwiftUI

public extension GeometryProxy {
    var diagonal: CGFloat {
        sqrt(size.width * size.width + size.height * size.height)
    }
    
    var angle: CGFloat {
        atan2(size.width, size.height)
    }
}
