//
//  NetworkError.swift
//  TodoList
//
//  Created by Yulya Greshnova on 28.06.2022.
//

import Foundation

public enum TestError: Error {
    case serviceError
    case parsingError
    case invalidUrl
    case invalidJSONTypeError
}
