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

    public func addEmployee(gender: String, name: String, salary: Double, completion: @escaping((Bool) -> ())) {
        let newEmployee = Employee(context: context)
        newEmployee.id = Int64()
        newEmployee.gender = gender
        newEmployee.name = name
        newEmployee.birthDate = Date()
        newEmployee.salary = salary
        
        do {
            try context.save()
            completion(true)
        } catch {
            completion(false)
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
}
