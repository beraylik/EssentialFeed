//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Genrikh Beraylik on 14.02.2022.
//

import XCTest

final class FeedViewController: UIViewController {
    convenience init(loader: FeedViewControllerTests.LoaderSpy) {
        self.init()
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount = 0
    }
    
}
