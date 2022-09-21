//
//  TodoItemListPresenter.swift
//  TodoList
//
//  Created by Yulya Greshnova on 11.06.2022.
//

import Foundation

protocol ITodoItemListPresenter: AnyObject {
    func viewLoaded()
    func filterCompletedItems()
    func filterAllItems()
    func getItems(items: ItemFilteredType) -> [TodoItemListViewModel]
    func saveTodoItems()
    func deleteItem(id: String, index: Int)
    func toggleIsCompletedItem(index: Int, id: String, isFiltred: Bool, isCompletedItem: Bool)
    func getItemWith(id: String) -> TodoItemListViewModel?
}

enum ItemFilteredType {
    case all
    case completed
}

final class TodoItemListPresenter: ITodoItemListPresenter {
    private let fileCache: IFileCache
    private let networkingTaskService: ITaskService
    weak var viewController: ITodoItemListViewController?
    
    init(fileCache: IFileCache, networkingTaskService: ITaskService) {
        self.fileCache = fileCache
        self.networkingTaskService = networkingTaskService
    }
    
    func getItems(items: ItemFilteredType) -> [TodoItemListViewModel] {
        switch items {
        case .all:
            return fileCache.todoItems.map { createViewModel($0) }
        case .completed:
            let completedItems = fileCache.todoItems.filter { $0.isCompleted }
            let comletedViewModelItems = completedItems.map { createViewModel($0) }
            return comletedViewModelItems
        }
    }
    
    func viewLoaded() {
        fileCache.loadItems {[weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                DispatchQueue.main.async {
                    self.viewController?.showTodoItemsViewModel(viewModels: self.getItems(items: .all))
                    self.viewController?.updateFilteredCompletedItemCount()
                }
                self.loadItemFromNetwork()
                self.fileCache.saveItems()
            }
        }
    }
    
    func filterCompletedItems() {
        viewController?.showTodoItemsViewModel(viewModels: getItems(items: .completed))
    }
    
    func filterAllItems() {
        viewController?.showTodoItemsViewModel(viewModels: getItems(items: .all))
    }

    func saveTodoItems() {
        fileCache.saveItems()
    }
    
    func deleteItem(id: String, index: Int) {
        if let networkId = fileCache.getNetworkId(id: id) {
            networkingTaskService.deleteTask(id: networkId) {[weak self] isSuccess in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if !isSuccess {
                        self.viewController?.showErrorAlert()
                    }
                }
            }
        }
        fileCache.deleteItem(id: id)
        viewController?.removeItem(index: index)
        fileCache.saveItems()
        
    }
    
    func toggleIsCompletedItem(index: Int,
                               id: String,
                               isFiltred: Bool,
                               isCompletedItem: Bool) {
        fileCache.markCompleted(id: id)
        guard let todoItem = fileCache.getItemWith(id: id) else { return }
        guard let networkId = todoItem.networkId else { return }
        if isFiltred {
            viewController?.removeItem(index: index)
        } else {
            viewController?.updateTodoItem(viewModel: createViewModel(todoItem),
                                           index: index)
        }
        if isCompletedItem {
            networkingTaskService.closeTask(id: networkId) {[weak self] isSuccess in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if !isSuccess {
                        self.viewController?.showErrorAlert()
                    }
                }
            }
        } else {
            networkingTaskService.reopenTask(id: networkId) {[weak self] isSuccess in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if !isSuccess {
                        self.viewController?.showErrorAlert()
                    }
                }
            }
        }
        fileCache.saveItems()
    }
    
    func getItemWith(id: String) -> TodoItemListViewModel? {
        if let todoItem = fileCache.getItemWith(id: id) {
            let viewModel = createViewModel(todoItem)
           return viewModel
        }
        return nil
    }
}

// MARK: - Private functions
private extension TodoItemListPresenter {
    func createViewModel(_ item: TodoItem) -> TodoItemListViewModel {
        let todoItemViewModel = TodoItemListViewModel(id: item.id,
                                                  text: item.text,
                                                  deadline: item.deadline,
                                                  importance: item.importance,
                                                  isCompleted: item.isCompleted)
        return todoItemViewModel
    }
    
    func createItem(networkModel: TaskNetworkModel) -> TodoItem {
        var importance: TodoItem.Importance
        switch networkModel.priority {
        case 1: importance = .important
        case 2: importance = .ordinary
        case 3: importance = .unimportant
        default: importance = .unimportant
        }
        let id = String(networkModel.id!)
        let todoItem = TodoItem(id: id,
                                text: networkModel.content,
                                deadline: networkModel.dueDate,
                                importance: importance,
                                isCompleted: networkModel.completed,
                                networkId: networkModel.id)
        return todoItem
    }
    
    func loadItemFromNetwork() {
        networkingTaskService.getTasks {[weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let networkModels):
                    let todoItems = networkModels.map { self.createItem(networkModel: $0)}
                    self.fileCache.updateAllItems(items: todoItems)
                    self.viewController?.showTodoItemsViewModel(viewModels: self.getItems(items: .all))
                    self.viewController?.updateFilteredCompletedItemCount()
                    self.viewController?.showSuccessSynchronisationAlert()
                case .failure(let error):
                    print(error)
                    self.viewController?.showErrorAlert()
                }
            }
        }
    }
}
