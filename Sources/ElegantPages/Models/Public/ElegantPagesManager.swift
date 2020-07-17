// Kevin Li - 5:57 PM - 6/23/20

import Combine
import SwiftUI

public class ElegantPagesManager: ObservableObject, PageTurnTypeDirectAccess {

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

    var anyCancellable: AnyCancellable?

    public init(startingPage: Int = 0, pageTurnType: PageTurnType) {
        currentPage = startingPage
        self.pageTurnType = pageTurnType
    }

    public func scroll(to page: Int, animated: Bool = true) {
        withAnimation(animated ? pageTurnAnimation : nil) {
            currentPage = page
        }
    }

}

protocol ElegantPagesManagerDirectAccess: PageTurnTypeDirectAccess {

    var manager: ElegantPagesManager { get }
    var pageTurnType: PageTurnType { get }

}

extension ElegantPagesManagerDirectAccess {

    var currentPage: Int {
        manager.currentPage
    }

    var pageTurnType: PageTurnType {
        manager.pageTurnType
    }

}
