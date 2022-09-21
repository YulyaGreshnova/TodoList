//
//  TodoItemListViewControllerMock.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 18.07.2022.
//

@testable import TodoList
@testable import Core

class TodoItemListViewControllerMock: ITodoItemListViewController {

    var invokedIsFilteredItemSetter = false
    var invokedIsFilteredItemSetterCount = 0
    var invokedIsFilteredItem: Bool?
    var invokedIsFilteredItemList = [Bool]()
    var invokedIsFilteredItemGetter = false
    var invokedIsFilteredItemGetterCount = 0
    var stubbedIsFilteredItem: Bool! = false

    var isFilteredItem: Bool {
        get {
            invokedIsFilteredItemGetter = true
            invokedIsFilteredItemGetterCount += 1
            return stubbedIsFilteredItem
        }
        set {
            invokedIsFilteredItemSetter = true
            invokedIsFilteredItemSetterCount += 1
            invokedIsFilteredItem = newValue
            invokedIsFilteredItemList.append(newValue)
        }
    }

    var invokedShowTodoItemsViewModel = false
    var invokedShowTodoItemsViewModelCount = 0
    var invokedShowTodoItemsViewModelParameters: (viewModels: [TodoItemListViewModel], Void)?
    var invokedShowTodoItemsViewModelParametersList = [(viewModels: [TodoItemListViewModel], Void)]()

    func showTodoItemsViewModel(viewModels: [TodoItemListViewModel]) {
        invokedShowTodoItemsViewModel = true
        invokedShowTodoItemsViewModelCount += 1
        invokedShowTodoItemsViewModelParameters = (viewModels, ())
        invokedShowTodoItemsViewModelParametersList.append((viewModels, ()))
    }

    var invokedUpdateTodoItem = false
    var invokedUpdateTodoItemCount = 0
    var invokedUpdateTodoItemParameters: (viewModel: TodoItemListViewModel, index: Int)?
    var invokedUpdateTodoItemParametersList = [(viewModel: TodoItemListViewModel, index: Int)]()

    func updateTodoItem(viewModel: TodoItemListViewModel, index: Int) {
        invokedUpdateTodoItem = true
        invokedUpdateTodoItemCount += 1
        invokedUpdateTodoItemParameters = (viewModel, index)
        invokedUpdateTodoItemParametersList.append((viewModel, index))
    }

    var invokedRemoveItem = false
    var invokedRemoveItemCount = 0
    var invokedRemoveItemParameters: (index: Int, Void)?
    var invokedRemoveItemParametersList = [(index: Int, Void)]()

    func removeItem(index: Int) {
        invokedRemoveItem = true
        invokedRemoveItemCount += 1
        invokedRemoveItemParameters = (index, ())
        invokedRemoveItemParametersList.append((index, ()))
    }

    var invokedUpdateFilteredCompletedItemCount = false
    var invokedUpdateFilteredCompletedItemCountCount = 0

    func updateFilteredCompletedItemCount() {
        invokedUpdateFilteredCompletedItemCount = true
        invokedUpdateFilteredCompletedItemCountCount += 1
    }

    var invokedShowErrorAlert = false
    var invokedShowErrorAlertCount = 0

    func showErrorAlert() {
        invokedShowErrorAlert = true
        invokedShowErrorAlertCount += 1
    }

    var invokedShowSuccessSynchronisationAlert = false
    var invokedShowSuccessSynchronisationAlertCount = 0

    func showSuccessSynchronisationAlert() {
        invokedShowSuccessSynchronisationAlert = true
        invokedShowSuccessSynchronisationAlertCount += 1
    }
}
