//
//  TodoItemViewModel.swift
//  TodoList
//
//  Created by Yulya Greshnova on 14.06.2022.
//

import Foundation
import UIKit

struct TodoItemViewModel {
    let id: String
    var text: String
    var deadline: Date?
    var importance: TodoItem.Importance
    var isCompleted: Bool
}
