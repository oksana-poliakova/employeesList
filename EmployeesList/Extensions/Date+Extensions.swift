//
//  Date+Extensions.swift
//  EmployeesList
//
//  Created by Oksana Poliakova on 13.04.2022.
//

import Foundation

extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0 }
}
