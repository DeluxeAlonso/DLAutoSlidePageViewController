//
//  DLAutoSlidePageViewController.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 10/16/17.
//  Copyright © 2017 Alonso. All rights reserved.
//

import UIKit

open class DLAutoSlidePageViewController: UIPageViewController {

    fileprivate(set) var pages: [UIViewController] = []

    fileprivate var currentPageIndex: Int = 0
    fileprivate var nextPageIndex: Int = 0
    fileprivate var timer: Timer?
    fileprivate var timeInterval: TimeInterval = 0.0
    fileprivate var transitionInProgress: Bool = false
    fileprivate var shouldHidePageControl: Bool = false

    // MARK: - Computed properties

    public var pageControl: UIPageControl? {
        return UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    }

    // MARK: - Initializers

    public convenience init(pages: [UIViewController],
                            configuration: AutoSlideConfiguration = DefaultAutoSlideConfiguration.shared) {
        self.init(transitionStyle: configuration.transitionStyle,
                  navigationOrientation: configuration.navigationOrientation,
                  options: [UIPageViewController.OptionsKey.interPageSpacing: configuration.interPageSpacing])
        self.pages = pages
        self.timeInterval = configuration.timeInterval
        self.shouldHidePageControl = configuration.hidePageControl

        setupPageView()
        setupPageTimer(with: timeInterval)
        setupPageControl(with: configuration)
    }

    public convenience init(pages: [UIViewController],
                            timeInterval ti: TimeInterval = 0.0,
                            transitionStyle: UIPageViewController.TransitionStyle,
                            interPageSpacing: Float = 0.0,
                            hidePageControl: Bool = false) {
        self.init(transitionStyle: transitionStyle,
                  navigationOrientation: .horizontal,
                  options: [UIPageViewController.OptionsKey.interPageSpacing: interPageSpacing])
        self.pages = pages
        self.timeInterval = ti
        self.shouldHidePageControl = hidePageControl
        setupPageView()
        setupPageTimer(with: timeInterval)
        setupPageControl(with: DefaultAutoSlideConfiguration.shared)
    }

    // MARK: - Lifecycle
    
    deinit {
        stopTimer()
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil);
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setupObservers()
    }

    // MARK: - Private

    fileprivate func setupObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(movedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    fileprivate func setupPageView() {
        guard let firstPage = pages.first else { return }
        currentPageIndex = 0
        setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
    }

    fileprivate func setupPageControl(with configuration: AutoSlideConfiguration) {
        pageControl?.currentPageIndicatorTintColor = configuration.pageControlCurrentPageIndicatorTintColor
        pageControl?.pageIndicatorTintColor = configuration.pageControlPageIndicatorTintColor
        pageControl?.backgroundColor = configuration.pageControlBackgroundColor
    }

    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController {
        guard index < pages.count else { return UIViewController() }
        currentPageIndex = index
        return pages[index]
    }

    fileprivate func setupPageTimer(with timeInterval: TimeInterval) {
        guard timeInterval != 0.0 else { return }
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(changePage),
                                     userInfo: nil,
                                     repeats: true)
    }

    fileprivate func stopTimer() {
        guard let _ = timer else { return }
        timer?.invalidate()
        timer = nil
    }

    fileprivate func restartTimer() {
        stopTimer()
        setupPageTimer(with: timeInterval)
    }

    // MARK: - Selectors

    @objc fileprivate func movedToForeground() {
        transitionInProgress = false
        restartTimer()
    }

    @objc fileprivate func changePage() {
        if currentPageIndex < pages.count - 1 {
            currentPageIndex += 1
        } else {
            currentPageIndex = 0
        }
        guard let viewController = viewControllerAtIndex(currentPageIndex) as UIViewController? else { return }
        if !transitionInProgress {
            transitionInProgress = true
            setViewControllers([viewController], direction: .forward, animated: true, completion: { finished in
                self.transitionInProgress = !finished
            })
        }
    }

}

// MARK: - UIPageViewControllerDelegate

extension DLAutoSlidePageViewController: UIPageViewControllerDelegate {

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewController = pendingViewControllers.first,
              let index = pages.firstIndex(of: viewController) else {
            return
        }
        nextPageIndex = index
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentPageIndex = nextPageIndex
        }
        nextPageIndex = 0
    }

}

// MARK: - UIPageViewControllerDataSource

extension DLAutoSlidePageViewController: UIPageViewControllerDataSource {

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        restartTimer()
        guard var currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex > 0 {
            currentIndex = (currentIndex - 1) % pages.count
            return pages[currentIndex]
        } else {
            return nil
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        restartTimer()
        guard var currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            currentIndex = (currentIndex + 1) % pages.count
            return pages[currentIndex]
        } else {
            return nil
        }
    }

    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return shouldHidePageControl ? 0 : pages.count
    }

    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return shouldHidePageControl ? 0 : currentPageIndex
    }

}
