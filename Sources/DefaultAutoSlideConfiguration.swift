//
//  DefaultAutoSlideConfiguration.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 6/04/21.
//

import UIKit

final public class DefaultAutoSlideConfiguration: AutoSlideConfiguration {

    public static var shared = DefaultAutoSlideConfiguration()

    init() {}

    // MARK: - AutoSlideConfiguration

    public var timeInterval: TimeInterval = 3.0
    public var transitionStyle: UIPageViewController.TransitionStyle = .scroll
    public var navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal
    public var navigationDirection: UIPageViewController.NavigationDirection = .forward
    public var interPageSpacing: Float = 0.0
    public var spineLocation: UIPageViewController.SpineLocation = .none
    public var hidePageControl: Bool = false

    public var currentPageIndicatorTintColor: UIColor = UIColor.gray
    public var pageIndicatorTintColor: UIColor = UIColor.lightGray
    public var pageControlBackgroundColor: UIColor = UIColor.clear

    public var shouldAnimateTransition: Bool = true
    
    public var shouldSlideOnTap: Bool = false
    public var tappableAreaPercentage: Float = 20

    public var overridesTapBehavior: Bool = false

}
