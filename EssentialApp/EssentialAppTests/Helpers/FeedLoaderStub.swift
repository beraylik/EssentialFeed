//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Genrikh Beraylik on 26.04.2022.
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
