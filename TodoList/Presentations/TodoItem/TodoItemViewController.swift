//
//  ViewController.swift
//  TodoList
//
//  Created by Yulya Greshnova on 26.05.2022.
//

import UIKit

protocol TodoItemViewControllerDelegate: AnyObject {
    func didModelChanges(id: String, isNew: Bool)
}

protocol ITodoItemViewController: AnyObject {
    func showTodoItemViewModel(item: TodoItemViewModel, isNewItem: Bool)
    func saveModelChanges(id: String, isNew: Bool)
    func showErrorAlert()
}

final class TodoItemViewController: UIViewController {
    private let todoItemView: TodoItemView
    private lazy var saveButton: UIBarButtonItem = {
        let saveButton = UIBarButtonItem(title: "Сохранить",
                                         style: .done,
                                         target: self,
                                         action: #selector(save))
        saveButton.isEnabled = false
        return saveButton
        
    }()
    private let presenter: ITodoItemPresenter
    
    weak var delegate: TodoItemViewControllerDelegate?
    
    init(presenter: ITodoItemPresenter) {
        todoItemView = TodoItemView()
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Дело"
        setupBarButtons()
        setupView()
        presenter.viewLoaded()
    }
}

// MARK: - Internal methods
private extension TodoItemViewController {
     func setupBarButtons() {
        let cancelButton = UIBarButtonItem(title: "Отменить",
                                           style: .plain,
                                           target: self,
                                           action: #selector(close))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
     func setupView() {
        todoItemView.delegate = self
        todoItemView.backgroundColor = .secondarySystemBackground
        todoItemView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todoItemView)
        
        NSLayoutConstraint.activate([
            todoItemView.topAnchor.constraint(equalTo: view.topAnchor),
            todoItemView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            todoItemView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            todoItemView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Actions
extension TodoItemViewController {
    @objc func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func save() {
        presenter.saveItemChanges()
    }
}

// MARK: - TodoItemViewProtocol
extension TodoItemViewController: TodoItemViewDelegate {
    func didChangeText(text: String) {
        saveButton.isEnabled = true
        presenter.updateItemText(text: text)
    }
    
    func didSelectImportance(importanceIndex: Int) {
        let importance: TodoItem.Importance
        switch importanceIndex {
        case 0:
            importance = .ordinary
        case 1:
            importance = .unimportant
        case 2:
            importance = .important
        default:
            importance = .ordinary
        }
        saveButton.isEnabled = true
        presenter.updateItemImportance(itemImportance: importance)
    }
    
    func didSelectDeadline(date: Date) {
        saveButton.isEnabled = true
        presenter.updateItemDeadline(deadline: date)
    }
}

// MARK: - ITodoItemViewController
extension TodoItemViewController: ITodoItemViewController {
    func showTodoItemViewModel(item: TodoItemViewModel, isNewItem: Bool) {
        if !isNewItem {
            todoItemView.configureView(viewModel: item)
        }
    }
    
    func saveModelChanges(id: String, isNew: Bool) {
        delegate?.didModelChanges(id: id, isNew: isNew)
        navigationController?.popViewController(animated: true)
    }
    
    func showErrorAlert() {
        let cancelAction = UIAlertAction(title: "Ок",
                                         style: .cancel,
                                         handler: nil)
        showAlert(title: "Ошибка сети", message: nil, actions: [cancelAction])
    }
}
