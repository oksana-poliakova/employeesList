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
    private let averageAgeLabel = UILabel()
    private let medianAgeLabel = UILabel()
    private let maxSalaryLabel = UILabel()
    private let genderRatioLabel = UILabel()
    private let stackView = UIStackView()
    private let headerForAnalyticsView = UILabel()
    private let headerForPublicProfileView = UILabel()

    // MARK: - TableView
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
    
    // MARK: - AnalyticsView
    private lazy var analyticsView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Public profile
    
    private lazy var publicProfileView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    // MARK: - Setup UI
    
    func setupUI() {
        view.backgroundColor = .systemGray6
        
        [tableView, analyticsView, stackView, headerForAnalyticsView, headerForPublicProfileView, publicProfileView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        /// StackView in the AnalyticsView
        [averageAgeLabel, medianAgeLabel, maxSalaryLabel, genderRatioLabel].forEach {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 14)
            stackView.addArrangedSubview($0)
        }
                
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        stackView.alignment = .fill
        
        headerForAnalyticsView.text = "Analytics"
        headerForPublicProfileView.text = "Public profile"
        
        [headerForAnalyticsView, headerForPublicProfileView].forEach {
            $0.font = UIFont.boldSystemFont(ofSize: 16)
        }

        averageAgeLabel.text = "Average age is: "
        medianAgeLabel.text = "Median age is: "
        maxSalaryLabel.text = "Max salary is: "
        genderRatioLabel.text = "Male vs Female workers ratio: "
        
        /// Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 400),
            
            analyticsView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            analyticsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            analyticsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: analyticsView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: analyticsView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: analyticsView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: analyticsView.bottomAnchor, constant: -16),
            
            headerForAnalyticsView.topAnchor.constraint(equalTo: analyticsView.topAnchor, constant: -36),
            headerForAnalyticsView.leadingAnchor.constraint(equalTo: analyticsView.leadingAnchor, constant: 16),
            headerForAnalyticsView.trailingAnchor.constraint(equalTo: analyticsView.trailingAnchor, constant: -16),
            
            publicProfileView.topAnchor.constraint(equalTo: analyticsView.bottomAnchor, constant: 50),
            publicProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            publicProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            publicProfileView.heightAnchor.constraint(equalToConstant: 200),
            
            headerForPublicProfileView.topAnchor.constraint(equalTo: publicProfileView.topAnchor, constant: -36),
            headerForPublicProfileView.leadingAnchor.constraint(equalTo: publicProfileView.leadingAnchor, constant: 16),
            headerForPublicProfileView.trailingAnchor.constraint(equalTo: publicProfileView.trailingAnchor, constant: -16)
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
            
            CoreDataManager().addEmployee(gender: genderText, name: nameText, salary: (salaryText as NSString).doubleValue) { isAdded in
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        let label = UILabel()
        label.text = "Employees List"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        sectionView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 10)
        ])
        return sectionView
    }
}
