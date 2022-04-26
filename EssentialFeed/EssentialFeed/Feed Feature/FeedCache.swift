//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 26.04.2022.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
