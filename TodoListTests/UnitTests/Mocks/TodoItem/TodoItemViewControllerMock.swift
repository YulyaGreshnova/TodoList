//
//  TodoItemViewControllerMock.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 20.07.2022.
//

@testable import TodoList

class TodoItemViewControllerMock: ITodoItemViewController {

    var invokedShowTodoItemViewModel = false
    var invokedShowTodoItemViewModelCount = 0
    var invokedShowTodoItemViewModelParameters: (item: TodoItemViewModel, isNewItem: Bool)?
    var invokedShowTodoItemViewModelParametersList = [(item: TodoItemViewModel, isNewItem: Bool)]()

    func showTodoItemViewModel(item: TodoItemViewModel, isNewItem: Bool) {
        invokedShowTodoItemViewModel = true
        invokedShowTodoItemViewModelCount += 1
        invokedShowTodoItemViewModelParameters = (item, isNewItem)
        invokedShowTodoItemViewModelParametersList.append((item, isNewItem))
    }

    var invokedSaveModelChanges = false
    var invokedSaveModelChangesCount = 0
    var invokedSaveModelChangesParameters: (id: String, isNew: Bool)?
    var invokedSaveModelChangesParametersList = [(id: String, isNew: Bool)]()

    func saveModelChanges(id: String, isNew: Bool) {
        invokedSaveModelChanges = true
        invokedSaveModelChangesCount += 1
        invokedSaveModelChangesParameters = (id, isNew)
        invokedSaveModelChangesParametersList.append((id, isNew))
    }

    var invokedShowErrorAlert = false
    var invokedShowErrorAlertCount = 0

    func showErrorAlert() {
        invokedShowErrorAlert = true
        invokedShowErrorAlertCount += 1
    }
}
