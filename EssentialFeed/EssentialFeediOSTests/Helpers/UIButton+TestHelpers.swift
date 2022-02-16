//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Genrikh Beraylik on 16.02.2022.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
