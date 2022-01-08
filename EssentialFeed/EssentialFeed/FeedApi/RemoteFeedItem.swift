//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 29.07.2021.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
