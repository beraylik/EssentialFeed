//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 24.03.2022.
//

import Foundation

public struct FeedImageViewModel<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    public var hasLocation: Bool {
        return location != nil
    }
}
