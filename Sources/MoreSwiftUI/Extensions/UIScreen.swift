#if os(iOS)
import SwiftUI

extension UIScreen {
    public static var insets: UIEdgeInsets {
        UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
    }
}
#endif
