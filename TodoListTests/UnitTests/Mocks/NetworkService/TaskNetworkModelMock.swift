//
//  TaskNetworkModelMock.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 18.07.2022.
//

@testable import TodoList
@testable import Core

class TaskNetworkModelMock {
    var model = TaskNetworkModel(content: "foo",
                                 id: 123,
                                 priority: 1,
                                 completed: false,
                                 deadline: nil)
}
