//
//  FileCacheMock.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 20.07.2022.
//

@testable import TodoList

class FileCacheMock: IFileCache {

    var invokedTodoItemsGetter = false
    var invokedTodoItemsGetterCount = 0
    var stubbedTodoItems: [TodoItem]! = []

    var todoItems: [TodoItem] {
        invokedTodoItemsGetter = true
        invokedTodoItemsGetterCount += 1
        return [TodoItemMock().todoItem]
    }

    var invokedAddNewItem = false
    var invokedAddNewItemCount = 0
    var invokedAddNewItemParameters: (item: TodoItem, Void)?
    var invokedAddNewItemParametersList = [(item: TodoItem, Void)]()

    func addNewItem(item: TodoItem) {
        invokedAddNewItem = true
        invokedAddNewItemCount += 1
        invokedAddNewItemParameters = (item, ())
        invokedAddNewItemParametersList.append((item, ()))
    }

    var invokedDeleteItem = false
    var invokedDeleteItemCount = 0
    var invokedDeleteItemParameters: (id: String, Void)?
    var invokedDeleteItemParametersList = [(id: String, Void)]()

    func deleteItem(id: String) {
        invokedDeleteItem = true
        invokedDeleteItemCount += 1
        invokedDeleteItemParameters = (id, ())
        invokedDeleteItemParametersList.append((id, ()))
    }

    var invokedSaveItems = false
    var invokedSaveItemsCount = 0

    func saveItems() {
        invokedSaveItems = true
        invokedSaveItemsCount += 1
    }

    var invokedLoadItems = false
    var invokedLoadItemsCount = 0
    var stubbedLoadItemsCompletionResult: (Bool, Void)?

    func loadItems(completion: @escaping(Bool) -> Void) {
        invokedLoadItems = true
        invokedLoadItemsCount += 1
        completion(true)
//        if let result = stubbedLoadItemsCompletionResult {
//            completion(result.0)
//        }
    }

    var invokedMarkCompleted = false
    var invokedMarkCompletedCount = 0
    var invokedMarkCompletedParameters: (id: String, Void)?
    var invokedMarkCompletedParametersList = [(id: String, Void)]()

    func markCompleted(id: String) {
        invokedMarkCompleted = true
        invokedMarkCompletedCount += 1
        invokedMarkCompletedParameters = (id, ())
        invokedMarkCompletedParametersList.append((id, ()))
    }

    var invokedReplaceItem = false
    var invokedReplaceItemCount = 0
    var invokedReplaceItemParameters: (item: TodoItem, Void)?
    var invokedReplaceItemParametersList = [(item: TodoItem, Void)]()

    func replaceItem(item: TodoItem) {
        invokedReplaceItem = true
        invokedReplaceItemCount += 1
        invokedReplaceItemParameters = (item, ())
        invokedReplaceItemParametersList.append((item, ()))
    }

    var invokedGetItemWith = false
    var invokedGetItemWithCount = 0
    var invokedGetItemWithParameters: (id: String, Void)?
    var invokedGetItemWithParametersList = [(id: String, Void)]()
    var stubbedGetItemWithResult: TodoItem = TodoItemMock().todoItem

    func getItemWith(id: String) -> TodoItem? {
        invokedGetItemWith = true
        invokedGetItemWithCount += 1
        invokedGetItemWithParameters = (id, ())
        invokedGetItemWithParametersList.append((id, ()))
        return stubbedGetItemWithResult
    }

    var invokedGetNetworkId = false
    var invokedGetNetworkIdCount = 0
    var invokedGetNetworkIdParameters: (id: String, Void)?
    var invokedGetNetworkIdParametersList = [(id: String, Void)]()
    var stubbedGetNetworkIdResult: Int = 1

    func getNetworkId(id: String) -> Int? {
        invokedGetNetworkId = true
        invokedGetNetworkIdCount += 1
        invokedGetNetworkIdParameters = (id, ())
        invokedGetNetworkIdParametersList.append((id, ()))
        return stubbedGetNetworkIdResult
    }

    var invokedUpdateAllItems = false
    var invokedUpdateAllItemsCount = 0
    var invokedUpdateAllItemsParameters: (items: [TodoItem], Void)?
    var invokedUpdateAllItemsParametersList = [(items: [TodoItem], Void)]()

    func updateAllItems(items: [TodoItem]) {
        invokedUpdateAllItems = true
        invokedUpdateAllItemsCount += 1
        invokedUpdateAllItemsParameters = (items, ())
        invokedUpdateAllItemsParametersList.append((items, ()))
    }
}
