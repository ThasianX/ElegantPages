// Kevin Li - 6:15 PM - 6/23/20

import Foundation

enum ScrollDirection {

    case backward
    case forward

    var additiveFactor: Int {
        self == .backward ? -1 : 1
    }

}
