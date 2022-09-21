//
//  TodoItemListPresenterTest.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 18.07.2022.
//

import XCTest
@testable import TodoList
@testable import Core

class TodoItemListPresenterTest: XCTestCase {
    
    var fileCache: FileCacheMock!
    var networkServiceMock: TaskServiceMock!
    var viewControllerMock: TodoItemListViewControllerMock!
    var id: String!
    var index: Int!

    override func setUp() {
        super.setUp()
        
        fileCache = FileCacheMock()
        viewControllerMock = TodoItemListViewControllerMock()
        networkServiceMock = TaskServiceMock(networkModels: [TaskNetworkModelMock().model])
        id = TodoItemMock().todoItem.id
        index = 0
    }
    
    override func tearDown() {
        super.tearDown()
        fileCache = nil
        networkServiceMock = nil
        viewControllerMock = nil
        id = nil
        index = nil
    }
    
    func testLoadItemFromNetwork() {
        // Arrange
        let presenter = TodoItemListPresenter(fileCache: fileCache, networkingTaskService: networkServiceMock)

        // Act
        presenter.viewLoaded()

        // Assert
        XCTAssertTrue(networkServiceMock.invokedGetTasks)
        XCTAssertEqual(networkServiceMock.invokedGetTasksCount, 1)
    }
    
    func testDeleteItemFromNetwork() {
        // Arrange
        let presenter = TodoItemListPresenter(fileCache: fileCache, networkingTaskService: networkServiceMock)

        // Act
        presenter.deleteItem(id: id, index: index)

        // Assert
        XCTAssertTrue(networkServiceMock.invokedDeleteTask)
        XCTAssertEqual(networkServiceMock.invokedDeleteTaskCount, 1)
    }
    
    func testCloseTaskFromNetwork() {
        // Arrange
        let presenter = TodoItemListPresenter(fileCache: fileCache, networkingTaskService: networkServiceMock)

        // Act
        presenter.toggleIsCompletedItem(index: index, id: id, isFiltred: true, isCompletedItem: true)

        // Assert
        XCTAssertTrue(networkServiceMock.invokedCloseTask)
        XCTAssertEqual(networkServiceMock.invokedCloseTaskCount, 1)
    }
    
    func testReopenTaskFromNetwork() {
        // Arrange
        let presenter = TodoItemListPresenter(fileCache: fileCache, networkingTaskService: networkServiceMock)

        // Act
        presenter.toggleIsCompletedItem(index: index, id: id, isFiltred: true, isCompletedItem: false)

        // Assert
        XCTAssertTrue(networkServiceMock.invokedReopenTask)
        XCTAssertEqual(networkServiceMock.invokedReopenTaskCount, 1)
    }
    
    func testShowTodoItemsViewModelCalled() {
        // Arrange
        let presenter = TodoItemListPresenter(fileCache: fileCache, networkingTaskService: networkServiceMock)
        presenter.viewController = viewControllerMock
        
        // Act
        presenter.filterAllItems()
        
        // Assert
        XCTAssertTrue(viewControllerMock.invokedShowTodoItemsViewModel)
        XCTAssertEqual(viewControllerMock.invokedShowTodoItemsViewModelCount, 1)
    }
    
    func testDeleteItemViewControllerCalled() {
        // Arrange
        let presenter = TodoItemListPresenter(fileCache: fileCache, networkingTaskService: networkServiceMock)
        presenter.viewController = viewControllerMock
        
        // Act
        presenter.deleteItem(id: id, index: index)
        
        // Assert
        XCTAssertTrue(viewControllerMock.invokedRemoveItem)
        XCTAssertEqual(viewControllerMock.invokedRemoveItemCount, 1)
    }
    
    func testToggleIsCompletedItemUpdateItemCalled() {
        // Arrange
        let presenter = TodoItemListPresenter(fileCache: fileCache, networkingTaskService: networkServiceMock)
        presenter.viewController = viewControllerMock

        // Act
        presenter.toggleIsCompletedItem(index: index, id: id, isFiltred: false, isCompletedItem: false)

        // Assert
        XCTAssertTrue(viewControllerMock.invokedUpdateTodoItem)
        XCTAssertEqual(viewControllerMock.invokedUpdateTodoItemCount, 1)
    }
    
    func testToggleIsCompletedItemDeleteItemCalled() {
        // Arrange
        let presenter = TodoItemListPresenter(fileCache: fileCache, networkingTaskService: networkServiceMock)
        presenter.viewController = viewControllerMock

        // Act
        presenter.toggleIsCompletedItem(index: index, id: id, isFiltred: true, isCompletedItem: false)

        // Assert
        XCTAssertTrue(viewControllerMock.invokedRemoveItem)
        XCTAssertEqual(viewControllerMock.invokedRemoveItemCount, 1)
    }
}
