//
//  NetworkRequestData.swift
//  TodoList
//
//  Created by Yulya Greshnova on 30.06.2022.
//

import Foundation

public struct NetworkRequestData<ResponseType> {
    let httpMethod: String
    let path: String
    let encode: (() throws -> Data)?
    let decode: (Data) throws -> ResponseType
}

extension NetworkRequestData where ResponseType: Decodable {
    public init(path: String,
                httpMethod: String,
                encode: (() throws -> Data)?) {
        
        self.path = path
        self.httpMethod = httpMethod
        self.encode = encode
        self.decode = { data in
            let decoder = JSONDecoder()
            if #available(iOS 10.0, *) {
                decoder.dateDecodingStrategy = .iso8601
            } else {
                // Fallback on earlier versions
            }
            return try decoder.decode(ResponseType.self, from: data)
        }
    }
}

extension NetworkRequestData where ResponseType == Void {
    public init(path: String,
                httpMethod: String,
                encode: (() throws -> Data)?) {
        self.path = path
        self.httpMethod = httpMethod
        self.encode = encode
        self.decode = { _ in () }
    }
}
