//
//  TodoItemAssembly.swift
//  TodoList
//
//  Created by Yulya Greshnova on 12.06.2022.
//

import Foundation
import UIKit
import Core

final class TodoItemAssembly {
    func buildViewController(typeItem: TypesItem,
                             container: IDIContainer = DIContainer.shared) -> UIViewController {
        let requestBuilder = NetworkingRequest()
        let networkClient = NetworkClient(requestBuilder: requestBuilder)
        let networkingTaskService = TaskService(networkClient: networkClient)
        let presenter = TodoItemPresenter(typeItem: typeItem,
                                          fileCache: container.resolve(type: IFileCache.self),
                                          networkingTaskService: networkingTaskService)
        let viewController = TodoItemViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
