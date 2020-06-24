// Kevin Li - 6:04 PM - 6/23/20

import SwiftUI

public protocol ElegantPagesDataSource {

    func elegantPages(viewForPage page: Int) -> AnyView

}

public protocol ElegantPagesDelegate {

    func elegantPages(willDisplay page: Int)

}
