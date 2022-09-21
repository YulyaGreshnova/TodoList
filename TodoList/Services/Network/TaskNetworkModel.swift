//
//  TaskNetworkModel.swift
//  TodoList
//
//  Created by Yulya Greshnova on 28.06.2022.
//

import Foundation

struct TaskNetworkModel {
    let content: String
    let id: Int?
    let priority: Int
    let completed: Bool
    var dueDate: Date?
    
    init(content: String, id: Int?, priority: Int, completed: Bool, deadline: Date?) {
        self.content = content
        self.id = id
        self.priority = priority
        self.completed = completed
        self.dueDate = deadline
    }
   
    init?(todoItem: TodoItem) {
        content = todoItem.text
        completed = todoItem.isCompleted
        
        switch todoItem.importance {
        case .important:
            priority = 1
        case .ordinary:
            priority = 2
        case .unimportant:
            priority = 3
        }
        dueDate = todoItem.deadline
        id = todoItem.networkId
    }
    
    enum DecodingKeys: String, CodingKey {
        case due
        case completed
        case priority
        case id
        case content
    }

    enum DueDecodingKeys: String, CodingKey {
        case dueDate = "datetime"
    }
    
    enum EncodingKeys: String, CodingKey {
        case dueDate
        case completed
        case priority
        case content
    }
}

extension TaskNetworkModel: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        completed = try container.decode(Bool.self, forKey: .completed)
        priority = try container.decode(Int.self, forKey: .priority)
        id = try container.decode(Int.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)

        if container.contains(.due) {
            let dueContainer = try container.nestedContainer(keyedBy: DueDecodingKeys.self, forKey: .due)
            dueDate = try dueContainer.decode(Date.self, forKey: .dueDate)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(completed, forKey: .completed)
        try container.encode(priority, forKey: .priority)
        try container.encode(content, forKey: .content)
    }
}
