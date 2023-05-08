//
//  AutoSlideHelperTests.swift
//  DLAutoSlidePageViewControllerTests
//
//  Created by Alonso on 3/05/23.
//

@testable import DLAutoSlidePageViewController
import XCTest

final class AutoSlideHelperTests: XCTestCase {

    func testForwardDirection() {
        // Arrange
        let totalPageCount = 5
        let currentIndex = 1
        // Act
        let newPageIndex = AutoSlideHelper.pageIndex(for: currentIndex,
                                                     totalPageCount: totalPageCount,
                                                     direction: .forward)
        // Assert
        XCTAssertEqual(newPageIndex, 2)
    }

    func testForwardDirectionWithMaxCurrentIndex() {
        // Arrange
        let totalPageCount = 5
        let currentIndex = totalPageCount - 1
        // Act
        let newPageIndex = AutoSlideHelper.pageIndex(for: currentIndex,
                                                     totalPageCount: totalPageCount,
                                                     direction: .forward)
        // Assert
        XCTAssertEqual(newPageIndex, 0)
    }

    func testReverseDirection() {
        // Arrange
        let totalPageCount = 5
        let currentIndex = 1
        // Act
        let newPageIndex = AutoSlideHelper.pageIndex(for: currentIndex,
                                                     totalPageCount: totalPageCount,
                                                     direction: .reverse)
        // Assert
        XCTAssertEqual(newPageIndex, 0)
    }

    func testReverseDirectionWithZeroCurrentIndex() {
        // Arrange
        let totalPageCount = 5
        let currentIndex = 0
        // Act
        let newPageIndex = AutoSlideHelper.pageIndex(for: currentIndex,
                                                     totalPageCount: totalPageCount,
                                                     direction: .reverse)
        // Assert
        XCTAssertEqual(newPageIndex, totalPageCount - 1)
    }

}
