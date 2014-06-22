//
//  Person+Create.swift
//  SWCoreData
//
//  Created by Michael Babiy on 6/21/14.
//  Copyright (c) 2014 Michael Babiy. All rights reserved.
//

import UIKit

extension Person {
    
    class func create(name: String, email: String, context: NSManagedObjectContext) -> Void
    {
        let person: Person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as Person
        person.name = name
        person.email = email
        
        var error: NSError?
        context.save(&error)
        error ? println("Error: \(error!.localizedDescription)") : println("Saved to Core Data.")
    }
    
    func description() -> String
    {
        return "Name: \(name)\nEmail: \(email)"
    }
}
