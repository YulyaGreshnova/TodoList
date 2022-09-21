//
//  NSLayoutConstraint+priority.swift
//  TodoList
//
//  Created by Yulya Greshnova on 13.06.2022.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func withPriority(_ withPriority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = withPriority
        return self
    }
}
