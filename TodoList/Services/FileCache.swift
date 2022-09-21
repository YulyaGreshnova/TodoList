//
//  FileCache.swift
//  TodoList
//
//  Created by Yulya Greshnova on 27.05.2022.
//

import Foundation

protocol IFileCache: AnyObject {
    var todoItems: [TodoItem] { get }
    func addNewItem(item: TodoItem)
    func deleteItem(id: String)
    func saveItems()
    func loadItems(completion: @escaping(Bool) -> Void)
    func markCompleted(id: String)
    func replaceItem(item: TodoItem)
    func getItemWith(id: String) -> TodoItem?
    func getNetworkId(id: String) -> Int?
    func updateAllItems(items: [TodoItem])
}

enum CacheError: Error {
    case failedSaveItems
    case failedFetchItems
}

final class FileCache: IFileCache {
    private(set) var todoItems = [TodoItem]()
    private let fileManager = FileManager.default
    private let concurrentQueue: DispatchQueue
    
    private struct Constants {
        static let fileName = "todoItems"
    }
    
    init() {
        concurrentQueue = DispatchQueue.global(qos: .utility)
    }
    
    func addNewItem(item: TodoItem) {
        todoItems.append(item)
    }

    func deleteItem(id: String) {
        if let index = todoItems.firstIndex(where: { $0.id == id }) {
            todoItems.remove(at: index)
        }
    }
    
    func markCompleted(id: String) {
        if let index = todoItems.firstIndex(where: { $0.id == id }) {
            todoItems[index].isCompleted = !todoItems[index].isCompleted
        }
    }
    
    func replaceItem(item: TodoItem) {
        if let index = todoItems.firstIndex(of: item) {
            todoItems[index] = item
        }
    }
    
    func getItemWith(id: String) -> TodoItem? {
        if let index = todoItems.firstIndex(where: { $0.id == id }) {
            return todoItems[index]
        } else {
            return nil
        }
    }
    
    func getNetworkId(id: String) -> Int? {
        if let index = todoItems.firstIndex(where: { $0.id == id }) {
            return todoItems[index].networkId
        } else {
            return nil
        }
    }

    func saveItems() {
        concurrentQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                let fileURL = try self.fileUrl(fileName: Constants.fileName)
                let data = try JSONEncoder().encode(self.todoItems)
                try data.write(to: fileURL)
            } catch {
                print(CacheError.failedSaveItems)
            }
        }
    }

    func loadItems(completion: @escaping(Bool) -> Void) {
        concurrentQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                let fileURL = try self.fileUrl(fileName: Constants.fileName)
                let data = try Data(contentsOf: fileURL)
                let items = try JSONDecoder().decode([TodoItem].self, from: data)
                self.todoItems = items
                completion(true)
            } catch {
                print(CacheError.failedFetchItems)
                completion(false)
            }
        }
    }
    
    func updateAllItems(items: [TodoItem]) {
        todoItems = items
    }

    private func fileUrl(fileName: String) throws-> URL {
        let documentDirectory = try fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
        return documentDirectory.appendingPathComponent("todoItems")
    }
}
