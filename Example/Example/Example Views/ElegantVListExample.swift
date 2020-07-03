// Kevin Li - 11:49 PM - 6/23/20

import SwiftUI

let vListData = (1...40).map { _ in "Ideally, this should be more dynamic content to make the most use out of this list" }

struct ElegantVListExample: View {

    let manager = ElegantListManager(pageCount: vListData.count, pageTurnType: .earlyCutOffDefault)

    init() {
        manager.datasource = self
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ElegantVList(manager: manager)

            ScrollToPageButton(pageCount: vListData.count, action: animatedScroll)
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

extension ElegantVListExample: ElegantPagesDataSource {

    func elegantPages(viewForPage page: Int) -> AnyView {
        VStack {
            Text("Page \(page)")
                .font(.largeTitle)
            Text(vListData[page])
                .font(.title)
        }
        .padding()
        .erased
    }

}

extension ElegantVListExample: ElegantPagesDelegate {

    func elegantPages(willDisplay page: Int) {
        print("Page \(page) will display")
    }

}

struct ElegantVListExample_Previews: PreviewProvider {
    static var previews: some View {
        ElegantVListExample()
    }
}
