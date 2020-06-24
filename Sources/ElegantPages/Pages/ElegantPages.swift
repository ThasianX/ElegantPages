// Kevin Li - 6:41 PM - 6/23/20

import SwiftUI

struct ElegantPagesView<Stack>: View, ElegantSimplePagerManagerDirectAccess where Stack: View {

    @State private var translation: CGFloat = .zero

    @ObservedObject var pagerManager: ElegantPagesManager

    let stackView: Stack
    let pageCount: Int
    let isHorizontal: Bool
    let bounces: Bool

    var body: some View {
        stackView
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

private extension ElegantPagesView {

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
        -CGFloat(currentPage) * screen.width
    }

    var verticalOffset: CGFloat {
        -CGFloat(currentPage) * screen.height
    }

    var verticalScrollOffset: CGFloat {
        verticalOffset + properTranslation
    }

    var properTranslation: CGFloat {
        guard !bounces else { return translation }

        if (currentPage == 0 && translation > 0) ||
            (currentPage == pageCount-1 && translation < 0) {
            return 0
        }
        return translation
    }

}

private extension ElegantPagesView {

    private func setTranslationForOffset(_ offset: CGFloat) {
        switch pageTurnType {
        case .regular:
            translation = offset
        case let .earlyCutoff(config):
            translation = (offset / config.pageTurnCutOff) * config.scrollResistanceCutOff
        }
    }

    private func turnPageIfNeededForChangingOffset(_ offset: CGFloat) {
        switch pageTurnType {
        case .regular:
            return
        case let .earlyCutoff(config):
            if offset > 0 && offset > config.pageTurnCutOff {
                guard currentPage != 0 else { return }

                scroll(direction: .backward)
            } else if offset < 0 && offset < -config.pageTurnCutOff {
                guard currentPage != pageCount-1 else { return }

                scroll(direction: .forward)
            }
        }
    }

    private func scroll(direction: ScrollDirection) {
        translation = .zero
        pagerManager.currentPage = currentPage + direction.additiveFactor
        delegate?.willDisplay(page: currentPage)
    }

    private func turnPageIfNeededForEndOffset(_ offset: CGFloat) {
        translation = .zero

        switch pageTurnType {
        case let .regular(delta):
            let dragDelta = (offset / screen.width)

            if abs(dragDelta) > delta {
                let properNewIndex = (dragDelta < 0 ? currentPage-1 : currentPage+1).clamped(to: 0...pageCount-1)
                if properNewIndex != currentPage {
                    pagerManager.currentPage = properNewIndex
                    delegate?.willDisplay(page: currentPage)
                }
            }
        case .earlyCutoff:
            ()
        }
    }

}
