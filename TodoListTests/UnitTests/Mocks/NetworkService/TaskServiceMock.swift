//
//  TaskServiceMock.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 18.07.2022.
//

@testable import TodoList
@testable import Core

class TaskServiceMock: ITaskService {

    var invokedAddTask = false
    var invokedAddTaskCount = 0
    var invokedAddTaskParameters: (todoItem: TodoItem, Void)?
    var invokedAddTaskParametersList = [(todoItem: TodoItem, Void)]()
    var stubbedAddTaskCompletionResult: (Result<Int, Error>, Void)?
    var networksModels: [TaskNetworkModel]!
    init() { }
    convenience init(networkModels: [TaskNetworkModel]?) {
        self.init()
        self.networksModels = networkModels
    }

    func addTask(todoItem: TodoItem, completion: @escaping(Result<Int, Error>) -> Void) {
        invokedAddTask = true
        invokedAddTaskCount += 1
        invokedAddTaskParameters = (todoItem, ())
        invokedAddTaskParametersList.append((todoItem, ()))
        if let result = stubbedAddTaskCompletionResult {
            completion(result.0)
        }
    }

    var invokedGetTasks = false
    var invokedGetTasksCount = 0
    var stubbedGetTasksCompletionResult: (Result<[TaskNetworkModel], Error>, Void)?

    func getTasks(completion: @escaping(Result<[TaskNetworkModel], Error>) -> Void) {
        invokedGetTasks = true
        invokedGetTasksCount += 1
        if let result = stubbedGetTasksCompletionResult {
            completion(result.0)
        }
        if let networkModels = networksModels {
            completion(.success(networkModels))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }

    var invokedDeleteTask = false
    var invokedDeleteTaskCount = 0
    var invokedDeleteTaskParameters: (id: Int, Void)?
    var invokedDeleteTaskParametersList = [(id: Int, Void)]()
    var stubbedDeleteTaskCompletionResult: (Bool, Void)?

    func deleteTask(id: Int, completion: @escaping(Bool) -> Void) {
        invokedDeleteTask = true
        invokedDeleteTaskCount += 1
        invokedDeleteTaskParameters = (id, ())
        invokedDeleteTaskParametersList.append((id, ()))
        if let result = stubbedDeleteTaskCompletionResult {
            completion(result.0)
        }
    }

    var invokedUpdateTask = false
    var invokedUpdateTaskCount = 0
    var invokedUpdateTaskParameters: (todoItem: TodoItem, Void)?
    var invokedUpdateTaskParametersList = [(todoItem: TodoItem, Void)]()
    var stubbedUpdateTaskCompletionResult: (Bool, Void)?

    func updateTask(todoItem: TodoItem, completion: @escaping(Bool) -> Void) {
        invokedUpdateTask = true
        invokedUpdateTaskCount += 1
        invokedUpdateTaskParameters = (todoItem, ())
        invokedUpdateTaskParametersList.append((todoItem, ()))
        if let result = stubbedUpdateTaskCompletionResult {
            completion(result.0)
        }
    }

    var invokedCloseTask = false
    var invokedCloseTaskCount = 0
    var invokedCloseTaskParameters: (id: Int, Void)?
    var invokedCloseTaskParametersList = [(id: Int, Void)]()
    var stubbedCloseTaskCompletionResult: (Bool, Void)?

    func closeTask(id: Int, completion: @escaping(Bool) -> Void) {
        invokedCloseTask = true
        invokedCloseTaskCount += 1
        invokedCloseTaskParameters = (id, ())
        invokedCloseTaskParametersList.append((id, ()))
        if let result = stubbedCloseTaskCompletionResult {
            completion(result.0)
        }
    }

    var invokedReopenTask = false
    var invokedReopenTaskCount = 0
    var invokedReopenTaskParameters: (id: Int, Void)?
    var invokedReopenTaskParametersList = [(id: Int, Void)]()
    var stubbedReopenTaskCompletionResult: (Bool, Void)?

    func reopenTask(id: Int, completion: @escaping(Bool) -> Void) {
        invokedReopenTask = true
        invokedReopenTaskCount += 1
        invokedReopenTaskParameters = (id, ())
        invokedReopenTaskParametersList.append((id, ()))
        if let result = stubbedReopenTaskCompletionResult {
            completion(result.0)
        }
    }
}
