// Kevin Li - 6:07 PM - 6/23/20

import SwiftUI

public enum PageTurnType {

    case regular(pageTurnDelta: CGFloat)
    case earlyCutoff(config: EarlyCutOffConfiguration)

    var pageTurnAnimation: Animation {
        switch self {
        case .regular:
            return .easeInOut
        case let .earlyCutoff(config):
            return config.pageTurnAnimation
        }
    }

}

public struct EarlyCutOffConfiguration {

    let scrollResistanceCutOff: CGFloat
    let pageTurnCutOff: CGFloat
    let pageTurnAnimation: Animation

}

public extension PageTurnType {

    static let regularDefault = Self.regular(pageTurnDelta: 0.5)
    static let earlyCutOffDefault = Self.earlyCutoff(config: .default)

}

public extension EarlyCutOffConfiguration {

    static let `default` = EarlyCutOffConfiguration(
        scrollResistanceCutOff: 40,
        pageTurnCutOff: 80,
        pageTurnAnimation: .spring(response: 0.4, dampingFraction: 0.95))

}
