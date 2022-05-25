//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 24.03.2022.
//

import EssentialFeed

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
