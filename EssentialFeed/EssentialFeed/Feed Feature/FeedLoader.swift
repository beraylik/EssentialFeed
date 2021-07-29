//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 14.06.2021.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
