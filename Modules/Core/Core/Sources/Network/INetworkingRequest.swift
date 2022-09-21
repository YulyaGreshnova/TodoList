//
//  INetworkingRequest.swift
//  TodoList
//
//  Created by Yulya Greshnova on 04.07.2022.
//

import Foundation

public protocol INetworkingRequest {
    func buildUrlRequest(httpMethod: String, path: String) -> URLRequest?
}
