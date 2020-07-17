# ElegantPages

<p align="leading">
    <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platforms" />
    <img src="https://img.shields.io/badge/Swift-5-orange.svg" />
    <a href="https://github.com/ThasianX/Elegant-Pages/blob/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

ElegantPages is an efficient and customizable full screen page view written in SwiftUI.

<br/>

<img src="https://github.com/ThasianX/GIFs/blob/master/ElegantCalendar/dark_demo.gif" width="300"/>

- [Introduction](#introduction)
- [Basic Usage](#basic-usage)
- [How It Works](#how-it-works)
- [Customization](#customization)
- [Demos](#demos)
- [Requirements](#requirements)
- [Contributing](#contributing)
- [Installation](#installation)
- [License](#license)

## Introduction

`ElegantPages` comes with 2 types of components, [`ElegantPagesView`](https://github.com/ThasianX/ElegantPages/blob/master/Sources/ElegantPages/Pages/Internal/ElegantPagesView.swift) and [`ElegantListView`](https://github.com/ThasianX/ElegantPages/blob/master/Sources/ElegantPages/Lists/Internal/ElegantListView.swift). 

For simpler usage, `ElegantPagesView` is recommended as it loads all page views immediately.

For more complex usage, `ElegantListView` is recommended as it loads page views on demand([learn more](#how-it-works)).

The elegance of both these views is that they work as a paging component should be intended to work. One bug that is often seen in SwiftUI is that `ScrollView`, `List`, or any `Gesture` almost certainly interferes with other gestures in the view. However, `ElegantPages` fixes this issue and scrolling through a paging component even with embedded `Gestures` works elegantly.

## Basic usage

The `ElegantPagesView` component is available through [`ElegantHPages`](https://github.com/ThasianX/ElegantPages/blob/master/Sources/ElegantPages/Pages/Public/ElegantHPages.swift) and [`ElegantVPages`](https://github.com/ThasianX/ElegantPages/blob/master/Sources/ElegantPages/Pages/Public/ElegantVPages.swift).

```swift

import ElegantPages

struct ElegantVPagesExample: View {

    let manager = ElegantPagesManager(startingPage: 1, pageTurnType: .earlyCutOffDefault)

    var body: some View {
        ElegantVPages(manager: manager) {
            CustomButtonView()
            CustomView()
            CustomListView()
        }
    }

}
```

The `ElegantListView` component is available through [`ElegantHList`](https://github.com/ThasianX/ElegantPages/blob/master/Sources/ElegantPages/Lists/Public/ElegantHList.swift) and [`ElegantVList`](https://github.com/ThasianX/ElegantPages/blob/master/Sources/ElegantPages/Lists/Public/ElegantVList.swift).

```swift

import ElegantPages

let vListData = (1...40).map { _ in "Ideally, this should be more dynamic content to make the most use out of this list" }

struct ElegantVListExample: View {

    let manager = ElegantListManager(pageCount: vListData.count, pageTurnType: .earlyCutOffDefault)

    init() {
        manager.datasource = self
    }

    var body: some View {
        ElegantVList(manager: manager)
            .frame(width: screen.width - 100) // In case you don't want an entirely full screen list
    }

}

extension ElegantVListExample: ElegantPagesDataSource {

    func elegantPages(viewForPage page: Int) -> AnyView {
        VStack {
            Text("Page \(page)")
                .font(.largeTitle)
            Text(vListData[page])
                .font(.title)
        }
        .padding()
        .erased
    }

}
```

## How it works

`ElegantPagesView` is pretty simple. It uses a [function builder](https://github.com/apple/swift-evolution/blob/9992cf3c11c2d5e0ea20bee98657d93902d5b174/proposals/XXXX-function-builders.md) to gather the page views and puts them in either a `HStack` or `VStack` depending on the type of `ElegantPages` view chosen. As a result, all views are created immediately. 

`ElegantListView` is quite interesting. For more flexibility, it uses [`ElegantPagesDataSource`](https://github.com/ThasianX/ElegantPages/blob/master/Sources/ElegantPages/Models/Public/ElegantPagesDataSource%26Delegate.swift) to get the view for any given page. When it is first initialized, it calls the delegate at most 3 times, to get the views for the starting pages. These views are used to initialize an array of at most 3 `UIHostingControllers`, whose `rootViews` are set to a specific origin in a `UIViewController`. Here's the catch, at any given moment, there are at most only 3 pages loaded. As the user scrolls to the next page, old pages are removed and new pages are inserted; the views themselves are juggled as their origins are changed per page turn. This keeps overall memory usage down and also makes scrolling blazingly fast. If you're curious, take a [peek](https://github.com/ThasianX/ElegantPages/blob/master/Sources/ElegantPages/Lists/Internal/ElegantListController.swift).

## Customization

The following aspects of any `ElegantPages` component can be customized:

#### `pageTurnType`: Whether to scroll to the next page early or until the user lets go of the drag

```swift 

public enum PageTurnType {

    case regular(pageTurnDelta: CGFloat)
    case earlyCutoff(config: EarlyCutOffConfiguration)

}

public struct EarlyCutOffConfiguration {

    public let scrollResistanceCutOff: CGFloat
    public let pageTurnCutOff: CGFloat
    public let pageTurnAnimation: Animation
    
}

```

A regular page turn only turns the page after the user ends their drag. 

- The `pageTurnDelta` represents the percentage of how far across the screen the user has to drag in order for the page to turn when they let go. The default value for this is 0.3, as part of an extension of `PageTurnType`. 
- The default regular page turn can be accessed through `PageTurnType.regularDefault`

An early cutoff page turn turns the page when the user drags a certain distance across the screen.

- `scrollResistanceCutOff`: The distance that the view is offset as the user drags.
- `pageTurnCutOff`: The distance across the screen the user has to drag before the page is turned(once this value is reached, the page automatically gets turned to and the user's ongoing gesture is invalidated). 
- `pageTurnAnimation`: The animation used when the page is turned
- The default early cut off page turn can be accessed through `PageTurnType.earlyCutOffDefault`

In case `scrollResistanceCutOff` isn't clear, here's an example. Say we have a horizontally draggable view. If you drag 80 pixels to the right, the offset that is visible to you is also 80 pixels. The amount you scroll is equal to the visible offset. However, if you have a scroll resistance of say 40 pixels, after dragging 80 pixels to the right, you only see that the view has moved 40 pixels to the right. That is why it is called resistance.

#### `delegate`: The delegate of any `ElegantPages` component

```swift 

public protocol ElegantPagesDelegate {

    func elegantPages(willDisplay page: Int)

}

```

You can conform to `ElegantPagesDelegate` if you want to do something when a page is displayed. 

## Demos

The demo shown in the GIF can be checked out on [ElegantCalendar](https://github.com/ThasianX/ElegantCalendar).

For simpler demos, look at the [example repo](https://github.com/ThasianX/ElegantPages/tree/master/Example).

## Installation

`ElegantPages` is available using the [Swift Package Manager](https://swift.org/package-manager/):

Using Xcode 11, go to `File -> Swift Packages -> Add Package Dependency` and enter https://github.com/ThasianX/ElegantPages

If you are using `Package.swift`, you can also add `ElegantPages` as a dependency easily.

```swift

let package = Package(
  name: "TestProject",
  dependencies: [
    .package(url: "https://github.com/ThasianX/ElegantPages", from: "1.0.1")
  ],
  targets: [
    .target(name: "TestProject", dependencies: ["ElegantPages"])
  ]
)

```

## Requirements

- iOS 13.0+
- Xcode 11.0+

## Contributing

If you find a bug, or would like to suggest a new feature or enhancement, it'd be nice if you could [search the issue tracker](https://github.com/ThasianX/ElegantPages/issues) first; while we don't mind duplicates, keeping issues unique helps us save time and considates effort. If you can't find your issue, feel free to [file a new one](https://github.com/ThasianX/ElegantPages/issues/new).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
