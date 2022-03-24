//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Genrikh Beraylik on 24.03.2022.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
