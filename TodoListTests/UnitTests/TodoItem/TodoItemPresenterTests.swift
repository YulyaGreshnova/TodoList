//
//  TodoItemPresenterTests.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 20.07.2022.
//

import XCTest
@testable import TodoList
@testable import Core

class TodoItemPresenterTests: XCTestCase {
    var fileCache: FileCacheMock!
    var networkServiceMock: TaskServiceMock!
    var viewController: TodoItemViewControllerMock!
    
    override func setUp() {
        super.setUp()
        fileCache = FileCacheMock()
        networkServiceMock = TaskServiceMock(networkModels: [TaskNetworkModelMock().model])
        viewController = TodoItemViewControllerMock()
    }
    
    override func tearDown() {
        super.tearDown()
        fileCache = nil
        networkServiceMock = nil
        viewController = nil
    }
    
    func testShowTodoItemViewModelCalled() {
        // Arrange
        let presenter = TodoItemPresenter(typeItem: .newItem,
                                          fileCache: fileCache,
                                          networkingTaskService: networkServiceMock)
        presenter.viewController = viewController

        // Act
        presenter.viewLoaded()
        
        // Assert
        XCTAssertTrue(viewController.invokedShowTodoItemViewModel)
    }
    
    func testAddNewTaskFromNetwork() {
        // Arrange
        let presenter = TodoItemPresenter(typeItem: .newItem,
                                          fileCache: fileCache,
                                          networkingTaskService: networkServiceMock)

        // Act
        presenter.saveItemChanges()
        
        // Assert
        XCTAssertTrue(networkServiceMock.invokedAddTask)
    }
    
    func testUpdateTaskFromNetwork() {
        // Arrange
        let presenter = TodoItemPresenter(typeItem: .item(id: TodoItemMock().todoItem.id),
                                          fileCache: fileCache,
                                          networkingTaskService: networkServiceMock)

        // Act
        presenter.saveItemChanges()
        
        // Assert
        XCTAssertTrue(networkServiceMock.invokedUpdateTask)
    }
    
}
