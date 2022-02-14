//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 14.06.2021.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
