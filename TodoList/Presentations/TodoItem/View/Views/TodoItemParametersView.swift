//
//  ImportanceAndDeadlinePickerView.swift
//  TodoList
//
//  Created by Yulya Greshnova on 01.06.2022.
//

import Foundation
import UIKit

protocol TodoItemParametersViewDelegate: AnyObject {
    func didSelectImportance(importanceIndex: Int)
    func didSelectDeadline(date: Date)
}

final class TodoItemParametersView: UIView {
    private let stackView: UIStackView
    private let importanceView: ImportanceView
    private let firstSeparatorView: LineView
    private let deadlineView: DeadlineView
    private let secondSeparatorView: LineView
    private let datePicker: UIDatePicker
    private let container: UIView
    weak var delegate: TodoItemParametersViewDelegate?
    
    init() {
        stackView = UIStackView()
        importanceView = ImportanceView()
        firstSeparatorView = LineView()
        deadlineView = DeadlineView()
        secondSeparatorView = LineView()
        datePicker = UIDatePicker()
        container = UIView()
        
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        importanceView.delegate = self
        stackView.addArrangedSubview(importanceView)
        
        stackView.addArrangedSubview(firstSeparatorView)
        
        deadlineView.delegate = self
        stackView.addArrangedSubview(deadlineView)
        
        secondSeparatorView.isHidden = true
        stackView.addArrangedSubview(secondSeparatorView)
        
        container.addSubview(datePicker)
        container.isHidden = true
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(chooseDeadline), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(container)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            datePicker.topAnchor.constraint(equalTo: container.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor).withPriority(.defaultHigh)
        ])
    }
    
    func configureView(viewModel: TodoItemViewModel) {
        deadlineView.configureView(date: viewModel.deadline)
        importanceView.configureView(importance: viewModel.importance)
    }
}

// MARK: - Actions
extension TodoItemParametersView {
    @objc func chooseDeadline() {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        if let date = Calendar.current.date(from: components) {
            delegate?.didSelectDeadline(date: date)
            deadlineView.updateDeadline(date: date)
        }
    }
}

// MARK: - ImportanceViewProtocol
extension TodoItemParametersView: ImportanceViewDelegate {
    func didSelectedImportance(importanceIndex: Int) {
        delegate?.didSelectImportance(importanceIndex: importanceIndex)
    }
}

// MARK: - DeadlineViewProtocol
extension TodoItemParametersView: DeadlineViewDelegate {
    func didToogleDeadlineSwitch(isOn: Bool) {
        if isOn {
            showDeadlinePicker()
        } else {
            hideDeadlinePicker()
        }
    }
}

// MARK: - Internal Methods
private extension TodoItemParametersView {
    func showDeadlinePicker() {
        secondSeparatorView.isHidden = false
        container.isHidden = false
    }
    
    func hideDeadlinePicker() {
        secondSeparatorView.isHidden = true
        container.isHidden = true
        deadlineView.switchOffSelectedDate()
    }
}
