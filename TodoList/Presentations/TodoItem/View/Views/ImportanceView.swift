//
//  ImportanceView.swift
//  TodoList
//
//  Created by Yulya Greshnova on 01.06.2022.
//

import Foundation
import UIKit

protocol ImportanceViewDelegate: AnyObject {
    func didSelectedImportance(importanceIndex: Int)
}

final class ImportanceView: UIView {
    private let importanceLabel: UILabel
    private let importanceSegmentControl: UISegmentedControl
    weak var delegate: ImportanceViewDelegate?
    
    init() {
        importanceLabel = UILabel()
        importanceSegmentControl = UISegmentedControl(items: ["↓", "нет", "!!"])
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        importanceLabel.text = "Важность"
        importanceLabel.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        importanceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(importanceLabel)
        
        importanceSegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected)
        importanceSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        importanceSegmentControl.addTarget(self, action: #selector(selectSegmentControl), for: .valueChanged)
        addSubview(importanceSegmentControl)
        
        NSLayoutConstraint.activate([
            importanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            importanceLabel.trailingAnchor.constraint(equalTo: importanceSegmentControl.leadingAnchor),
            importanceLabel.centerYAnchor.constraint(equalTo: importanceSegmentControl.centerYAnchor),
            
            importanceSegmentControl.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            importanceSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            importanceSegmentControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    @objc func selectSegmentControl() {
        delegate?.didSelectedImportance(importanceIndex: importanceSegmentControl.selectedSegmentIndex)
    }
    
    func configureView(importance: TodoItem.Importance) {
        switch importance {
        case .important: importanceSegmentControl.selectedSegmentIndex = 2
        case .ordinary: importanceSegmentControl.selectedSegmentIndex = 1
        case .unimportant: importanceSegmentControl.selectedSegmentIndex = 0
        }
    }
}
