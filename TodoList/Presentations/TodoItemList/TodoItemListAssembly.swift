//
//  TodoItemListAssembly.swift
//  TodoList
//
//  Created by Yulya Greshnova on 12.06.2022.
//

import Foundation
import UIKit
import Core

 final class TodoItemListAssembly {
    func buildViewController(container: IDIContainer = DIContainer.shared) -> UIViewController {
        let requestBuilder = NetworkingRequest()
        let networkClient = NetworkClient(requestBuilder: requestBuilder)
        let networkingTaskService = TaskService(networkClient: networkClient)
        let presenter = TodoItemListPresenter(fileCache: container.resolve(type: IFileCache.self),
                                              networkingTaskService: networkingTaskService)
        let viewController = TodoItemListViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
