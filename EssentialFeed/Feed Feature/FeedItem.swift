//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 14.06.2021.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
