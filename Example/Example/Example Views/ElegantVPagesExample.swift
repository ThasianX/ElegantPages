// Kevin Li - 12:00 AM - 6/24/20

import SwiftUI

struct ElegantVPagesExample: View {

    let manager = ElegantPagesManager(startingPage: 1, pageTurnType: .earlyCutOffDefault)

    init() {
        manager.delegate = self
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ElegantVPages(manager: manager) {
                CustomButtonView()
                CustomView()
                CustomListView()
            }

            ScrollToPageButton(pageCount: 3, action: manager.scroll)
                .padding(.top, 90)
                .padding(.trailing, 30)
        }
    }

}

extension ElegantVPagesExample: ElegantPagesDelegate {

    func elegantPages(willDisplay page: Int) {
        print("Page \(page) will display")
    }

}

struct ElegantVPagesExample_Previews: PreviewProvider {
    static var previews: some View {
        ElegantVPagesExample()
    }
}
