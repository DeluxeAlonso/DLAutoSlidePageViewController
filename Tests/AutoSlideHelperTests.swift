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
        let currentIndex = 1
        let totalPageCount = 5
        // Act
        let newPageIndex = AutoSlideHelper.pageIndex(for: currentIndex,
                                                     totalPageCount: totalPageCount,
                                                     direction: .forward)
        // Assert
        XCTAssertEqual(newPageIndex, 2)
    }

}
