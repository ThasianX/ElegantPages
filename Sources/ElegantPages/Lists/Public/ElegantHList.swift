// Kevin Li - 6:13 PM - 6/23/20

import SwiftUI

public struct ElegantHList: View, ElegantListManagerDirectAccess {

    @ObservedObject public var manager: ElegantListManager
    public let bounces: Bool

    private var pagerWidth: CGFloat {
        screen.width * CGFloat(maxPageIndex+1)
    }

    public init(manager: ElegantListManager, bounces: Bool = false) {
        self.manager = manager
        self.bounces = bounces
    }

    public var body: some View {
        ElegantListView(manager: manager,
                    listView: listView,
                    isHorizontal: true,
                    bounces: bounces)
    }

    private var listView: some View {
        HStack(alignment: .center, spacing: 0) {
            ElegantListController(manager: manager, width: screen.width, axis: .horizontal)
                .frame(width: pagerWidth)
        }
        .frame(width: screen.width, height: screen.height, alignment: .leading)
    }

}

