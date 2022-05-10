//
//  UITableView+HeaderSizing.swift
//  EssentialFeediOS
//
//  Created by Genrikh Beraylik on 10.05.2022.
//

import UIKit

extension UITableView {
    func sizeTableHeaderToFit() {
        func sizeTableHeaderToFit() {
            guard let header = tableHeaderView else { return }
            
            let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
            let needsFrameUpdate = header.frame.height != size.height
            if needsFrameUpdate {
                header.frame.size.height = size.height
                tableHeaderView = header
            }
        }
    }
}
