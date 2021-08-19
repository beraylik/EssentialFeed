//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Genrikh Beraylik on 19.08.2021.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
        }
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Expected retreiving twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> CodableFeedStore {
        let sut = CodableFeedStore()
        trackForMemoryLeaks(sut)
        return sut
    }
    
}
