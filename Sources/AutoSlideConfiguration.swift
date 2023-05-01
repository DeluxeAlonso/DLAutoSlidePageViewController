//
//  AutoSlideConfiguration.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 6/04/21.
//

import UIKit

/**
 * Configuration of the auto slide page view controller.
 */
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

    /// Decides if page control is going to be shown or not.
    var hidePageControl: Bool { get }

    /// The tint color to be used for the current page indicator.
    var currentPageIndicatorTintColor: UIColor { get }

    /// The tint color to be used for the page indicator.
    var pageIndicatorTintColor: UIColor { get }

    /// The background color to be used for the page control.
    var pageControlBackgroundColor: UIColor { get }

    @available(iOS 16.0, *)
    /// Decribes the layout direction of a page control’s indicators.
    var pageControlDirection: UIPageControl.Direction { get }

    @available(iOS 14.0, *)
    /// The preferred image for indicators. Symbol images are recommended. Default is nil.
    var pageControlPreferredIndicatorImage: UIImage? { get }

    @available(iOS 16.0, *)
    /// The preferred image for the current page indicator.
    var pageControlPreferredCurrentPageIndicatorImage: UIImage? { get }

    /// Indicates whether the automatic transition is to be animated.
    var shouldAnimateTransition: Bool { get }

    /// Indicates if the page controller should slide back/forward when the users taps on the left/right side.
    var shouldSlideOnTap: Bool { get }

    /// Tappable area percentage used to detect taps on both sides: left and right. Defaults to 20%. Only used if shouldSlideOnTap is set to true.
    var tappableAreaPercentage: Float { get }

    /// False by default. If set to true DLAutoSlidePageViewControllerGestureDelegate methods will be called if needed and shouldSlideOnTap property will be ignored.
    var overridesGesturesBehavior: Bool { get }

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

    @available(iOS 16.0, *)
    var pageControlDirection: UIPageControl.Direction { .natural }
    var pageControlPreferredIndicatorImage: UIImage? { nil }
    @available(iOS 16.0, *)
    var pageControlPreferredCurrentPageIndicatorImage: UIImage? { nil }

    var shouldAnimateTransition: Bool { true }

    var shouldSlideOnTap: Bool { true }
    var tappableAreaPercentage: Float { 20 }

    var overridesGesturesBehavior: Bool { false }

}
