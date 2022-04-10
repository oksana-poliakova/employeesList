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
    
    private var models = [Employee]()
    
    private let context: NSManagedObjectContext = {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) }
        return context
    }()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
