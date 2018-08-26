//
//  Person+CoreDataProperties.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/24.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var sexFlag: Int64

}
