//
//  TodoItemView.swift
//  TodoList
//
//  Created by Yulya Greshnova on 01.06.2022.
//

import Foundation
import UIKit

protocol TodoItemViewDelegate: AnyObject {
    func didChangeText(text: String)
    func didSelectImportance(importanceIndex: Int)
    func didSelectDeadline(date: Date)
}

final class TodoItemView: UIView {
    private let inputTextView: UITextView
    private let scrollView: UIScrollView
    private let deleteButton: UIButton
    private let todoItemParametersView: TodoItemParametersView
    
    weak var delegate: TodoItemViewDelegate?
    
    init() {
        inputTextView = UITextView()
        scrollView = UIScrollView()
        deleteButton = UIButton()
        todoItemParametersView = TodoItemParametersView()
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        inputTextView.text = "Что надо сделать?"
        inputTextView.textColor = .systemGray
        inputTextView.delegate = self
        inputTextView.layer.cornerRadius = 10
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(inputTextView)
        
        todoItemParametersView.backgroundColor = .white
        todoItemParametersView.layer.cornerRadius = 10
        todoItemParametersView.clipsToBounds = true
        todoItemParametersView.delegate = self
        todoItemParametersView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(todoItemParametersView)
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.backgroundColor = .white
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.layer.cornerRadius = 10
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            inputTextView.heightAnchor.constraint(equalToConstant: 100),
            inputTextView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10),
            inputTextView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            todoItemParametersView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 10),
            todoItemParametersView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            todoItemParametersView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: todoItemParametersView.bottomAnchor, constant: 10),
            deleteButton.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureView(viewModel: TodoItemViewModel) {
        configureText(text: viewModel.text)
        todoItemParametersView.configureView(viewModel: viewModel)
    }
}

// MARK: - IntarnalMethods
private extension TodoItemView {
    func configureText(text: String?) {
        inputTextView.text = text
        inputTextView.textColor = .black
        inputTextView.font = .systemFont(ofSize: 20)
    }
}

// MARK: - UITextViewDelegate
extension TodoItemView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        configureText(text: textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        delegate?.didChangeText(text: text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.first?.isNewline == true {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - TodoItemParamentersViewProtocol
extension TodoItemView: TodoItemParametersViewDelegate {
    func didSelectDeadline(date: Date) {
        delegate?.didSelectDeadline(date: date)
    }
    
    func didSelectImportance(importanceIndex: Int) {
        delegate?.didSelectImportance(importanceIndex: importanceIndex)
    }
}
