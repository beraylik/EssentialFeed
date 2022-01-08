//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 14.06.2021.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
