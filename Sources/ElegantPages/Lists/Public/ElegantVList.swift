// Kevin Li - 6:13 PM - 6/23/20

import SwiftUI

public struct ElegantVList: View, ElegantListManagerDirectAccess {

    @ObservedObject public var manager: ElegantListManager
    public let bounces: Bool
    public let viewForPage: (Int) -> AnyView

    private var pagerHeight: CGFloat {
        screen.height * CGFloat(maxPageIndex+1)
    }

    public init(manager: ElegantListManager,
                bounces: Bool = false,
                viewForPage: @escaping (Int) -> AnyView) {
        self.manager = manager
        self.bounces = bounces
        self.viewForPage = viewForPage
    }

    public var body: some View {
        GeometryReader { geometry in
            ElegantListView(manager: self.manager,
                            listView: self.listView(geometry: geometry),
                            isHorizontal: false,
                            bounces: self.bounces)
        }
    }

    private func listView(geometry: GeometryProxy) -> some View {
        VStack(alignment: .center, spacing: 0) {
            ElegantListController(manager: manager,
                                  axis: .vertical,
                                  length: geometry.size.width,
                                  viewForPage: viewForPage)
                .frame(height: pagerHeight)
        }
        .frame(width: geometry.size.width, height: screen.height, alignment: .top)
    }

}
