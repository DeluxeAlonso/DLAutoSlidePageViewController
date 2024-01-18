//
//  DLAutoSlidePageViewControllerTests.swift
//  DLAutoSlidePageViewControllerTests
//
//  Created by Alonso on 11/05/23.
//  Copyright © 2023 Alonso. All rights reserved.
//

@testable import DLAutoSlidePageViewController
import XCTest

struct TestConfiguration: AutoSlideConfiguration {
    var testHidesPageControl = false
    var hidePageControl: Bool {
        testHidesPageControl
    }

    var testTimeInterval: TimeInterval = 1.0
    var timeInterval: TimeInterval {
        testTimeInterval
    }
}

final class DLAutoSlidePageViewControllerTests: XCTestCase {

    private var pageViewController: DLAutoSlidePageViewController!

    func testPresentationCount() {
        // Arrange
        let pages = [UIViewController(), UIViewController(), UIViewController()]
        let pageViewController = DLAutoSlidePageViewController(pages: pages)
        // Act
        let presentationCount = pageViewController.presentationCount(for: pageViewController)
        // Assert
        XCTAssertEqual(presentationCount, pages.count)
    }

    func testPresentationZeroCountWhenHidesPageControl() {
        // Arrange
        var testConfiguration = TestConfiguration()
        testConfiguration.testHidesPageControl = true
        let pages = [UIViewController(), UIViewController(), UIViewController()]
        let pageViewController = DLAutoSlidePageViewController(pages: pages, configuration: testConfiguration)
        // Act
        let presentationCount = pageViewController.presentationCount(for: pageViewController)
        // Assert
        XCTAssertEqual(presentationCount, 0)
    }

    func testPresentationIndexZeroWhenHidesPageControl() {
        // Arrange
        var testConfiguration = TestConfiguration()
        testConfiguration.testHidesPageControl = true
        let pages = [UIViewController(), UIViewController(), UIViewController()]
        let pageViewController = DLAutoSlidePageViewController(pages: pages, configuration: testConfiguration)
        // Act
        let presentationIndex = pageViewController.presentationIndex(for: pageViewController)
        // Assert
        XCTAssertEqual(presentationIndex, 0)
    }

    func testCurrentPageIndexDidChange() {
        // Arrange
        var testConfiguration = TestConfiguration()
        testConfiguration.testTimeInterval = 0.0
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
        let pages = [firstViewController, secondViewController]
        let pageViewController = DLAutoSlidePageViewController(pages: pages, configuration: testConfiguration)
        let expectation = XCTestExpectation(description: "currentPageIndexDidChange closure should be called.")
        // Act
        pageViewController.currentPageIndexDidChange = { previousIndex, newIndex in
            XCTAssertEqual(previousIndex, 0)
            XCTAssertEqual(newIndex, 1)
            expectation.fulfill()
        }
        pageViewController.pageViewController(pageViewController, willTransitionTo: [secondViewController])
        pageViewController.pageViewController(pageViewController, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: true)
        // Assert
        wait(for: [expectation], timeout: 1)
    }

}
