//
//  AutoSlideConfiguration.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 6/04/21.
//

import UIKit

public protocol AutoSlideConfiguration {

    /// Time interval to be used for each page automatic transition.
    var timeInterval: TimeInterval { get }

    /// Styles for the page-turn transition.
    var transitionStyle: UIPageViewController.TransitionStyle { get }

    /// Orientations for page-turn transitions.
    var navigationOrientation: UIPageViewController.NavigationOrientation { get }

    /// Space between pages.
    var interPageSpacing: Float { get }

    /// Decides if page contron is going to be shown or not.
    var hidePageControl: Bool { get }

    var pageControlCurrentPageIndicatorTintColor: UIColor { get }

    var pageControlPageIndicatorTintColor: UIColor { get }

    var pageControlBackgroundColor: UIColor { get }

}

// MARK: - Default values

public extension AutoSlideConfiguration {

    var timeInterval: TimeInterval { 3.0 }
    var transitionStyle: UIPageViewController.TransitionStyle { .scroll }
    var navigationOrientation: UIPageViewController.NavigationOrientation { .horizontal }
    var interPageSpacing: Float { 0.0 }
    var hidePageControl: Bool { false }

    var pageControlCurrentPageIndicatorTintColor: UIColor { UIColor.gray }
    var pageControlPageIndicatorTintColor: UIColor { UIColor.lightGray }
    var pageControlBackgroundColor: UIColor { UIColor.clear }

}
