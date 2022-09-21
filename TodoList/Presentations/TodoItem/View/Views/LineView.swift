//
//  LineView.swift
//  TodoList
//
//  Created by Yulya Greshnova on 01.06.2022.
//

import Foundation
import UIKit

final class LineView: UIView {
    private let lineView: UIView
    
    init() {
        lineView = UIView()
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        lineView.backgroundColor = .secondarySystemBackground
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
