//
//  DLAutoSlidePageViewController.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 10/16/17.
//  Copyright © 2017 Alonso. All rights reserved.
//

import UIKit

open class DLAutoSlidePageViewController: UIPageViewController {

    private (set) public var pages: [UIViewController] = []
    private (set) public var configuration: AutoSlideConfiguration = DefaultAutoSlideConfiguration.shared

    private var currentPageIndex: Int = 0
    private var nextPageIndex: Int = 0
    private var timer: Timer?

    private var transitionInProgress: Bool = false

    // MARK: - Computed properties

    public var pageControl: UIPageControl? {
        return UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    }

    // MARK: - Lifecycle

    open override func willTransition(to newCollection: UITraitCollection,
                                      with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.transitionInProgress = false
            self.restartTimer()
        }
    }

    // MARK: - Initializers

    /**
     * Initializes a newly created auto slide page view controller.
     * - Parameters:
     *      - pages: The view controllers to be set for the auto slide page view controller.
     *      - configuration: The configuration of the auto slide page view controller.
     */
    public init(pages: [UIViewController], configuration: AutoSlideConfiguration) {
        self.pages = pages
        self.configuration = configuration
        super.init(transitionStyle: configuration.transitionStyle,
                   navigationOrientation: configuration.navigationOrientation,
                   options: [UIPageViewController.OptionsKey.interPageSpacing: configuration.interPageSpacing,
                             UIPageViewController.OptionsKey.spineLocation: configuration.spineLocation])

        setupPageView()
        setupPageTimer(with: configuration.timeInterval)
        setupPageControl(with: configuration)
    }

    /**
     * Initializes a newly created auto slide page view controller with a default configuration.
     * - Parameters:
     *      - pages: The view controllers to be set for the auto slide page view controller.
     */
    public convenience init(pages: [UIViewController]) {
        let configuration = DefaultAutoSlideConfiguration.shared
        self.init(pages: pages, configuration: configuration)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
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

        let navigationDirection = configuration.navigationDirection
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
        setupPageTimer(with: configuration.timeInterval)
    }

    // MARK: - Selectors

    @objc private func movedToForeground() {
        transitionInProgress = false
        restartTimer()
    }

    @objc private func changePage() {
        let navigationDirection = configuration.navigationDirection
        let shouldAnimateTransition = configuration.shouldAnimateTransition
        currentPageIndex = AutoSlideHelper.pageIndex(for: currentPageIndex,
                                                     totalPageCount: pages.count,
                                                     direction: navigationDirection)
        guard let viewController = viewControllerAtIndex(currentPageIndex) as UIViewController? else { return }
        if !transitionInProgress {
            transitionInProgress = true
            setViewControllers([viewController], direction: navigationDirection, animated: shouldAnimateTransition, completion: { finished in
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
        return configuration.hidePageControl ? 0 : pages.count
    }

    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return configuration.hidePageControl ? 0 : currentPageIndex
    }

}
