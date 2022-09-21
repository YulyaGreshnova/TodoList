//
//  TodoItemTableViewCell.swift
//  TodoList
//
//  Created by Yulya Greshnova on 02.06.2022.
//

import Foundation
import UIKit

protocol TodoItemTableViewCellDelegate: AnyObject {
    func didCheckBoxToggle(sender: TodoItemTableViewCell)
}

final class TodoItemTableViewCell: UITableViewCell {
    private let textItemLabel: UILabel
    private let dateItemLabel: UILabel
    private let importanceLabel: UILabel
    private let checkmarkButton: UIButton
    
    weak var delegate: TodoItemTableViewCellDelegate?
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter
    }()
    
    static let cellIdentifier = "TodoItemTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        textItemLabel = UILabel()
        dateItemLabel = UILabel()
        checkmarkButton = UIButton()
        importanceLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        importanceLabel.isHidden = true
        importanceLabel.text = "!!!"
        importanceLabel.setContentHuggingPriority(.defaultHigh - 1, for: .horizontal)
        importanceLabel.textColor = .red
        importanceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(importanceLabel)
        
        textItemLabel.numberOfLines = 0
        textItemLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textItemLabel)
        
        dateItemLabel.isHidden = true
        dateItemLabel.textColor = .systemGray
        dateItemLabel.font = .systemFont(ofSize: 12)
        dateItemLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateItemLabel)
        
        checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkmarkButton.tintColor = .systemGreen
        checkmarkButton.addTarget(self, action: #selector(checkBoxToggled), for: .touchUpInside)
        checkmarkButton.setContentHuggingPriority(.defaultHigh - 1, for: .horizontal)
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkmarkButton)
        
        NSLayoutConstraint.activate([
            importanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            importanceLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor),
            importanceLabel.bottomAnchor.constraint(equalTo: dateItemLabel.topAnchor),
            
            textItemLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textItemLabel.leadingAnchor.constraint(equalTo: importanceLabel.trailingAnchor, constant: 4),
            textItemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            dateItemLabel.topAnchor.constraint(equalTo: textItemLabel.bottomAnchor, constant: 4),
            dateItemLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor),
            dateItemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateItemLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).withPriority(.defaultHigh + 1),
            
            checkmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            checkmarkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func strikeText(string: String?, strike: Bool) -> NSAttributedString? {
        guard let text = string else { return nil }
        if strike {
           return NSAttributedString(
                string: text,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
        } else {
            return NSAttributedString(
                string: text,
                attributes: [.strikethroughStyle: 0]
            )
        }
    }
    
    @objc func checkBoxToggled() {
        checkmarkButton.isSelected.toggle()
        delegate?.didCheckBoxToggle(sender: self)
    }
    
    func configureWith(itemModel: TodoItemListViewModel) {
        textItemLabel.text = itemModel.text

        if let deadlineTime = itemModel.deadline {
            dateItemLabel.isHidden = false
            dateItemLabel.text = "🗓 \(dateFormatter.string(from: deadlineTime))"
        } else {
            dateItemLabel.isHidden = true
            dateItemLabel.text = nil
        }

        if itemModel.importance == .important {
            importanceLabel.isHidden = false
        } else {
            importanceLabel.isHidden = true
        }
        
        if itemModel.isCompleted {
            checkmarkButton.isSelected = true
        } else {
            checkmarkButton.isSelected = false
        }
        
        if checkmarkButton.isSelected {
            textItemLabel.textColor = .gray
            textItemLabel.attributedText = strikeText(string: textItemLabel.text, strike: true)
        } else {
            textItemLabel.textColor = .black
            textItemLabel.attributedText = strikeText(string: textItemLabel.text, strike: false)
        }
    }
}
