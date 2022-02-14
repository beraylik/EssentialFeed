//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeediOSTests
//
//  Created by Genrikh Beraylik on 14.02.2022.
//

import XCTest

extension XCTestCase {

    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak")
        }
    }

}
