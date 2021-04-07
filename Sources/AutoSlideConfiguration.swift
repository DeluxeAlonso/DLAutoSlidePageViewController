//
//  AutoSlideConfiguration.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 6/04/21.
//

import UIKit

public protocol AutoSlideConfiguration {

    var timeInterval: TimeInterval { get }
    var transitionStyle: UIPageViewController.TransitionStyle { get }
    var navigationOrientation: UIPageViewController.NavigationOrientation { get }
    var interPageSpacing: Float { get }
    var hidePageControl: Bool { get }

}
