// Kevin Li - 6:13 PM - 6/23/20

import SwiftUI

public struct ElegantHList: View, ElegantListManagerDirectAccess {

    @State private var translation: CGFloat = .zero
    @State private var isTurningPage = false

    @ObservedObject var pagerManager: ElegantListManager

    var bounces: Bool = false

    private var pagerWidth: CGFloat {
        screen.width * CGFloat(maxPageIndex+1)
    }

    private var pageOffset: CGFloat {
        -CGFloat(activeIndex) * screen.width
    }

    private var properTranslation: CGFloat {
        guard !bounces else { return translation }

        if (activeIndex == 0 && translation > 0) ||
            (activeIndex == maxPageIndex && translation < 0) {
            return 0
        }
        return translation
    }

    private var currentScrollOffset: CGFloat {
        pageOffset + properTranslation
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ElegantListView(pagerManager: pagerManager, axis: .horizontal)
                .frame(width: pagerWidth)
        }
        .frame(width: screen.width, height: screen.height, alignment: .leading)
        .offset(x: currentScrollOffset)
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    if abs(value.translation.height) > abs(value.translation.width) {
                        self.translation = .zero
                        return
                    }

                    withAnimation(self.pageTurnAnimation) {
                        self.translation = self.translationForOffset(value.translation.width)
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

    private func translationForOffset(_ offset: CGFloat) -> CGFloat {
        switch pageTurnType {
        case .regular:
            return offset
        case let .earlyCutoff(config):
            guard !isTurningPage else { return 0 }
            return (offset / config.pageTurnCutOff) * config.scrollResistanceCutOff
        }
    }

    private func turnPageIfNeededForChangingOffset(_ offset: CGFloat) {
        switch pageTurnType {
        case .regular:
            return
        case let .earlyCutoff(config):
            guard !isTurningPage else { return }

            if offset > 0 && offset > config.pageTurnCutOff {
                guard currentPage.index != 0 else { return }

                scroll(direction: .backward)
            } else if offset < 0 && offset < -config.pageTurnCutOff {
                guard currentPage.index != pageCount-1 else { return }

                scroll(direction: .forward)
            }
        }
    }

    private func scroll(direction: ScrollDirection) {
        isTurningPage = true // Prevents user drag from continuing
        translation = .zero

        pagerManager.activeIndex = activeIndex + direction.additiveFactor
        pagerManager.setCurrentPageToBeRearranged()
    }

    private func turnPageIfNeededForEndOffset(_ offset: CGFloat) {
        translation = .zero

        switch pageTurnType {
        case .regular:
            let delta = offset / screen.width
            let newIndex = Int((CGFloat(activeIndex) - delta).rounded())
            pagerManager.activeIndex = newIndex.clamped(to: 0...maxPageIndex)
            pagerManager.setCurrentPageToBeRearranged()
        case .earlyCutoff:
            isTurningPage = false
        }
    }

}

