# DLAutoSlidePageViewController

[![Version](https://img.shields.io/cocoapods/v/DLAutoSlidePageViewController.svg?style=flat)](https://cocoapods.org/pods/DLAutoSlidePageViewController)
[![License](https://img.shields.io/cocoapods/l/DLAutoSlidePageViewController.svg?style=flat)](https://cocoapods.org/pods/DLAutoSlidePageViewController)
[![Platform](https://img.shields.io/cocoapods/p/DLAutoSlidePageViewController.svg?style=flat)](https://cocoapods.org/pods/DLAutoSlidePageViewController)
[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://developer.apple.com/swift/)

## Demo

![](Demo.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

DLAutoSlidePageViewController requires iOS 10.0 and Swift 4.0 or above.

## Installation

### CocoaPods

PageViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DLAutoSlidePageViewController"
```

### Swift Package Manager

To integrate using [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your Package.swift:

```Swift
.package(url: "https://github.com/DeluxeAlonso/DLAutoSlidePageViewController.git", .upToNextMajor(from: "1.1.0"))
```

## Usage

Create an instance of `DLAutoSlidePageViewController` and provide it with an array of `UIViewController`'s.

```swift
let firstVC = storyboard?.instantiateViewController(withIdentifier: 'FirstVC')
let secondVC = storyboard?.instantiateViewController(withIdentifier: 'SecondVC')
let pages = [firstVC, secondVC]

let pageViewController = DLAutoSlidePageViewController(pages: pages)
                                                       
addChildViewController(pageViewController)
containerView.addSubview(pageViewController.view)
pageViewController.view.frame = containerView.bounds
```

## Appearance and presentation configuration

There are two ways to configure the appearance and presentation of `DLAutoSlidePageViewController`:

1) You can do it globally using the `DefaultAutoSlideConfiguration` class before instantiation.

```swift
let pages = [firstVC, secondVC]

DefaultAutoSlideConfiguration.shared.timeInterval = 5.0
DefaultAutoSlideConfiguration.shared.interPageSpacing = 3.0
DefaultAutoSlideConfiguration.shared.hidePageControl = false
let pageViewController = DLAutoSlidePageViewController(pages: pages)
```

2) You can create your own configuration instance that conforms to `AutoSlideConfiguration` protocol and pass it on `DLAutoSlidePageViewController`'s initializer.

```swift
struct CustomConfiguration: AutoSlideConfiguration {
    var timeInterval: TimeInterval = 10.0
    var navigationOrientation: UIPageViewController.NavigationOrientation = .vertical
}
```

```swift
let pages = [firstVC, secondVC]
let pageViewController = DLAutoSlidePageViewController(pages: pages, configuration: CustomConfiguration())
```

## Page control configuration

You can also access the UIPageControl through the `pageControl` property.

```swift
pageViewController.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
pageViewController.pageControl.pageIndicatorTintColor = UIColor.gray
pageViewController.pageControl.backgroundColor = UIColor.clear
```

## Author

Alonso Alvarez, alonso.alvarez.dev@gmail.com

## License

DLAutoSlidePageViewController is available under the MIT license. See the LICENSE file for more info.
