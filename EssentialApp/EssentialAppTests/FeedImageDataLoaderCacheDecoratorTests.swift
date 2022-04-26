//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Genrikh Beraylik on 26.04.2022.
//

import XCTest
import EssentialFeed

final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    
    init(decoratee: FeedImageDataLoader) {
        self.decoratee = decoratee
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url, completion: completion)
    }
}

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let loader = LoaderSpy()
        let _ = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        
        XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loaded URLs")
    }
    
    func test_loadImageData_loadsFromloader() {
        let url = anyURL()
        let loader = LoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(loader.loadedURLs, [url], "Expected to load URL from loader")
    }
    
    func test_loadImageData_deliversImageDataOnLoaderSuccess() {
        let url = anyURL()
        let data = anyData()
        let loader = LoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        
        let exp = expectation(description: "Wait for loading")
        _ = sut.loadImageData(from: url) { result in
            switch result {
            case .success(let receivedData):
                XCTAssertEqual(receivedData, data)
                
            case .failure:
                XCTFail("Expected to receive success data, got \(result) instead")
            }
            exp.fulfill()
        }
        
        loader.complete(with: data)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_loadImageData_deliversErrorDataOnLoaderFailure() {
        let url = anyURL()
        let loader = LoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        
        let exp = expectation(description: "Wait for loading")
        _ = sut.loadImageData(from: url) { result in
            switch result {
            case .success:
                XCTFail("Expected to receive error, got \(result) instead")
                
            case .failure:
                break
            }
            exp.fulfill()
        }
        
        loader.complete(with: anyNSError())
        
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - Helpers
    
    private class LoaderSpy: FeedImageDataLoader {
        private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        var loadedURLs: [URL] {
            messages.map { $0.url }
        }
        
        private struct Task: FeedImageDataLoaderTask {
            func cancel() {}
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task()
        }
        
        func complete(with data: Data, at index: Int = 0) {
            messages[index].completion(.success(data))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
    
}
