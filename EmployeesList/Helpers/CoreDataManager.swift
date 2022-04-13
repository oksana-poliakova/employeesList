//
//  CoreDataManager.swift
//  EmployeesList
//
//  Created by Oksana Poliakova on 12.04.2022.
//

import UIKit
import CoreData

// MARK: - CoreData

class CoreDataManager {

    private let context: NSManagedObjectContext = {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) }
        return context
    }()

    public func getAllEmployees(completion: @escaping([Employee]) -> Void) {
        do {
            completion(try context.fetch(Employee.fetchRequest()))
        } catch { }
    }

    public func addEmployee(gender: String, name: String, salary: Double, date: String, completion: ((Bool) -> ())? = nil) {
        let newEmployee = Employee(context: context)
        newEmployee.id = Int64()
        newEmployee.gender = gender
        newEmployee.name = name
        newEmployee.salary = salary
        
        let isoDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: isoDate) else { return }
        
        newEmployee.birthDate = date
        
        do {
            try context.save()
            completion?(true)
        } catch {
            completion?(false)
        }
    }

    public func deleteEmployee(item: Employee) {
        context.delete(item)
        
        do {
            try context.save()
        } catch { }
    }

    public func updateEmployee(item: Employee, newName: String, newSalary: Double) {
        item.name = newName
        item.salary = newSalary
        
        do {
            try context.save()
        } catch { }
    }
    
    public func createDefaultEmployees() {
        getAllEmployees { [weak self] employee in
            if employee.isEmpty {
                let tupleArray: [(gender: String,
                                  name: String,
                                  salary: Double,
                                  date: String)] = [(gender: "Male", name: "Aleksandr Poliakov", salary: 10000, date: "2002-02-02"),
                                                      (gender: "Female", name: "Oksana Poliakova", salary: 5000, date: "1998-02-02"),
                                                      (gender: "Female", name: "John Dou", salary: 8000, date: "1995-02-02")]
                
                tupleArray.forEach { tuple in
                    self?.addEmployee(gender: tuple.gender, name: tuple.name, salary: tuple.salary, date: tuple.date, completion: nil)
                }
            }
        }
    }
}
