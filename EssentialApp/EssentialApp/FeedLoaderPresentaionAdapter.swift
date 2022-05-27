//
//  FeedLoaderPresentaionAdapter.swift
//  EssentialFeediOS
//
//  Created by Genrikh Beraylik on 24.02.2022.
//

import EssentialFeed
import EssentialFeediOS
import EssentialFeedPresentation

final class FeedLoaderPresentaionAdapter: FeedViewControllerDelegate {
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
