//
//  DIContainer.swift
//  TodoList
//
//  Created by Yulya Greshnova on 20.07.2022.
//

import Foundation

protocol IDIContainer: AnyObject {
    func register<Component>(type: Component.Type, component: Any)
    func resolve<Component>(type: Component.Type) -> Component
}

final class DIContainer: IDIContainer {
    static let shared = DIContainer()
    private var components: [String: Any] = [:]
    
    private init() { }
    
    func register<Component>(type: Component.Type, component: Any) {
        components["\(type)"] = component
    }
    
    func resolve<Component>(type: Component.Type) -> Component {
        guard let component = components["\(type)"] as? Component else {
            fatalError("There is no component registered for this type")
            
        }
        return component
    }
}
