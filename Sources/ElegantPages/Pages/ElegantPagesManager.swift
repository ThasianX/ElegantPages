// Kevin Li - 5:57 PM - 6/23/20

import Foundation
import SwiftUI

let screen = UIScreen.main.bounds
let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

public class ElegantPagesManager: ObservableObject {

    /**
        The index of current page 0...N-1.

        To set a new current page with animation, use `scroll(to:)`.
        If you want a `Binding` variable, you can create a custom `Binding` through:
        ```
        let binding = Binding(
            get: { self.manager.currentPage },
            set: { self.manager.scroll(to: $0) })
        ```
    */
    @Published public var currentPage: Int

    public let pageTurnType: PageTurnType

    public var delegate: ElegantPagerDelegate?

    public init(startingPage: Int = 0, pageTurnType: PageTurnType) {
        currentPage = startingPage
        self.pageTurnType = pageTurnType
    }

    public func scroll(to page: Int) {
        withAnimation(pageTurnType.pageTurnAnimation) {
            currentPage = page
        }
        delegate?.willDisplay(page: page)
    }

}

protocol ElegantSimplePagerManagerDirectAccess {

    var pagerManager: ElegantPagesManager { get }

}

extension ElegantSimplePagerManagerDirectAccess {

    var currentPage: Int {
        pagerManager.currentPage
    }

    var pageTurnType: PageTurnType {
        pagerManager.pageTurnType
    }

    var pageTurnAnimation: Animation {
        pageTurnType.pageTurnAnimation
    }

    var delegate: ElegantPagerDelegate? {
        pagerManager.delegate
    }

}
