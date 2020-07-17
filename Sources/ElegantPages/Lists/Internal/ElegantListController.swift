// Kevin Li - 6:14 PM - 6/23/20

import SwiftUI

private class UpdateUIViewControllerBugFixClass { }

struct ElegantListController: UIViewControllerRepresentable, ElegantListManagerDirectAccess {

    typealias UIViewControllerType = ElegantTriadPagesController

    // See https://stackoverflow.com/questions/58635048/in-a-uiviewcontrollerrepresentable-how-can-i-pass-an-observedobjects-value-to
    private let bugFix = UpdateUIViewControllerBugFixClass()

    @ObservedObject var manager: ElegantListManager

    let axis: Axis
    let length: CGFloat

    func makeUIViewController(context: Context) -> ElegantTriadPagesController {
        ElegantTriadPagesController(manager: manager, axis: axis, length: length)
    }

    func updateUIViewController(_ controller: ElegantTriadPagesController, context: Context) {
        DispatchQueue.main.async {
            self.setProperPage(for: controller)
        }
    }

    private func setProperPage(for controller: ElegantTriadPagesController) {
        switch currentPage.state {
        case .rearrange:
            controller.rearrange(manager: manager) {
                self.setActiveIndex(1, animated: false, complete: true) // resets to center
            }
        case let .scroll(animated):
            let isFirstPage = currentPage.index == 0
            let isLastPage = currentPage.index == pageCount-1

            if isFirstPage || isLastPage {
                let pageToTurnTo = isFirstPage ? 0 : maxPageIndex
                setActiveIndex(pageToTurnTo, animated: animated, complete: true)
                controller.reset(manager: manager)
            } else {
                let pageToTurnTo = currentPage.index > controller.previousPage ? maxPageIndex : 0
                // This first call to `setActiveIndex` is responsible for animating the page
                // turn to whatever page we want to scroll to
                setActiveIndex(pageToTurnTo, animated: animated, complete: false)
                controller.reset(manager: manager) {
                    self.setActiveIndex(1, animated: false, complete: true)
                }
            }
        case .completed:
            ()
        }
    }

    private func setActiveIndex(_ index: Int, animated: Bool, complete: Bool) {
        withAnimation(animated ? pageTurnAnimation : nil) {
            self.manager.activeIndex = index
        }

        if complete {
            manager.currentPage.state = .completed
        }
    }

}

class ElegantTriadPagesController: UIViewController {

    private var controllers: [UIHostingController<AnyView>]
    private(set) var previousPage: Int

    let axis: Axis

    init(manager: ElegantListManager, axis: Axis, length: CGFloat) {
        self.axis = axis
        previousPage = manager.currentPage.index

        controllers = manager.pageRange.map { page in
            UIHostingController(rootView: manager.datasource.elegantPages(viewForPage: page))
        }
        super.init(nibName: nil, bundle: nil)

        controllers.enumerated().forEach { i, controller in
            addChild(controller)

            if axis == .horizontal {
                controller.view.frame = CGRect(x: screen.width * CGFloat(i),
                                               y: 0,
                                               width: screen.width,
                                               height: length)
            } else {
                controller.view.frame = CGRect(x: 0,
                                               y: screen.height * CGFloat(i),
                                               width: length,
                                               height: screen.height)
            }

            view.addSubview(controller.view)
            controller.didMove(toParent: self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rearrange(manager: ElegantListManager, completion: @escaping () -> Void) {
        defer {
            previousPage = manager.currentPage.index
            manager.delegate?.elegantPages(willDisplay: manager.currentPage.index)
        }

        // rearrange if...
        guard manager.currentPage.index != previousPage && // not same page
            (previousPage != 0 &&
                manager.currentPage.index != 0) && // not 1st or 2nd page
            (previousPage != manager.pageCount-1 &&
                manager.currentPage.index != manager.pageCount-1) // not last page or 2nd to last page
        else { return }

        rearrangeControllersAndUpdatePage(manager: manager)
        resetPagePositions()
        completion()
    }

    private func rearrangeControllersAndUpdatePage(manager: ElegantListManager) {
        if manager.currentPage.index > previousPage { // scrolled down
            controllers.append(controllers.removeFirst())
            controllers.last!.rootView = manager.datasource.elegantPages(viewForPage: manager.currentPage.index+1)
        } else { // scrolled up
            controllers.insert(controllers.removeLast(), at: 0)
            controllers.first!.rootView = manager.datasource.elegantPages(viewForPage: manager.currentPage.index-1)
        }
    }

    private func resetPagePositions() {
        controllers.enumerated().forEach { i, controller in
            if axis == .horizontal {
                controller.view.frame.origin = CGPoint(x: screen.width * CGFloat(i), y: 0)
            } else {
                controller.view.frame.origin = CGPoint(x: 0, y: screen.height * CGFloat(i))
            }
        }
    }

    func reset(manager: ElegantListManager, completion: (() -> Void)? = nil) {
        defer {
            previousPage = manager.currentPage.index
            manager.delegate?.elegantPages(willDisplay: manager.currentPage.index)
        }

        zip(controllers, manager.pageRange).forEach { controller, page in
            controller.rootView = manager.datasource.elegantPages(viewForPage: page)
        }

        completion?()
    }

}

private extension ElegantListManager {

    var pageRange: ClosedRange<Int> {
        let startingPage: Int

        if currentPage.index == pageCount-1 {
            startingPage = (pageCount-3).clamped(to: 0...pageCount-1)
        } else {
            startingPage = (currentPage.index-1).clamped(to: 0...pageCount-1)
        }

        let trailingPage = (startingPage+2).clamped(to: 0...pageCount-1)

        return startingPage...trailingPage
    }

}
