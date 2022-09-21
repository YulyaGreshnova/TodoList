//
//  TodoItemViewControllerTests.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 20.07.2022.
//

import XCTest
@testable import TodoList
@testable import Core

class TodoItemViewControllerTests: XCTestCase {
    var fileCache: FileCacheMock!
    var networkServiceMock: TaskServiceMock!
    var presenter: TodoItemPresenterMock!
    
    override func setUp() {
        super.setUp()
        fileCache = FileCacheMock()
        networkServiceMock = TaskServiceMock(networkModels: [TaskNetworkModelMock().model])
        presenter = TodoItemPresenterMock()
    }
    
    override func tearDown() {
        super.tearDown()
        fileCache = nil
        networkServiceMock = nil
        presenter = nil
    }
    
    func testViewLoadedCalled() {
        // Arrange
        let viewController = TodoItemViewController(presenter: presenter)

        // Act
        viewController.viewDidLoad()
        
        // Assert
        XCTAssertTrue(presenter.invokedViewLoaded)
    }
    
    func testSaveCalled() {
        // Arrange
        let viewController = TodoItemViewController(presenter: presenter)

        // Act
        viewController.save()
        
        // Assert
        XCTAssertTrue(presenter.invokedSaveItemChanges)
    }
    
    func testUpdateItemImportanceCalled() {
        // Arrange
        let viewController = TodoItemViewController(presenter: presenter)

        // Act
        viewController.didSelectImportance(importanceIndex: 1)
        
        // Assert
        XCTAssertTrue(presenter.invokedUpdateItemImportance)
    }
    
    func testUpdateItemDeadlineCalled() {
        // Arrange
        let viewController = TodoItemViewController(presenter: presenter)

        // Act
        viewController.didSelectDeadline(date: Date())
        
        // Assert
        XCTAssertTrue(presenter.invokedUpdateItemDeadline)
    }
}
