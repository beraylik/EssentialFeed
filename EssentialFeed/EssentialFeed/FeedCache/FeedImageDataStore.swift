//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 15.04.2022.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
