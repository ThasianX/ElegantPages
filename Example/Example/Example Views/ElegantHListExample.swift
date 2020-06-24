// Kevin Li - 11:08 PM - 6/23/20

import SwiftUI



struct ElegantHListExample: View {

    let manager: ElegantListManager

    init() {
        manager = ElegantListManager(pageCount: 25, pageTurnType: .earlyCutOffDefault)
        manager.datasource = self
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension ElegantHListExample: ElegantPagesDataSource {

    func elegantPages(viewForPage page: Int) -> AnyView {
        <#code#>
    }

}

struct ElegantHListExample_Previews: PreviewProvider {
    static var previews: some View {
        ElegantHListExample()
    }
}
