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
        let sut = CodableFeedStore()
        
        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Expected empty cache got \(result) instead")
            }
        }
    }
    
}
