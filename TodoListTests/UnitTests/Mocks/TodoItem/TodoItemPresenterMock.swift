//
//  TodoItemPresenterMock.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 20.07.2022.
//
import Foundation
@testable import TodoList

class TodoItemPresenterMock: ITodoItemPresenter {

    var invokedViewLoaded = false
    var invokedViewLoadedCount = 0

    func viewLoaded() {
        invokedViewLoaded = true
        invokedViewLoadedCount += 1
    }

    var invokedUpdateItemText = false
    var invokedUpdateItemTextCount = 0
    var invokedUpdateItemTextParameters: (text: String, Void)?
    var invokedUpdateItemTextParametersList = [(text: String, Void)]()

    func updateItemText(text: String) {
        invokedUpdateItemText = true
        invokedUpdateItemTextCount += 1
        invokedUpdateItemTextParameters = (text, ())
        invokedUpdateItemTextParametersList.append((text, ()))
    }

    var invokedUpdateItemDeadline = false
    var invokedUpdateItemDeadlineCount = 0
    var invokedUpdateItemDeadlineParameters: (deadline: Date, Void)?
    var invokedUpdateItemDeadlineParametersList = [(deadline: Date, Void)]()

    func updateItemDeadline(deadline: Date) {
        invokedUpdateItemDeadline = true
        invokedUpdateItemDeadlineCount += 1
        invokedUpdateItemDeadlineParameters = (deadline, ())
        invokedUpdateItemDeadlineParametersList.append((deadline, ()))
    }

    var invokedUpdateItemImportance = false
    var invokedUpdateItemImportanceCount = 0
    var invokedUpdateItemImportanceParameters: (itemImportance: TodoItem.Importance, Void)?
    var invokedUpdateItemImportanceParametersList = [(itemImportance: TodoItem.Importance, Void)]()

    func updateItemImportance(itemImportance: TodoItem.Importance) {
        invokedUpdateItemImportance = true
        invokedUpdateItemImportanceCount += 1
        invokedUpdateItemImportanceParameters = (itemImportance, ())
        invokedUpdateItemImportanceParametersList.append((itemImportance, ()))
    }

    var invokedSaveItemChanges = false
    var invokedSaveItemChangesCount = 0

    func saveItemChanges() {
        invokedSaveItemChanges = true
        invokedSaveItemChangesCount += 1
    }
}
