// Kevin Li - 6:04 PM - 6/23/20

import SwiftUI

public protocol ElegantPagerDataSource {

    func view(for page: Int) -> AnyView

}

public protocol ElegantPagerDelegate {

    func willDisplay(page: Int)

}
