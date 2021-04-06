//
//  DLAutoSlidePageViewController.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 10/16/17.
//  Copyright © 2017 Alonso. All rights reserved.
//

import UIKit

public class DLAutoSlidePageViewController: UIPageViewController {

  private(set) var pages: [UIViewController] = []

  private var timer: Timer?
  private var timeInterval: TimeInterval = 0.0

  private var currentPageIndex: Int = 0
  private var nextPageIndex: Int = 0
  private var transitionInProgress: Bool = false
  
  public var pageControl: UIPageControl? {
    return UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
  }
  
  // MARK: - Lifecycle
    
  deinit {
    stopTimer()
    NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil);
  }
    
  override public func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    dataSource = self
    setupObservers()
  }
  
  public convenience init(pages: [UIViewController], timeInterval ti: TimeInterval = 0.0, transitionStyle: UIPageViewController.TransitionStyle, interPageSpacing: Float = 0.0) {
    self.init(transitionStyle: transitionStyle,
              navigationOrientation: .horizontal,
              options: [UIPageViewController.OptionsKey.interPageSpacing: interPageSpacing])
    self.pages = pages
    self.timeInterval = ti
    setupPageView()
    setupPageControl()
  }
  
  // MARK: - Private
  
  private func setupObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(movedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  private func setupPageView() {
    guard let firstPage = pages.first else { return }
    currentPageIndex = 0
    setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
  }
  
  private func setupPageControl() {
    if self.timeInterval != 0.0 { setupPageTimer() }
    pageControl?.currentPageIndicatorTintColor = UIColor.gray
    pageControl?.pageIndicatorTintColor = UIColor.lightGray
    pageControl?.backgroundColor = UIColor.clear
  }
  
  private func viewControllerAtIndex(_ index: Int) -> UIViewController {
    guard index < pages.count else { return UIViewController() }
    currentPageIndex = index
    return pages[index]
  }
  
  private func setupPageTimer() {
    timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                 target: self,
                                 selector: #selector(changePage),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  private func stopTimer() {
    guard let _ = timer as Timer? else { return }
    timer?.invalidate()
    timer = nil
  }
  
  private func restartTimer() {
    guard self.timeInterval != 0.0 else { return }
    stopTimer()
    setupPageTimer()
  }
  
  // MARK: - Selectors
  
  @objc private func movedToForeground() {
    transitionInProgress = false
    restartTimer()
  }
  
  @objc private func changePage() {
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
    return pages.count
  }
  
  public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return currentPageIndex
  }

}
