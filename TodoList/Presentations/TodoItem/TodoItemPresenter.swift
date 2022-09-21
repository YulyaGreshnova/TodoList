//
//  TodoItemPresenter.swift
//  TodoList
//
//  Created by Yulya Greshnova on 11.06.2022.
//

import Foundation
import UIKit

enum TypesItem {
    case newItem
    case item(id: String)
}

protocol ITodoItemPresenter: AnyObject {
    func viewLoaded()
    func updateItemText(text: String)
    func updateItemDeadline(deadline: Date)
    func updateItemImportance(itemImportance: TodoItem.Importance)
    func saveItemChanges()
}

final class TodoItemPresenter: ITodoItemPresenter {
    private var todoItem: TodoItem
    private let fileCache: IFileCache
    private let networkingTaskService: ITaskService
    weak var viewController: ITodoItemViewController?
    private var isNewItem = true
    
    init(typeItem: TypesItem, fileCache: IFileCache, networkingTaskService: ITaskService) {
        self.fileCache = fileCache
        self.networkingTaskService = networkingTaskService
        
        switch typeItem {
        case .newItem:
            todoItem = TodoItem(id: UUID().uuidString,
                                text: "",
                                deadline: nil,
                                importance: .ordinary,
                                isCompleted: false)
        case .item(let id):
            if let item = fileCache.todoItems.first(where: { $0.id == id }) {
                todoItem = item
                isNewItem = false
            } else {
                todoItem = TodoItem(id: UUID().uuidString,
                                    text: "",
                                    deadline: nil,
                                    importance: .ordinary,
                                    isCompleted: false)
                isNewItem = true
            }
        }
    }
    
    func viewLoaded() {
        let itemViewModel = createViewModel(item: todoItem)
        viewController?.showTodoItemViewModel(item: itemViewModel, isNewItem: isNewItem)
    }
    
    func updateItemText(text: String) {
        todoItem.text = text
        if text == "" {
            todoItem.text = "нет описания дела"
        }
    }
    
    func updateItemDeadline(deadline: Date) {
        todoItem.deadline = deadline
    }
    
    func updateItemImportance(itemImportance: TodoItem.Importance) {
        todoItem.importance = itemImportance
    }
    
    func saveItemChanges() {
        if isNewItem {
            createNewItem()
        } else {
            updateItem()
        }
    }
}

// MARK: - InternalMethods
private extension TodoItemPresenter {
    func createViewModel(item: TodoItem) -> TodoItemViewModel {
        return TodoItemViewModel(id: item.id,
                                 text: item.text,
                                 deadline: item.deadline,
                                 importance: item.importance,
                                 isCompleted: item.isCompleted)
    }
    
    func createNewItem() {
        networkingTaskService.addTask(todoItem: todoItem) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let networkId):
                self.todoItem.networkId = networkId
                DispatchQueue.main.async {
                    self.fileCache.addNewItem(item: self.todoItem)
                    self.fileCache.saveItems()
                    self.viewController?.saveModelChanges(id: self.todoItem.id, isNew: true)
                }
            case .failure(let error):
                print(error)
                self.viewController?.showErrorAlert()
            }
        }
    }
    
    func updateItem() {
        networkingTaskService.updateTask(todoItem: todoItem) { [weak self] isSuccess in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isSuccess {
                    self.fileCache.replaceItem(item: self.todoItem)
                    self.fileCache.saveItems()
                    self.viewController?.saveModelChanges(id: self.todoItem.id, isNew: false)
                } else {
                    self.viewController?.showErrorAlert()
                }
            }
        }
    }
}
