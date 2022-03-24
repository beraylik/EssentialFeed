//
//  UIRefreshControl+TestHelper.swift
//  EssentialFeediOSTests
//
//  Created by Genrikh Beraylik on 16.02.2022.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
