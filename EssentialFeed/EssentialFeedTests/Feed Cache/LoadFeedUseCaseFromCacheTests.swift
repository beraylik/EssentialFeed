//
//  LoadFeedUseCaseFromCacheTests.swift
//  EssentialFeedTests
//
//  Created by Genrikh Beraylik on 04.08.2021.
//

import XCTest
import EssentialFeed

class LoadFeedUseCaseFromCacheTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
 
    func test_init_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
 
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
}
