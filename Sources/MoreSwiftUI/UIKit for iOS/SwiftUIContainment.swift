#if !os(macOS)

import SwiftUI
import UIKit

public extension UIViewController {
    func addSwiftUIView<Content>(_ swiftUIView: Content, to view: UIView) where Content: View {
        let host = UIHostingController(rootView: swiftUIView)
        addChild(host)
        view.addSubview(host.view)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            host.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        host.didMove(toParent: self)
    }
}

#endif
