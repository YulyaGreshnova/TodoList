//
//  TodoItemListPresenterMock.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 19.07.2022.
//

import Foundation
@testable import TodoList
@testable import Core

class TodoItemListPresenterMock: ITodoItemListPresenter {

    var invokedViewLoaded = false
    var invokedViewLoadedCount = 0

    func viewLoaded() {
        invokedViewLoaded = true
        invokedViewLoadedCount += 1
    }

    var invokedFilterCompletedItems = false
    var invokedFilterCompletedItemsCount = 0

    func filterCompletedItems() {
        invokedFilterCompletedItems = true
        invokedFilterCompletedItemsCount += 1
    }

    var invokedFilterAllItems = false
    var invokedFilterAllItemsCount = 0

    func filterAllItems() {
        invokedFilterAllItems = true
        invokedFilterAllItemsCount += 1
    }

    var invokedGetItems = false
    var invokedGetItemsCount = 0
    var invokedGetItemsParameters: (items: ItemFilteredType, Void)?
    var invokedGetItemsParametersList = [(items: ItemFilteredType, Void)]()
    var stubbedGetItemsResult: [TodoItemListViewModel]! = []

    func getItems(items: ItemFilteredType) -> [TodoItemListViewModel] {
        invokedGetItems = true
        invokedGetItemsCount += 1
        invokedGetItemsParameters = (items, ())
        invokedGetItemsParametersList.append((items, ()))
        return stubbedGetItemsResult
    }

    var invokedSaveTodoItems = false
    var invokedSaveTodoItemsCount = 0

    func saveTodoItems() {
        invokedSaveTodoItems = true
        invokedSaveTodoItemsCount += 1
    }

    var invokedDeleteItem = false
    var invokedDeleteItemCount = 0
    var invokedDeleteItemParameters: (id: String, index: Int)?
    var invokedDeleteItemParametersList = [(id: String, index: Int)]()

    func deleteItem(id: String, index: Int) {
        invokedDeleteItem = true
        invokedDeleteItemCount += 1
        invokedDeleteItemParameters = (id, index)
        invokedDeleteItemParametersList.append((id, index))
    }

    var invokedToggleIsCompletedItem = false
    var invokedToggleIsCompletedItemCount = 0
    var invokedToggleIsCompletedItemParameters: (index: Int, id: String, isFiltred: Bool, isComletedItem: Bool)?
    var invokedToggleIsCompletedItemParametersList = [(index: Int, id: String, isFiltred: Bool, isComletedItem: Bool)]()

    func toggleIsCompletedItem(index: Int, id: String, isFiltred: Bool, isCompletedItem: Bool) {
        invokedToggleIsCompletedItem = true
        invokedToggleIsCompletedItemCount += 1
        invokedToggleIsCompletedItemParameters = (index, id, isFiltred, isCompletedItem)
        invokedToggleIsCompletedItemParametersList.append((index, id, isFiltred, isCompletedItem))
    }

    var invokedGetItemWith = false
    var invokedGetItemWithCount = 0
    var invokedGetItemWithParameters: (id: String, Void)?
    var invokedGetItemWithParametersList = [(id: String, Void)]()
    var stubbedGetItemWithResult: TodoItemListViewModel!

    func getItemWith(id: String) -> TodoItemListViewModel? {
        invokedGetItemWith = true
        invokedGetItemWithCount += 1
        invokedGetItemWithParameters = (id, ())
        invokedGetItemWithParametersList.append((id, ()))
        return stubbedGetItemWithResult
    }
}
