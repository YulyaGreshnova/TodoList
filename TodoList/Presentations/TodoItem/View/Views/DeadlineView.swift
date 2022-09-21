//
//  DeadlineView.swift
//  TodoList
//
//  Created by Yulya Greshnova on 01.06.2022.
//

import Foundation
import UIKit

protocol DeadlineViewDelegate: AnyObject {
    func didToogleDeadlineSwitch(isOn: Bool)
}

final class DeadlineView: UIView {
    private let deadlineLabel: UILabel
    private let deadlinePickerSwitch: UISwitch
    private let dateLabel: UILabel
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    weak var delegate: DeadlineViewDelegate?
    
    init() {
        deadlineLabel = UILabel()
        deadlinePickerSwitch = UISwitch()
        dateLabel = UILabel()
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        deadlineLabel.text = "Сделать до"
        deadlineLabel.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deadlineLabel)
        
        deadlinePickerSwitch.addTarget(self, action: #selector(toogleDeadlineSwitch), for: .valueChanged)
        deadlinePickerSwitch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deadlinePickerSwitch)
        
        dateLabel.textColor = .systemBlue
        dateLabel.isHidden = true
        dateLabel.font = .boldSystemFont(ofSize: 10)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            deadlineLabel.topAnchor.constraint(equalTo: topAnchor),
            deadlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            deadlineLabel.trailingAnchor.constraint(equalTo: deadlinePickerSwitch.leadingAnchor),
            deadlineLabel.centerYAnchor.constraint(equalTo: deadlinePickerSwitch.centerYAnchor),
                                            
            deadlinePickerSwitch.topAnchor.constraint(equalTo: topAnchor),
            deadlinePickerSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            deadlinePickerSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc func toogleDeadlineSwitch() {
        delegate?.didToogleDeadlineSwitch(isOn: deadlinePickerSwitch.isOn)
    }
    
    func updateDeadline(date: Date) {
        let userDeadline = dateFormatter.string(from: date)
        dateLabel.isHidden = false
        dateLabel.text = userDeadline
    }
    
    func switchOffSelectedDate() {
        dateLabel.isHidden = true
    }
    
    func configureView(date: Date?) {
        if let date = date {
            updateDeadline(date: date)
        }
    }
}
