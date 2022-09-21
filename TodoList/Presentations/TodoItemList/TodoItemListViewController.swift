//
//  TodoItemListViewController.swift
//  TodoList
//
//  Created by Yulya Greshnova on 02.06.2022.
//

import Foundation
import UIKit

protocol ITodoItemListViewController: AnyObject {
    var isFilteredItem: Bool { get set }
    func showTodoItemsViewModel(viewModels: [TodoItemListViewModel])
    func updateTodoItem(viewModel: TodoItemListViewModel, index: Int)
    func removeItem(index: Int)
    func updateFilteredCompletedItemCount()
    func showErrorAlert()
    func showSuccessSynchronisationAlert()
}

final class TodoItemListViewController: UIViewController {
    private let tableView: UITableView
    private let addNewItemButton: UIButton
    private let filteredView: TodoItemFilteredView
    private let presenter: ITodoItemListPresenter
    private var todoItemsListViewModel: [TodoItemListViewModel]
    var isFilteredItem = false
    private var isComletedItem = false
    
    init(presenter: ITodoItemListPresenter) {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        addNewItemButton = UIButton()
        self.presenter = presenter
        filteredView = TodoItemFilteredView()
        todoItemsListViewModel = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Мои дела"
        setupTableView()
        setupNavigationBar()
        setupView()
        presenter.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - SetupView
private extension TodoItemListViewController {
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoItemTableViewCell.self,
                           forCellReuseIdentifier: TodoItemTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
     func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
      }
    
     func setupView() {
        filteredView.delegate = self
        filteredView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filteredView)
        
        addNewItemButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addNewItemButton.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        addNewItemButton.contentVerticalAlignment = .fill
        addNewItemButton.contentHorizontalAlignment = .fill
        addNewItemButton.layer.shadowRadius = 3
        addNewItemButton.layer.shadowOpacity = 0.8
        addNewItemButton.layer.shadowOffset = CGSize(width: 2, height: 5)
        addNewItemButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addNewItemButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNewItemButton)
        
        NSLayoutConstraint.activate([
            filteredView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filteredView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filteredView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10),
            filteredView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addNewItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewItemButton.widthAnchor.constraint(equalToConstant: 50),
            addNewItemButton.heightAnchor.constraint(equalTo: addNewItemButton.widthAnchor),
            addNewItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
}

// MARK: - Actions
extension TodoItemListViewController {
    @objc func addNewItem() {
        guard let todoItemVC = TodoItemAssembly().buildViewController(typeItem: .newItem) as? TodoItemViewController else { return }
        todoItemVC.delegate = self
        navigationController?.pushViewController(todoItemVC, animated: true)
    }
}

// MARK: - TodoItemTableViewCellDelegate
extension TodoItemListViewController: TodoItemTableViewCellDelegate {
    func didCheckBoxToggle(sender: TodoItemTableViewCell) {
        isComletedItem = !isComletedItem
        guard let selectedIndexPath = tableView.indexPath(for: sender) else { return }
        let id = todoItemsListViewModel[selectedIndexPath.row].id
        presenter.toggleIsCompletedItem(index: selectedIndexPath.row,
                                        id: id,
                                        isFiltred: isFilteredItem,
                                        isCompletedItem: isComletedItem)
        
        filteredView.completedItemCount = presenter.getItems(items: .completed).count
    }
}

// MARK: - UITableViewDataSource
extension TodoItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItemsListViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemTableViewCell.cellIdentifier,
                                                       for: indexPath) as? TodoItemTableViewCell else {
            return UITableViewCell()
        }
        
        let item = todoItemsListViewModel[indexPath.row]
        cell.delegate = self
        cell.accessoryType = .disclosureIndicator
        cell.configureWith(itemModel: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodoItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let id = todoItemsListViewModel[indexPath.row].id
        guard let todoItemViewController = TodoItemAssembly().buildViewController(typeItem: .item(id: id)) as? TodoItemViewController else { return }
        todoItemViewController.delegate = self
        navigationController?.pushViewController(todoItemViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let info = UIContextualAction(style: .normal,
                                      title: "") { (_, _, _) in
            print("info")
        }
        
        info.image = UIImage(systemName: "info.circle")
        
        let delete = UIContextualAction(style: .destructive,
                                        title: "") {[weak self] (_, _, _) in
            guard let self = self else { return }
            let id = self.todoItemsListViewModel[indexPath.row].id
            self.presenter.deleteItem(id: id, index: indexPath.row)
        }
        
        delete.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, info])
        return configuration
    }
}

// MARK: - TodoItemFilteredViewProtocol
extension TodoItemListViewController: TodoItemFilteredViewDelegate {
    func didShowCompletedItems() {
        isFilteredItem.toggle()
        if isFilteredItem {
            presenter.filterCompletedItems()
        } else {
            presenter.filterAllItems()
        }
    }
}

// MARK: - ITodoItemListViewController
extension TodoItemListViewController: ITodoItemListViewController {
    func showTodoItemsViewModel(viewModels: [TodoItemListViewModel]) {
        todoItemsListViewModel = viewModels
        tableView.reloadData()
    }
    
    func updateTodoItem(viewModel: TodoItemListViewModel, index: Int) {
        todoItemsListViewModel[index] = viewModel
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func removeItem(index: Int) {
        todoItemsListViewModel.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func showSuccessSynchronisationAlert() {
//        let okAction = UIAlertAction(title: "Ок",
//                                         style: .cancel,
//                                         handler: nil)
//        showAlert(title: "Синхронизация с сетью прошла успешна", message: nil, actions: [okAction])
    }
    
    func showErrorAlert() {
        let cancelAction = UIAlertAction(title: "Ок",
                                         style: .cancel,
                                         handler: nil)
        showAlert(title: "Ошибка сети", message: nil, actions: [cancelAction])
    }
    
    func updateFilteredCompletedItemCount() {
        filteredView.completedItemCount = presenter.getItems(items: .completed).count
    }
}

// MARK: - TodoItemViewControllerDelegate
extension TodoItemListViewController: TodoItemViewControllerDelegate {
    func didModelChanges(id: String, isNew: Bool) {
        guard let viewModel = presenter.getItemWith(id: id) else { return }
        if isNew {
            todoItemsListViewModel.append(viewModel)
        } else {
            guard let index = todoItemsListViewModel.firstIndex(of: viewModel) else { return }
            todoItemsListViewModel[index] = viewModel
        }
    }
}
