//
//  ⚕️ 💓 HealthCheck
//  HealthCheck.swift
//
//  The MIT License (MIT)
//
//  Copyright © 2020 Ron Pinz.  All rights reserved.
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

/// ⚕️ 💓 HealthCheck class
public final class HealthCheck {
    private let semaphore: DispatchSemaphore
    private var last: Double

    /// request counter
    public var counter: Int
    /// server start time
    public let epoch: Double
    /// server uptime
    public var uptime: Double {
        self.semaphore.wait()
        self.last = Date().timeIntervalSince1970
        self.semaphore.signal()
        return self.last - self.epoch
    }

    /// initialize HealthCheck class
    public init() {
        self.semaphore = DispatchSemaphore(value: 1)
        self.counter = 0
        self.epoch = Date().timeIntervalSince1970
        self.last = Date().timeIntervalSince1970
    }

    /// increment request counter
    public func increment() {
        self.semaphore.wait()
        self.last = Date().timeIntervalSince1970
        self.counter += 1
        self.semaphore.signal()
    }

    /// return response to ping request
    public func ping() -> HealthCheckResponse {
        self.increment()
        return HealthCheckResponse(healthCheck: self)
    }
}

public struct HealthCheckResponse: Codable {
    /// uuid
    public var id: UUID?
    /// server start time
    public var epoch: Double
    /// server uptime
    public var uptime: Double
    /// request counter
    public var counter: Int

    /// initialize HealthCheckResponse struct from args
    public init(
        id: UUID = UUID(),
        epoch: Double = 0.0,
        uptime: Double = 0.0,
        counter: Int = 0
    ) {
        self.id = id
        self.counter = counter
        self.epoch = epoch
        self.uptime = uptime
    }

    /// initialize HealthCheckResponse struct from HealthCheck class
    public init(
        healthCheck: HealthCheck
    ) {
        self.id = UUID()
        self.counter = healthCheck.counter
        self.epoch = healthCheck.epoch
        self.uptime = healthCheck.uptime
    }
}
