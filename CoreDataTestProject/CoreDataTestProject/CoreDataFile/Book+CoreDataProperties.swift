//
//  Book+CoreDataProperties.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2019/1/18.
//  Copyright © 2019年 سچچچچچچ. All rights reserved.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double

}
