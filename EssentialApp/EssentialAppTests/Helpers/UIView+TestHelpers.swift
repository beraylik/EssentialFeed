//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Genrikh Beraylik on 10.05.2022.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
