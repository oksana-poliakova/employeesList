//
//  MainTableViewCell.swift
//  EmployeesList
//
//  Created by Oksana Poliakova on 10.04.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    private let nameLabel = UILabel()
    private let idLabel = UILabel()
    private let birthDateLabel = UILabel()
    private let genderLabel = UILabel()
    private let salaryLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureEmployee(model: Employee) {
        nameLabel.text = model.name
        idLabel.text = "\(String(describing: model.id))"
        birthDateLabel.text = "\(String(describing: model.birthDate))"
        genderLabel.text = model.gender
        salaryLabel.text = "\(String(describing: model.gender))"
    }
    
    private func setupUI() {
        [nameLabel, idLabel, birthDateLabel, genderLabel, salaryLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = .black
            stackView.addArrangedSubview($0)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 6
        stackView.alignment = .fill
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
