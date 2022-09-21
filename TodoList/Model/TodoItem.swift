//
//  TodoItem.swift
//  TodoList
//
//  Created by Yulya Greshnova on 26.05.2022.
//

import Foundation

struct TodoItem {
    enum Importance: String, Codable {
        case unimportant
        case ordinary
        case important
    }

    let id: String
    var text: String
    var deadline: Date?
    var importance: Importance
    var isCompleted: Bool
    var networkId: Int?
}

extension TodoItem: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case deadline
        case importance
        case isCompleted
        case networkId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        deadline = try container.decodeIfPresent(Date.self, forKey: .deadline)
        importance = (try? container.decode(Importance.self, forKey: .importance)) ?? Importance.ordinary
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        networkId = try container.decodeIfPresent(Int.self, forKey: .networkId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(deadline, forKey: .deadline)
        try container.encode(isCompleted, forKey: .isCompleted)
        if importance != .ordinary {
            try container.encode(importance, forKey: .importance)
        }
        try container.encodeIfPresent(networkId, forKey: .networkId)
    }
}

extension TodoItem: Equatable {
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
