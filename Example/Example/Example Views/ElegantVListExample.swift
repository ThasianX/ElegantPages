// Kevin Li - 11:49 PM - 6/23/20

import SwiftUI

struct ElegantVListExample: View {

    let pageCount = 40
    let manager: ElegantListManager

    init() {
        manager = ElegantListManager(pageCount: pageCount, pageTurnType: .earlyCutOffDefault)
        manager.datasource = self
        manager.delegate = self
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ElegantVList(manager: manager)

            ScrollToPageButton(pageCount: pageCount, action: manager.scroll)
                .padding(.top, 90)
                .padding(.trailing, 30)
        }
    }

}

extension ElegantVListExample: ElegantPagesDataSource {

    func elegantPages(viewForPage page: Int) -> AnyView {
        VStack {
            Text("Page \(page)")
                .font(.largeTitle)
            Text("Ideally, this should be more dynamic content to make the most use out of this list")
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
