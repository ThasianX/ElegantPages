// Kevin Li - 11:08 PM - 6/23/20

import SwiftUI

struct ElegantHListExample: View {

    let pageCount = 40
    let manager: ElegantListManager

    init() {
        manager = ElegantListManager(pageCount: pageCount, pageTurnType: .earlyCutOffDefault)
        manager.datasource = self
        manager.delegate = self
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ElegantHList(manager: manager)

            ScrollToPageButton(pageCount: pageCount, action: manager.scroll)
                .padding(.top, 90)
                .padding(.trailing, 30)
        }
    }

}

struct ScrollToPageButton: View {

    let pageCount: Int
    let action: (Int) -> Void

    var body: some View {
        Button(action: scrollToRandomPage) {
            Image(systemName: "shuffle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
        }
    }

    private func scrollToRandomPage() {
        action(Int.random(in: 0..<pageCount))
    }

}

extension ElegantHListExample: ElegantPagesDataSource {

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
