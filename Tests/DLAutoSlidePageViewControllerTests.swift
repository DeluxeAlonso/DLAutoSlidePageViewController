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

}
