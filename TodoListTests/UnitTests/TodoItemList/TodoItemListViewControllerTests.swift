//
//  TodoItemListViewControllerTests.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 19.07.2022.
//

import XCTest
@testable import TodoList
@testable import Core

class TodoItemListViewControllerTests: XCTestCase {
    
    var presenter: TodoItemListPresenterMock!
    
    override func setUp() {
        super.setUp()
        presenter = TodoItemListPresenterMock()
    }
   
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewLoadedCalled() {
        // Arrange
        let viewController = TodoItemListViewController(presenter: presenter)
        
        // Act
        viewController.viewDidLoad()
        
        // Assert
        XCTAssertTrue(presenter.invokedViewLoaded)
    }
    
    func testFilterAllItemsCalled() {
        // Arrange
        let viewController = TodoItemListViewController(presenter: presenter)
        viewController.isFilteredItem = true
      
        // Act
        viewController.didShowCompletedItems()
        
        // Assert
        XCTAssertTrue(presenter.invokedFilterAllItems)
    }
    
    func testFilterCompletedItemsCalled() {
        // Arrange
        let viewController = TodoItemListViewController(presenter: presenter)

        // Act
        viewController.didShowCompletedItems()
        
        // Assert
        XCTAssertTrue(presenter.invokedFilterCompletedItems)
    }
}
