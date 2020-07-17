// Kevin Li - 6:13 PM - 6/23/20

import SwiftUI

public struct ElegantHList: View, ElegantListManagerDirectAccess {

    @ObservedObject public var manager: ElegantListManager
    public let bounces: Bool
    public let viewForPage: (Int) -> AnyView

    private var pagerWidth: CGFloat {
        screen.width * CGFloat(maxPageIndex+1)
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
                            isHorizontal: true,
                            bounces: self.bounces)
        }
    }

    private func listView(geometry: GeometryProxy) -> some View {
        HStack(alignment: .center, spacing: 0) {
            ElegantListController(manager: manager,
                                  axis: .horizontal,
                                  length: geometry.size.height,
                                  viewForPage: viewForPage)
                .frame(width: pagerWidth)
        }
        .frame(width: screen.width, height: geometry.size.height, alignment: .leading)
    }

}

