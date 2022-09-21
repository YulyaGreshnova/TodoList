//
//  Networking.swift
//  TodoList
//
//  Created by Yulya Greshnova on 24.06.2022.
//

import Foundation

public protocol INetworkClient {
    func send<ResponseType>(requestData: NetworkRequestData<ResponseType>,
                            completion: @escaping(Result<ResponseType, Error>) -> Void)
}

public class NetworkClient: INetworkClient {
    private let requestBuilder: INetworkingRequest
    private lazy var urlSession: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 30
        return session
    }()
    
    public init(requestBuilder: INetworkingRequest) {
        self.requestBuilder = requestBuilder
    }
    
    public func send<ResponseType>(requestData: NetworkRequestData<ResponseType>,
                                   completion: @escaping(Result<ResponseType, Error>) -> Void) {
        let request = requestBuilder.buildUrlRequest(httpMethod: requestData.httpMethod, path: requestData.path)
        
        guard var urlRequest = request else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        let data = try? requestData.encode?()
        urlRequest.httpBody = data
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(.failure(NetworkError.serviceError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  let data = data else {
                
                completion(.failure(NetworkError.serviceError))
                return
            }
            
            switch response.statusCode {
            case 200...299:
                do {
                    let decodeResponse = try requestData.decode(data)
                    completion(.success(decodeResponse))
                } catch {
                    completion(.failure(NetworkError.parsingError))
                }
            default: completion(.failure(NetworkError.serviceError))
            }
        }.resume()
    }
}
