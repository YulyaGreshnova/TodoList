//
//  TaskServiceTests.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 17.07.2022.
//

import XCTest
@testable import TodoList
@testable import Core

class TaskServiceTests: XCTestCase {
    
    private var itemMock: TodoItem!

    override func setUp() {
        super.setUp()
        itemMock = TodoItem(id: "1",
                            text: "foo",
                            deadline: nil,
                            importance: .important,
                            isCompleted: false,
                            networkId: 123)
    }
    
    override func tearDown() {
        super.tearDown()
        itemMock = nil
    }
    
    func testAddNewTaskRequestSend() throws {
        // Arrange
        let networkClientMock = NetworkClientMock<TaskNetworkModel>()
        let taskService = TaskService(networkClient: networkClientMock)
        
        // Act
        taskService.addTask(todoItem: itemMock) { (_) in }
        
        // Assert
        XCTAssertTrue(networkClientMock.invokedSend)
        XCTAssertEqual(networkClientMock.invokedSendCount, 1)
        XCTAssertNotNil(networkClientMock.invokedSendParameters?.requestData)
        let requestData = try XCTUnwrap(networkClientMock.invokedSendParameters?.requestData)
        XCTAssertEqual(requestData.httpMethod, "POST")
        XCTAssertEqual(requestData.path, "/rest/v1/tasks")
    }
    
    func testGetTasksRequestSend() throws {
        // Arrange
        let networkClientMock = NetworkClientMock<[TaskNetworkModel]>()
        let taskService = TaskService(networkClient: networkClientMock)
        
        // Act
        taskService.getTasks { (_) in }
        
        // Assert
        XCTAssertTrue(networkClientMock.invokedSend)
        XCTAssertEqual(networkClientMock.invokedSendCount, 1)
        XCTAssertNotNil(networkClientMock.invokedSendParameters?.requestData)
        let requestData = try XCTUnwrap(networkClientMock.invokedSendParameters?.requestData)
        XCTAssertEqual(requestData.httpMethod, "GET")
        XCTAssertEqual(requestData.path, "/rest/v1/tasks")
    }
    
    func testDeleteTaskRequestSend() throws {
        // Arrange
        let networkClientMock = NetworkClientMock<Void>()
        let taskService = TaskService(networkClient: networkClientMock)
        let id = 123
        
        // Act
        taskService.deleteTask(id: id) { (_) in }
        
        // Assert
        XCTAssertTrue(networkClientMock.invokedSend)
        XCTAssertEqual(networkClientMock.invokedSendCount, 1)
        XCTAssertNotNil(networkClientMock.invokedSendParameters?.requestData)
        let requestData = try XCTUnwrap(networkClientMock.invokedSendParameters?.requestData)
        XCTAssertEqual(requestData.httpMethod, "DELETE")
        XCTAssertEqual(requestData.path, "/rest/v1/tasks/\(id)")
    }
    
    func testUpdateTaskRequestSend() throws {
        // Arrange
        let networkClientMock = NetworkClientMock<Void>()
        let taskService = TaskService(networkClient: networkClientMock)
        
        // Act
        taskService.updateTask(todoItem: itemMock) { (_) in }
        
        // Assert
        XCTAssertTrue(networkClientMock.invokedSend)
        XCTAssertEqual(networkClientMock.invokedSendCount, 1)
        XCTAssertNotNil(networkClientMock.invokedSendParameters?.requestData)
        let requestData = try XCTUnwrap(networkClientMock.invokedSendParameters?.requestData)
        XCTAssertEqual(requestData.httpMethod, "POST")
        XCTAssertEqual(requestData.path, "/rest/v1/tasks/\(itemMock.networkId!)")
    }
    
    func testCloseTaskRequestSend() throws {
        // Arrange
        let networkClientMock = NetworkClientMock<Void>()
        let taskService = TaskService(networkClient: networkClientMock)
        let id = 123
        
        // Act
        taskService.closeTask(id: id) { (_) in }
        
        // Assert
        XCTAssertTrue(networkClientMock.invokedSend)
        XCTAssertEqual(networkClientMock.invokedSendCount, 1)
        XCTAssertNotNil(networkClientMock.invokedSendParameters?.requestData)
        let requestData = try XCTUnwrap(networkClientMock.invokedSendParameters?.requestData)
        XCTAssertEqual(requestData.httpMethod, "POST")
        XCTAssertEqual(requestData.path, "/rest/v1/tasks/\(id)/close")
    }
    
    func testReopenTaskRequestSend() throws {
        // Arrange
        let networkClientMock = NetworkClientMock<Void>()
        let taskService = TaskService(networkClient: networkClientMock)
        let id = 123
        
        // Act
        taskService.reopenTask(id: id) { (_) in }
        
        // Assert
        XCTAssertTrue(networkClientMock.invokedSend)
        XCTAssertEqual(networkClientMock.invokedSendCount, 1)
        XCTAssertNotNil(networkClientMock.invokedSendParameters?.requestData)
        let requestData = try XCTUnwrap(networkClientMock.invokedSendParameters?.requestData)
        XCTAssertEqual(requestData.httpMethod, "POST")
        XCTAssertEqual(requestData.path, "/rest/v1/tasks/\(id)/reopen")
    }
}
