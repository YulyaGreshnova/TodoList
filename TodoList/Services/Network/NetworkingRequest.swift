//
//  NetworkingRequest.swift
//  TodoList
//
//  Created by Yulya Greshnova on 28.06.2022.
//

import Foundation
import Core

class NetworkingRequest: INetworkingRequest {
    func buildUrlRequest(httpMethod: String, path: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.path = path
        components.host = "api.todoist.com"
        guard let url = components.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.allHTTPHeaderFields = [
            "Authorization": "Bearer 497893229f75c99c62049424a587e7345482c0be",
            "Content-Type": "application/json"
        ]
        return urlRequest
    }
}
