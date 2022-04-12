//
//  ViewController.swift
//  EmployeesList
//
//  Created by Oksana Poliakova on 10.04.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    // MARK: - Properties

    private lazy var tableView: UITableView = {
        /// Appearance
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        /// Cells
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        
        /// Delegate & DataSource
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private var models: [Employee] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setupUI()
        
        /// get items from coreData
        getAllEmployees()
    }
    
    private func getAllEmployees() {
        CoreDataManager().getAllEmployees { employees in
            self.models = employees
            self.tableView.reloadData()
        }
    }

    // MARK: - TableView
    
    func setupUI() {
        view.addSubview(tableView)
        /// Contstraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Set navigation item
    
    private func setNavigationItem() {
        navigationItem.title = "CoreData To Do List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Employee",
                                      message: "Enter a new employee",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Add gender"
        }
        alert.addTextField { textField in
            textField.placeholder = "Add name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Add salary"
        }

        alert.addAction(UIAlertAction(title: "Submit",
                                      style: .cancel,
                                      handler: { [weak self] _ in
            guard let genderField = alert.textFields?[0], let genderText = genderField.text, !genderText.isEmpty else { return }
            guard let nameField = alert.textFields?[1], let nameText = nameField.text, !nameText.isEmpty else { return }
            guard let salaryField = alert.textFields?[2], let salaryText = salaryField.text, !salaryText.isEmpty else { return }
            
            CoreDataManager().addEmployee(gender: genderText, name: nameText, salary: (salaryField as? NSString)?.doubleValue ?? 0) { isAdded in
                if isAdded { self?.getAllEmployees() }
            }
            
        }))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell else { return UITableViewCell() }
        cell.configureEmployee(model: models[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDelegate {
    
}
