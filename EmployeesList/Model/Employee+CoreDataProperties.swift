//
//  Employee+CoreDataProperties.swift
//  EmployeesList
//
//  Created by Oksana Poliakova on 10.04.2022.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var birthDate: Date?
    @NSManaged public var gender: String?
    @NSManaged public var salary: Double
    
    public var age: Int {
        return birthDate?.age ?? 0
    }

}

extension Employee: Identifiable {

}
