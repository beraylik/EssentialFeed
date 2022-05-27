//
//  FeedCacheTestHelper.swift
//  EssentialFeedTests
//
//  Created by Genrikh Beraylik on 05.08.2021.
//

import Foundation
import EssentialFeed
import EssentialFeedCache

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let locals = models.map({ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) })
    return (models, locals)
}

extension Date {
    private var feedMaxCacheAgeInDays: Int { return 7 }
    
    func minusFeedCacheMaxAge() -> Date {
        adding(days: -feedMaxCacheAgeInDays)
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
