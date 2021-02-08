import SwiftUI
import UIKit

public struct PageView<Page: View>: View {
    var viewControllers: [UIHostingController<Page>]
    @Binding var currentPage: Int
    
    public init(currentPage: Binding<Int>, _ views: [Page]) {
        self._currentPage = currentPage
        self.viewControllers = views.map {
            let foo = MagicHostingViewController(rootView: $0)
            foo.fixSafeAreaInsets()
            return foo
        }
    }
    
    public var body: some View {
        PageViewController(controllers: viewControllers, currentPage: $currentPage)
    }
}

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var currentPage: Int
    
    init(controllers: [UIViewController], currentPage: Binding<Int>) {
        self.controllers = controllers
        self._currentPage = currentPage
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: false, completion: nil)
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
//        guard !controllers.isEmpty else { return }
//        let direction: UIPageViewController.NavigationDirection = previousPage < currentPage ? .forward : .reverse
//        context.coordinator.parent = self
//        pageViewController.setViewControllers(
//            [controllers[currentPage]],
//            direction: direction,
//            animated: true)
//        { _ in
////            previousPage = currentPage
//        }
    }
        
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        
        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return nil //parent.controllers.last
            }
            return parent.controllers[index - 1]
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.controllers.count {
                return nil //parent.controllers.first
            }
            return parent.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = parent.controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
}

// https://twitter.com/b3ll/status/1193747288302075906
// Thank you, Adam Bell
class MagicHostingViewController<Content: View>: UIHostingController<Content> {
    func fixSafeAreaInsets() {
        guard let _class = view?.classForCoder else { return }
        let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { (sself: AnyObject!) -> UIEdgeInsets in .zero }
        guard let method = class_getInstanceMethod(_class.self, #selector(getter: UIView.safeAreaInsets)) else { return }
        class_replaceMethod(_class, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
        
        let safeAreaLayoutGuide: @convention(block) (AnyObject) -> UILayoutGuide? = { (sself: AnyObject!) -> UILayoutGuide? in nil }
        guard let method2 = class_getInstanceMethod(_class.self, #selector(getter: UIView.safeAreaLayoutGuide)) else { return }
        class_replaceMethod(_class, #selector(getter: UIView.safeAreaLayoutGuide), imp_implementationWithBlock(safeAreaLayoutGuide), method_getTypeEncoding(method2))
    }
    
    override var prefersStatusBarHidden: Bool { true }
}
