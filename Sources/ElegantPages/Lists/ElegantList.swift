// Kevin Li - 8:48 PM - 6/23/20

import SwiftUI

public struct ElegantList<List>: View, ElegantListManagerDirectAccess where List: View {

    @State private var translation: CGFloat = .zero
    @State private var isTurningPage = false

    @ObservedObject var pagerManager: ElegantListManager

    let listView: List
    let isHorizontal: Bool
    let bounces: Bool

    public var body: some View {
        listView
            .offset(offset)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        let axisOffset = self.isHorizontal ? value.translation.width : value.translation.height
                        let nonAxisOffset = self.isHorizontal ? value.translation.height : value.translation.width

                        guard abs(nonAxisOffset) < abs(axisOffset) else {
                            self.translation = .zero
                            return
                        }

                        withAnimation(self.pageTurnAnimation) {
                            self.setTranslationForOffset(axisOffset)
                            self.turnPageIfNeededForChangingOffset(value.translation.width)
                        }
                    }
                    .onEnded { value in
                        withAnimation(self.pageTurnAnimation) {
                            self.turnPageIfNeededForEndOffset(value.translation.width)
                        }
                    }
            )
    }

}

private extension ElegantList {

    var offset: CGSize {
        if isHorizontal {
            return CGSize(width: horizontalScrollOffset, height: 0.0)
        } else {
            return CGSize(width: 0.0, height: verticalScrollOffset)
        }
    }

    var horizontalScrollOffset: CGFloat {
        horizontalOffset + properTranslation
    }

    var horizontalOffset: CGFloat {
        -CGFloat(activeIndex) * screen.width
    }

    var verticalOffset: CGFloat {
        -CGFloat(activeIndex) * screen.height
    }

    var verticalScrollOffset: CGFloat {
        verticalOffset + properTranslation
    }

    var properTranslation: CGFloat {
        guard !bounces else { return translation }

        if (activeIndex == 0 && translation > 0) ||
            (activeIndex == maxPageIndex && translation < 0) {
            return 0
        }
        return translation
    }

}

private extension ElegantList {

    func setTranslationForOffset(_ offset: CGFloat) {
        switch pageTurnType {
        case .regular:
            translation = offset
        case let .earlyCutoff(config):
            translation = isTurningPage ? 0 : (offset / config.pageTurnCutOff) * config.scrollResistanceCutOff
        }
    }

    func turnPageIfNeededForChangingOffset(_ offset: CGFloat) {
        switch pageTurnType {
        case .regular:
            return
        case let .earlyCutoff(config):
            guard !isTurningPage else { return }

            if offset > 0 && offset > config.pageTurnCutOff {
                guard activeIndex != 0 else { return }

                scroll(direction: .backward)
            } else if offset < 0 && offset < -config.pageTurnCutOff {
                guard activeIndex != maxPageIndex else { return }

                scroll(direction: .forward)
            }
        }
    }

    func scroll(direction: ScrollDirection) {
        isTurningPage = true // Prevents user drag from continuing
        translation = .zero

        pagerManager.activeIndex = activeIndex + direction.additiveFactor
        pagerManager.setCurrentPageToBeRearranged()
    }

    func turnPageIfNeededForEndOffset(_ offset: CGFloat) {
        translation = .zero

        switch pageTurnType {
        case let .regular(delta):
            let axisLength = isHorizontal ? screen.width : screen.height
            let dragDelta = offset / axisLength

            if abs(dragDelta) > delta {
                let properNewIndex = (dragDelta < 0 ? activeIndex-1 : activeIndex+1).clamped(to: 0...maxPageIndex)
                pagerManager.activeIndex = properNewIndex
                pagerManager.setCurrentPageToBeRearranged()
            }
        case .earlyCutoff:
            isTurningPage = false
        }
    }

}
