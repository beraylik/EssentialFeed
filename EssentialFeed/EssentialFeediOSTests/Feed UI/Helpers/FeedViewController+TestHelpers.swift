//
//  FeedViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Genrikh Beraylik on 16.02.2022.
//

import UIKit
import EssentialFeediOS

extension FeedViewController {
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    var errorMessage: String? {
        return errorView?.message
    }
    
    var feedImagesSection: Int {
        return 0
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView(tableView, numberOfRowsInSection: feedImagesSection)
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)
        let index = IndexPath(row: row, section: feedImagesSection)
        tableView.delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        return view
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        let index = IndexPath(row: row, section: feedImagesSection)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: index)
    }
    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let index = IndexPath(row: row, section: feedImagesSection)
        tableView.prefetchDataSource?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let index = IndexPath(row: row, section: feedImagesSection)
        tableView.prefetchDataSource?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
}
