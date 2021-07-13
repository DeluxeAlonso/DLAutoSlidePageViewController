//
//  DLAutoSlidePageViewController.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 10/16/17.
//  Copyright © 2017 Alonso. All rights reserved.
//

import UIKit

open class DLAutoSlidePageViewController: UIPageViewController {

    private var pages: [UIViewController] = []

    private var currentPageIndex: Int = 0
    private var nextPageIndex: Int = 0
    private var timer: Timer?

    private var timeInterval: TimeInterval = 0.0
    private var shouldHidePageControl: Bool = false
    private var navigationDirection: UIPageViewController.NavigationDirection = .forward

    private var transitionInProgress: Bool = false

    // MARK: - Computed properties

    public var pageControl: UIPageControl? {
        return UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    }

    // MARK: - Lifecycle

    public override func willTransition(to newCollection: UITraitCollection,
                                      with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.transitionInProgress = false
            self.restartTimer()
        }
    }

    // MARK: - Initializers

    public convenience init(pages: [UIViewController],
                            configuration: AutoSlideConfiguration = DefaultAutoSlideConfiguration.shared) {
        self.init(transitionStyle: configuration.transitionStyle,
                  navigationOrientation: configuration.navigationOrientation,
                  options: [UIPageViewController.OptionsKey.interPageSpacing: configuration.interPageSpacing,
                            UIPageViewController.OptionsKey.spineLocation: configuration.spineLocation])
        self.pages = pages

        self.timeInterval = configuration.timeInterval
        self.shouldHidePageControl = configuration.hidePageControl
        self.navigationDirection = configuration.navigationDirection

        setupPageView()
        setupPageTimer(with: timeInterval)
        setupPageControl(with: configuration)
    }

    @available(*, deprecated, message: "Use convenience initializer that receives an AutoSlideConfiguration instead.")
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

    private func setupObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(movedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    private func setupPageView() {
        guard let firstPage = pages.first else { return }
        currentPageIndex = 0
        setViewControllers([firstPage], direction: navigationDirection, animated: true, completion: nil)
    }

    private func setupPageControl(with configuration: AutoSlideConfiguration) {
        pageControl?.currentPageIndicatorTintColor = configuration.currentPageIndicatorTintColor
        pageControl?.pageIndicatorTintColor = configuration.pageIndicatorTintColor
        pageControl?.backgroundColor = configuration.pageControlBackgroundColor
    }

    private func viewControllerAtIndex(_ index: Int) -> UIViewController {
        guard index < pages.count else { return UIViewController() }
        currentPageIndex = index
        return pages[index]
    }

    private func setupPageTimer(with timeInterval: TimeInterval) {
        guard timeInterval != 0.0 else { return }
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(changePage),
                                     userInfo: nil,
                                     repeats: true)
    }

    private func stopTimer() {
        guard let _ = timer else { return }
        timer?.invalidate()
        timer = nil
    }

    private func restartTimer() {
        stopTimer()
        setupPageTimer(with: timeInterval)
    }

    // MARK: - Selectors

    @objc private func movedToForeground() {
        transitionInProgress = false
        restartTimer()
    }

    @objc private func changePage() {
        currentPageIndex = AutoSlideHelper.pageIndex(for: currentPageIndex,
                                                     totalPageCount: pages.count,
                                                     direction: navigationDirection)
        guard let viewController = viewControllerAtIndex(currentPageIndex) as UIViewController? else { return }
        if !transitionInProgress {
            transitionInProgress = true
            setViewControllers([viewController], direction: navigationDirection, animated: true, completion: { finished in
                self.transitionInProgress = false
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
