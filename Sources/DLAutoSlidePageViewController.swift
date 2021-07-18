//
//  DLAutoSlidePageViewController.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 10/16/17.
//  Copyright © 2017 Alonso. All rights reserved.
//

import UIKit

@IBDesignable open class DLAutoSlidePageViewController: UIPageViewController {

    // MARK: - Interface Builder properties

    @IBInspectable public var timeInterval: Double = DefaultAutoSlideConfiguration.shared.timeInterval {
        didSet {
            guard timeInterval >= 0 else {
                DefaultAutoSlideConfiguration.shared.timeInterval = 0
                return
            }
            DefaultAutoSlideConfiguration.shared.timeInterval = timeInterval
        }
    }

    @IBInspectable public var hidePageControl: Bool = DefaultAutoSlideConfiguration.shared.hidePageControl {
        didSet {
            DefaultAutoSlideConfiguration.shared.hidePageControl = hidePageControl
        }
    }

    @IBInspectable public var currentPageIndicatorTintColor: UIColor = DefaultAutoSlideConfiguration.shared.currentPageIndicatorTintColor {
        didSet {
            DefaultAutoSlideConfiguration.shared.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }

    @IBInspectable public var pageIndicatorTintColor: UIColor = DefaultAutoSlideConfiguration.shared.pageIndicatorTintColor {
        didSet {
            DefaultAutoSlideConfiguration.shared.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }

    @IBInspectable public var pageControlBackgroundColor: UIColor = DefaultAutoSlideConfiguration.shared.pageControlBackgroundColor {
        didSet {
            DefaultAutoSlideConfiguration.shared.pageControlBackgroundColor = pageControlBackgroundColor
        }
    }

    @IBInspectable public var shouldAnimateTransition: Bool = DefaultAutoSlideConfiguration.shared.shouldAnimateTransition {
        didSet {
            DefaultAutoSlideConfiguration.shared.shouldAnimateTransition = shouldAnimateTransition
        }
    }

    // MARK:  - Stored properties

    private var pages: [UIViewController] = []
    private var configuration: AutoSlideConfiguration = DefaultAutoSlideConfiguration.shared

    private var currentPageIndex: Int = 0
    private var nextPageIndex: Int = 0
    private var timer: Timer?

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

    public init(pages: [UIViewController], configuration: AutoSlideConfiguration) {
        self.pages = pages
        self.configuration = configuration
        super.init(transitionStyle: configuration.transitionStyle,
                   navigationOrientation: configuration.navigationOrientation,
                   options: [UIPageViewController.OptionsKey.interPageSpacing: configuration.interPageSpacing,
                             UIPageViewController.OptionsKey.spineLocation: configuration.spineLocation])

        setupPageView()
        setupPageControl()
        setupPageTimer(with: configuration.timeInterval)
    }

    public convenience init(pages: [UIViewController]) {
        let configuration = DefaultAutoSlideConfiguration.shared
        self.init(pages: pages, configuration: configuration)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        DefaultAutoSlideConfiguration.shared.transitionStyle = self.transitionStyle
        DefaultAutoSlideConfiguration.shared.navigationOrientation = self.navigationOrientation
        configuration = DefaultAutoSlideConfiguration.shared
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

    private func setupPageControl() {
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

    // MARK: - Public

    public func setPages(_ pages: [UIViewController]) {
        self.pages = pages
        setupPageView()
        setupPageControl()
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
