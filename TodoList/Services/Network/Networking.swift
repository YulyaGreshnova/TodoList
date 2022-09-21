//
//  Networking.swift
//  TodoList
//
//  Created by Yulya Greshnova on 24.06.2022.
//

import Foundation

protocol INetworking {
    func postNewProjectRequest(completion: @escaping(Result<[String: Any], Error>) -> Void)
    func postNewTaskRequest(task: NetworkingResponseModel, completion: @escaping(Result<Bool, Error>) -> Void)
    func getTaskRequest(completion: @escaping(Result<[NetworkingResponseModel], Error>) -> Void)
}

class NetworkClient: INetworking {
    private lazy var urlSession: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 30
        return session
    }()
    
    init() {
        
    }
    
    func getTaskRequest(completion: @escaping(Result<[NetworkingResponseModel], Error>) -> Void) {
        
         let request = NetworkingRequest(httpMethod: "GET", path: "/rest/v1/tasks").urlRequest
         guard let urlRequest = request else {
             completion(.failure(NetworkingError.invalidUrl))
             return
         }
         
         urlSession.dataTask(with: urlRequest) { (data, response, error) in
             if error != nil {
                 completion(.failure(NetworkingError.serviceError))
                 return
             }
             
             guard let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   let data = data else {
                 
                 completion(.failure(NetworkingError.serviceError))
                 return
             }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                let model = try jsonDecoder.decode([NetworkingResponseModel].self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(NetworkingError.parsingError))
                print(error)
            }
         }.resume()
    }
    
    func postNewTaskRequest(task: NetworkingResponseModel, completion: @escaping(Result<Bool, Error>) -> Void) {
       
        let request = NetworkingRequest(httpMethod: "POST", path: "/rest/v1/tasks").urlRequest
        guard var urlRequest = request else {
            completion(.failure(NetworkingError.invalidUrl))
            return
        }
    
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let jsonTask = try? encoder.encode(task)
        urlRequest.httpBody = jsonTask
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(.failure(NetworkingError.serviceError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  data != nil else {
                
                completion(.failure(NetworkingError.serviceError))
                return
            }
            
            completion(.success(true))
                  
        }.resume()
    }
    
    func postNewProjectRequest(completion: @escaping(Result<[String: Any], Error>) -> Void) {
        let project = ["name": "TodoList"]
        let jsonDataProject = try? JSONSerialization.data(withJSONObject: project, options: .prettyPrinted)
        let request = NetworkingRequest(httpMethod: "POST", path: "/rest/v1/projects").urlRequest
        guard var urlRequest = request else {
            completion(.failure(NetworkingError.invalidUrl))
            return
        }
        urlRequest.httpBody = jsonDataProject
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(.failure(NetworkingError.serviceError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data else {
                
                completion(.failure(NetworkingError.serviceError))
                return
            }
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                completion(.failure(NetworkingError.invalidJSONTypeError))
                return
            }
            
            completion(.success(jsonObject))
                  
        }.resume()
    }
}
