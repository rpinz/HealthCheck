//
//  ⚕️ 💓 HealthCheck
//  HealthCheckTests.swift
//
//  The MIT License (MIT)
//
//  Copyright © 2019 - 2020  Ron Pinz.  All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
@testable import HealthCheck
import XCTest

private var healthCheck: HealthCheck = HealthCheck()

public final class HealthCheckTests: XCTestCase {
    public func testEpoch() {
        XCTAssertNotEqual(healthCheck.epoch, 0.0)
        XCTAssertGreaterThan(healthCheck.epoch, 1_000_000_000.0) // Sun 09 Sep 2001 01:46:40 AM UTC
        XCTAssertLessThan(healthCheck.epoch, 2_000_000_000.0) // Wed 18 May 2033 03:33:20 AM UTC
    }

    public func testCounter() {
        XCTAssertEqual(healthCheck.counter, 0)
        healthCheck.increment()
        XCTAssertGreaterThan(healthCheck.counter, 0)
        XCTAssertEqual(healthCheck.counter, 1)
    }

    public func testUptime() {
        XCTAssertNotEqual(healthCheck.uptime, 0.0)
        XCTAssertGreaterThan(healthCheck.uptime, 0.0)
        XCTAssertLessThan(healthCheck.uptime, 1.0)
        sleep(1)
        XCTAssertGreaterThan(healthCheck.uptime, 1.0)
    }

    public func testResponseId() {
        let healthCheckResponse: HealthCheckResponse = HealthCheckResponse(healthCheck: healthCheck)
        XCTAssertNotEqual(healthCheckResponse.id!, UUID())
    }

    public func testResponseEpoch() {
        let healthCheckResponse: HealthCheckResponse = HealthCheckResponse(healthCheck: healthCheck)
        XCTAssertLessThan(healthCheckResponse.epoch, Date().timeIntervalSince1970)
    }

    public func testResponseUptime() {
        let healthCheckResponse: HealthCheckResponse = HealthCheckResponse(healthCheck: healthCheck)
        XCTAssertGreaterThan(healthCheck.uptime, 0.0)
        XCTAssertGreaterThan(healthCheckResponse.uptime, 0.0)
        sleep(1)
        XCTAssertGreaterThan(healthCheck.uptime, 1.0)
        XCTAssertGreaterThan(healthCheckResponse.uptime, 0.0)
        sleep(1)
        let now: HealthCheckResponse = HealthCheckResponse(healthCheck: healthCheck)
        XCTAssertGreaterThan(now.uptime, 2.0)
    }

    public func testResponseCounter() {
        let healthCheckResponse: HealthCheckResponse = HealthCheckResponse(healthCheck: healthCheck)
        XCTAssertEqual(healthCheck.counter, 1)
        XCTAssertEqual(healthCheckResponse.counter, 1)
        healthCheck.increment()
        XCTAssertEqual(healthCheck.counter, 2)
        XCTAssertEqual(healthCheckResponse.counter, 1)

        let now: HealthCheckResponse = HealthCheckResponse(healthCheck: healthCheck)
        healthCheck.increment()
        XCTAssertEqual(healthCheck.counter, 3)
        XCTAssertNotEqual(now.counter, 0)
        XCTAssertNotEqual(now.counter, 1)
        XCTAssertEqual(now.counter, 2)
    }

    public static let allTests: [(String, (HealthCheckTests) -> () -> Void)] = [
        ("testEpoch", testEpoch),
        ("testCounter", testCounter),
        ("testUptime", testUptime),
        ("testResponseId", testResponseId),
        ("testResponseEpoch", testResponseEpoch),
        ("testResponseUptime", testResponseUptime),
        ("testResponseCounter", testResponseCounter)
    ]
}
