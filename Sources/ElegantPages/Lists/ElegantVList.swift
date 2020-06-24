// Kevin Li - 6:13 PM - 6/23/20

import SwiftUI

struct ElegantVList: View, ElegantListManagerDirectAccess {

    @State private var translation: CGFloat = .zero
    @State private var isTurningPage = false

    @ObservedObject var pagerManager: ElegantListManager

    var bounces: Bool = false

    private var pagerHeight: CGFloat {
        screen.height * CGFloat(maxPageIndex+1)
    }

    private var pageOffset: CGFloat {
        -CGFloat(activeIndex) * screen.height
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

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ElegantListView(pagerManager: pagerManager, axis: .vertical)
                .frame(height: pagerHeight)
        }
        .frame(width: screen.width, height: screen.height, alignment: .top)
        .offset(y: currentScrollOffset)
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    if abs(value.translation.width) > abs(value.translation.height) {
                        self.translation = .zero
                        return
                    }

                    withAnimation(self.pageTurnAnimation) {
                        self.translation = self.translationForOffset(value.translation.height)
                        self.turnPageIfNeededForChangingOffset(value.translation.height)
                    }
                }
                .onEnded { value in
                    withAnimation(self.pageTurnAnimation) {
                        self.turnPageIfNeededForEndOffset(value.translation.height)
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
            let delta = offset / screen.height
            let newIndex = Int((CGFloat(activeIndex) - delta).rounded())
            pagerManager.activeIndex = newIndex.clamped(to: 0...maxPageIndex)
            pagerManager.setCurrentPageToBeRearranged()
        case .earlyCutoff:
            isTurningPage = false
        }
    }

}
