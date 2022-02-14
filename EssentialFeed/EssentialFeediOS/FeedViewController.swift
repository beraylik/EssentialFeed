//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Genrikh Beraylik on 14.02.2022.
//

import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    
    convenience public init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)

        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load() { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}
