// Kevin Li - 8:30 PM - 6/23/20

import SwiftUI

public struct ElegantVPages<Pages>: View where Pages: View {

    let manager: ElegantPagesManager
    let bounces: Bool
    let pages: PageContainer<Pages>

    public init(manager: ElegantPagesManager,
                bounces: Bool = false,
                @PageViewBuilder builder: () -> PageContainer<Pages>) {
        self.manager = manager
        self.bounces = bounces
        self.pages = builder()
    }

    public var body: some View {
        ElegantPages(manager: manager,
                         stackView: VerticalStack(pages: pages),
                         pageCount: pages.count,
                         isHorizontal: false,
                         bounces: bounces)
    }

}

private struct VerticalStack<Pages>: View where Pages: View {

    let pages: Pages

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            pages
                .frame(width: screen.width, height: screen.height)
        }
        .frame(width: screen.width, height: screen.height, alignment: .top)
    }

}
