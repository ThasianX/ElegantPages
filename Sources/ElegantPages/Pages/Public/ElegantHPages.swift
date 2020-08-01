// Kevin Li - 6:11 PM - 6/23/20

import SwiftUI

public struct ElegantHPages<Pages>: View where Pages: View {

    public let manager: ElegantPagesManager
    public let bounces: Bool
    public let pages: PageContainer<Pages>

    public init(manager: ElegantPagesManager,
                bounces: Bool = false,
                @PageViewBuilder builder: () -> PageContainer<Pages>) {
        self.manager = manager
        self.bounces = bounces
        self.pages = builder()
    }

    public var body: some View {
        ElegantPagesView(manager: manager,
                         stackView: HorizontalStack(pages: pages),
                         pageCount: pages.count,
                         isHorizontal: true,
                         bounces: bounces)
    }

}

private struct HorizontalStack<Pages>: View where Pages: View {

    let pages: Pages

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            pages
                .frame(width: screen.width, height: screen.height)
        }
        .frame(width: screen.width, height: screen.height, alignment: .leading)
    }

}

extension ElegantHPages {

    public func onPageChanged(_ callback: ((Int) -> Void)?) -> Self {
        manager.anyCancellable = manager.$currentPage
            .dropFirst()
            .sink { page in
                callback?(page)
            }
        return self
    }

}
