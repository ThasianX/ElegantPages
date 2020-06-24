// Kevin Li - 11:53 PM - 6/23/20

import SwiftUI

struct ElegantHPagesExample: View {

    let pageCount = 3
    let manager: ElegantPagesManager

    init() {
        manager = ElegantPagesManager(startingPage: 1, pageTurnType: .earlyCutOffDefault)
        manager.delegate = self
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ElegantHPages(manager: manager) {
                CustomButtonView()
                CustomView()
                CustomListView()
            }

            ScrollToPageButton(pageCount: pageCount, action: manager.scroll)
                .padding(.top, 90)
                .padding(.trailing, 30)
        }
    }

}

extension ElegantHPagesExample: ElegantPagesDelegate {

    func elegantPages(willDisplay page: Int) {
        print("Page \(page) will display")
    }

}

struct ElegantHPagesExample_Previews: PreviewProvider {
    static var previews: some View {
        ElegantHPagesExample()
    }
}
