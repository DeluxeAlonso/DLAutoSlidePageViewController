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

    /// Directions for page-turn transitions.
    var navigationDirection: UIPageViewController.NavigationDirection { get }

    /// Space between pages.
    var interPageSpacing: Float { get }

    /// Locations for the spine. Only valid if the transition style is UIPageViewController.TransitionStyle.pageCurl.
    var spineLocation: UIPageViewController.SpineLocation { get }

    /// Decides if page contron is going to be shown or not.
    var hidePageControl: Bool { get }

    /// The tint color to be used for the current page indicator.
    var currentPageIndicatorTintColor: UIColor { get }

    /// The tint color to be used for the page indicator.
    var pageIndicatorTintColor: UIColor { get }

    /// The background color to be used for the page control.
    var pageControlBackgroundColor: UIColor { get }

    /// A Boolean value that indicates whether the automatic transition is to be animated.
    var shouldAnimateTransition: Bool { get }

}

// MARK: - Default values

public extension AutoSlideConfiguration {

    var timeInterval: TimeInterval { 3.0 }
    var transitionStyle: UIPageViewController.TransitionStyle { .scroll }
    var navigationOrientation: UIPageViewController.NavigationOrientation { .horizontal }
    var navigationDirection: UIPageViewController.NavigationDirection { .forward }
    var interPageSpacing: Float { 0.0 }
    var spineLocation: UIPageViewController.SpineLocation { .none }
    var hidePageControl: Bool { false }

    var currentPageIndicatorTintColor: UIColor { UIColor.gray }
    var pageIndicatorTintColor: UIColor { UIColor.lightGray }
    var pageControlBackgroundColor: UIColor { UIColor.clear }

    var shouldAnimateTransition: Bool { true }

}
