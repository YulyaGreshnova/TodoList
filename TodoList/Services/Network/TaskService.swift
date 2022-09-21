//
//  TaskService.swift
//  TodoList
//
//  Created by Yulya Greshnova on 30.06.2022.
//

import Foundation
import Core

protocol ITaskService {
    func addTask(todoItem: TodoItem, completion: @escaping(Result<Int, Error>) -> Void)
    func getTasks(completion: @escaping(Result<[TaskNetworkModel], Error>) -> Void)
    func deleteTask(id: Int, completion: @escaping(Bool) -> Void)
    func updateTask(todoItem: TodoItem, completion: @escaping(Bool) -> Void)
    func closeTask(id: Int, completion: @escaping(Bool) -> Void)
    func reopenTask(id: Int, completion: @escaping(Bool) -> Void)
}

class TaskService: ITaskService {
    
    private let networkClient: INetworkClient
    
    init(networkClient: INetworkClient) {
        self.networkClient = networkClient
    }
    
    func addTask(todoItem: TodoItem, completion: @escaping(Result<Int, Error>) -> Void) {
        let networkingResponseModel = TaskNetworkModel(todoItem: todoItem)
        let request = NetworkRequestData<TaskNetworkModel>(path: "/rest/v1/tasks", httpMethod: "POST") {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try encoder.encode(networkingResponseModel)
        }
        
        networkClient.send(requestData: request) { result in
            switch result {
            case .success(let model):
                if let id = model.id {
                    completion(.success(id))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTasks(completion: @escaping(Result<[TaskNetworkModel], Error>) -> Void) {
        let request = NetworkRequestData<[TaskNetworkModel]>(path: "/rest/v1/tasks", httpMethod: "GET", encode: nil)
        networkClient.send(requestData: request) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteTask(id: Int, completion: @escaping(Bool) -> Void) {
        let request = NetworkRequestData<Void>(path: "/rest/v1/tasks/\(id)", httpMethod: "DELETE", encode: nil)
        
        networkClient.send(requestData: request) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func updateTask(todoItem: TodoItem, completion: @escaping(Bool) -> Void) {
        let networkingResponseModel = TaskNetworkModel(todoItem: todoItem)
        guard let id = todoItem.networkId else { return }
        let request = NetworkRequestData<Void>(path: "/rest/v1/tasks/\(id)", httpMethod: "POST") {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try encoder.encode(networkingResponseModel)
        }
        
        networkClient.send(requestData: request) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func closeTask(id: Int, completion: @escaping(Bool) -> Void) {
        let request = NetworkRequestData<Void>(path: "/rest/v1/tasks/\(id)/close", httpMethod: "POST", encode: nil)
        
        networkClient.send(requestData: request) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func reopenTask(id: Int, completion: @escaping(Bool) -> Void) {
        let request = NetworkRequestData<Void>(path: "/rest/v1/tasks/\(id)/reopen", httpMethod: "POST", encode: nil)
        
        networkClient.send(requestData: request) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
