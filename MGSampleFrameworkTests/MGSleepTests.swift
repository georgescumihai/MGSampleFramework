//
//  MGSleepTests.swift
//  MGSampleFrameworkTests
//
//  Created by Mihai Georgescu on 28/09/2018.
//  Copyright © 2018 Mihai Georgescu. All rights reserved.
//

import XCTest
@testable import MGSampleFramework

class MGSleepTests: XCTestCase {

    func testSleep() {
        let timer: TimeInterval = 0.1

        let sleep = MGSleep(name: "Short nap")

        let expectation = self.expectation(description: "Sleep finished")
        sleep.goToSleep(time: timer) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testNoCallbackCalled() {
        let timer: TimeInterval = 1

        let sleep = MGSleep(name: "Short nap")

        let expectation = self.expectation(description: "Sleep finished")
        expectation.isInverted = true
        sleep.goToSleep(time: timer) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
    }
}
