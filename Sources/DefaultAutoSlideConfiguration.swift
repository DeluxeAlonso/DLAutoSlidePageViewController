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
    public var interPageSpacing: Float = 0.0
    public var hidePageControl: Bool = false

}
