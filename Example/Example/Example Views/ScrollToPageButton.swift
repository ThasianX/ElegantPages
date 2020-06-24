// Kevin Li - 11:50 PM - 6/23/20

import SwiftUI

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
