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
  
  public var pageControl: UIPageControl? {
    return UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
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

  // MARK: - Initializers
  
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
    setupPageControl()
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
  
  fileprivate func setupPageControl() {
    if self.timeInterval != 0.0 { setupPageTimer() }
    pageControl?.currentPageIndicatorTintColor = UIColor.gray
    pageControl?.pageIndicatorTintColor = UIColor.lightGray
    pageControl?.backgroundColor = UIColor.clear
  }
  
  fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController {
    guard index < pages.count else { return UIViewController() }
    currentPageIndex = index
    return pages[index]
  }
  
  fileprivate func setupPageTimer() {
    timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                 target: self,
                                 selector: #selector(changePage),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  fileprivate func stopTimer() {
    guard let _ = timer as Timer? else { return }
    timer?.invalidate()
    timer = nil
  }
  
  fileprivate func restartTimer() {
    guard self.timeInterval != 0.0 else { return }
    stopTimer()
    setupPageTimer()
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
    guard let viewController = pendingViewControllers.first as UIViewController?, let index = pages.firstIndex(of: viewController) as Int? else {
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
    guard var currentIndex = pages.firstIndex(of: viewController) as Int? else { return nil }
    if currentIndex > 0 {
      currentIndex = (currentIndex - 1) % pages.count
      return pages[currentIndex]
    } else {
      return nil
    }
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    restartTimer()
    guard var currentIndex = pages.firstIndex(of: viewController) as Int? else { return nil }
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
