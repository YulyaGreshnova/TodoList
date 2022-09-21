//
//  TodoItemsViewModal.swift
//  TodoList
//
//  Created by Yulya Greshnova on 12.06.2022.
//

import Foundation

struct TodoItemListViewModel {
    let id: String
    let text: String
    let deadline: Date?
    let importance: TodoItem.Importance
    let isCompleted: Bool
}

extension TodoItemListViewModel: Equatable {
    static func == (lhs: TodoItemListViewModel, rhs: TodoItemListViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
