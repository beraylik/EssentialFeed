//
//  SharedTestHelpers.swift
//  EssentialFeedAPITests
//
//  Created by Genrikh Beraylik on 20.05.2022.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}
