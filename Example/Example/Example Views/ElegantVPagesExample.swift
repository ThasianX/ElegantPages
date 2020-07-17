// Kevin Li - 12:00 AM - 6/24/20

import SwiftUI

struct ElegantVPagesExample: View {

    let manager = ElegantPagesManager(startingPage: 1, pageTurnType: .earlyCutOffDefault)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ElegantVPages(manager: manager) {
                CustomButtonView()
                CustomView()
                CustomListView()
            }
            .onPageChanged { page in
                print("Page \(page) will display")
            }

            ScrollToPageButton(pageCount: 3, action: animatedScroll)
                .padding(.top, 90)
                .padding(.trailing, 30)
        }
    }

    private func animatedScroll(to page: Int) {
        manager.scroll(to: page)
    }

    private func unanimatedScroll(to page: Int) {
        manager.scroll(to: page, animated: false)
    }

}

struct ElegantVPagesExample_Previews: PreviewProvider {
    static var previews: some View {
        ElegantVPagesExample()
    }
}
