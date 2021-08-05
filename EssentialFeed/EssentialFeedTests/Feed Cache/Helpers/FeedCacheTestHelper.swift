//
//  FeedCacheTestHelper.swift
//  EssentialFeedTests
//
//  Created by Genrikh Beraylik on 05.08.2021.
//

import Foundation
import EssentialFeed

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyUrl() -> URL {
    return URL(string: "https://any-url.com")!
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let locals = models.map({ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) })
    return (models, locals)
}

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: nil, location: nil, url: anyUrl())
}


extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
