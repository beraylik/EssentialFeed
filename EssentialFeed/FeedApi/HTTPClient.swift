//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Genrikh Beraylik on 18.06.2021.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
