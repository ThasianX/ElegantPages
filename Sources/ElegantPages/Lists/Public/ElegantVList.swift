// Kevin Li - 6:13 PM - 6/23/20

import SwiftUI

public struct ElegantVList: View, ElegantListManagerDirectAccess {

    @ObservedObject public var manager: ElegantListManager
    public let width: CGFloat
    public let bounces: Bool

    private var pagerHeight: CGFloat {
        screen.height * CGFloat(maxPageIndex+1)
    }

    public init(manager: ElegantListManager, width: CGFloat, bounces: Bool = false) {
        self.manager = manager
        self.width = width
        self.bounces = bounces
    }

    public var body: some View {
        ElegantListView(manager: manager,
                    listView: listView,
                    isHorizontal: false,
                    bounces: bounces)
    }

    private var listView: some View {
        VStack(alignment: .center, spacing: 0) {
            ElegantListController(manager: manager, width: width, axis: .vertical)
                .frame(height: pagerHeight)
        }
        .frame(width: width, height: screen.height, alignment: .top)
    }

}
