# DLAutoSlidePageViewController

[![Version](https://img.shields.io/cocoapods/v/DLAutoSlidePageViewController.svg?style=flat)](https://cocoapods.org/pods/DLAutoSlidePageViewController)
[![License](https://img.shields.io/cocoapods/l/DLAutoSlidePageViewController.svg?style=flat)](https://cocoapods.org/pods/DLAutoSlidePageViewController)
[![Platform](https://img.shields.io/cocoapods/p/DLAutoSlidePageViewController.svg?style=flat)](https://cocoapods.org/pods/DLAutoSlidePageViewController)
[![Swift 4](https://img.shields.io/badge/Swift-4-orange.svg?style=flat)](https://developer.apple.com/swift/)

## Demo

![](Demo.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

DLAutoSlidePageViewController requires iOS 10.0 and Swift 4.0 or above.

## Installation

PageViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DLAutoSlidePageViewController"
```

## Usage

1) Create an instance of a `DLAutoSlidePageViewController` and provide it with an array of View controllers.

```swift
let firstVC = storyboard?.instantiateViewController(withIdentifier: 'FirstVC')
let secondVC = storyboard?.instantiateViewController(withIdentifier: 'SecondVC')
let pages = [firstVC, secondVC]

let pageViewController = DLAutoSlidePageViewController(pages: pages,
                                                       timeInterval: 3.0,
                                                       transitionStyle: .scroll,
                                                       interPageSpacing: 0.0)
                                                       
addChildViewController(pageViewController)
containerView.addSubview(pageViewController.view)
pageViewController.view.frame = containerView.bounds
```
2) You can also access the UIPageControl through the `pageControl` property.

```swift
pageViewController.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
pageViewController.pageControl.pageIndicatorTintColor = UIColor.gray
pageViewController.pageControl.backgroundColor = UIColor.clear
```

## Author

Alonso Alvarez, alonso.alvarez.dev@gmail.com

## License

DLAutoSlidePageViewController is available under the MIT license. See the LICENSE file for more info.
