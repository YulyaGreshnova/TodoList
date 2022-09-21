//
//  TodoItemMock.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 20.07.2022.
//

@testable import TodoList

class TodoItemMock {
    var todoItem = TodoItem(id: "123",
                            text: "foo",
                            deadline: nil,
                            importance: .important,
                            isCompleted: false,
                            networkId: 123)
}
