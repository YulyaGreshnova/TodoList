//
//  TodoItemViewList.swift
//  TodoList
//
//  Created by Yulya Greshnova on 03.06.2022.
//

import Foundation
import UIKit

protocol TodoItemFilteredViewDelegate: AnyObject {
    func didShowCompletedItems()
}

final class TodoItemFilteredView: UIView {
    private let completedItemsButton: UIButton
    private var completedItemsCountLabel: UILabel
    weak var delegate: TodoItemFilteredViewDelegate?
    
    var completedItemCount: Int = 0 {
        didSet {
            completedItemsCountLabel.text = "Выполнено - \(completedItemCount)"
        }
    }
    
    private var isSelectedCompletedButton: Bool = false {
        didSet {
            if isSelectedCompletedButton {
                completedItemsButton.setTitle("Скрыть", for: .normal)
            } else {
                completedItemsButton.setTitle("Показать", for: .normal)
            }
        }
    }
    
    init() {
        completedItemsButton = UIButton(type: .system)
        completedItemsCountLabel = UILabel()
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        completedItemsButton.setTitle("Показать", for: .normal)
        completedItemsButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        completedItemsButton.addTarget(self, action: #selector(showCompletedItem), for: .touchUpInside)
        completedItemsButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(completedItemsButton)
        
        completedItemsCountLabel.text = "Выполнено - \(completedItemCount)" 
        completedItemsCountLabel.font = .italicSystemFont(ofSize: 15)
        completedItemsCountLabel.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        completedItemsCountLabel.textColor = .systemGray
        completedItemsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(completedItemsCountLabel)
        
        NSLayoutConstraint.activate([
            completedItemsCountLabel.topAnchor.constraint(equalTo: topAnchor),
            completedItemsCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            completedItemsCountLabel.trailingAnchor.constraint(equalTo: completedItemsButton.leadingAnchor),
            completedItemsCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            completedItemsButton.topAnchor.constraint(equalTo: topAnchor),
            completedItemsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            completedItemsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
        
    @objc func showCompletedItem() {
        delegate?.didShowCompletedItems()
        isSelectedCompletedButton.toggle()
    }
}
