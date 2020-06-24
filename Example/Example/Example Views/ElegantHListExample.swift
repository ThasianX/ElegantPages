// Kevin Li - 11:08 PM - 6/23/20

import SwiftUI

let hListData = (1...40).map { _ in "Ideally, this should be more dynamic content to make the most use out of this list" }

struct ElegantHListExample: View {

    let manager = ElegantListManager(pageCount: hListData.count, pageTurnType: .earlyCutOffDefault)

    init() {
        manager.datasource = self
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ElegantHList(manager: manager)

            ScrollToPageButton(pageCount: hListData.count, action: manager.scroll)
                .padding(.top, 90)
                .padding(.trailing, 30)
        }
    }

}

extension ElegantHListExample: ElegantPagesDataSource {

    func elegantPages(viewForPage page: Int) -> AnyView {
        VStack {
            Text("Page \(page)")
                .font(.largeTitle)
            Text(hListData[page])
                .font(.title)
        }
        .padding()
        .erased
    }

}

extension ElegantHListExample: ElegantPagesDelegate {

    func elegantPages(willDisplay page: Int) {
        print("Page \(page) will display")
    }

}

struct ElegantHListExample_Previews: PreviewProvider {
    static var previews: some View {
        ElegantHListExample()
    }
}
