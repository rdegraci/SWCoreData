//
//  HomeViewController.swift
//  SWCoreData
//
//  Created by Michael Babiy on 6/21/14.
//  Copyright (c) 2014 Michael Babiy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField
    @IBOutlet var emailTextField: UITextField
    
    var database: UIManagedDocument!
    var databaseReady = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if !database {
            let documentsDirectories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory = documentsDirectories[0] as String
            let databaseFileURL = NSURL.fileURLWithPath(documentsDirectory).URLByAppendingPathComponent(kDatabaseName)
            database = UIManagedDocument(fileURL: databaseFileURL)
            if database {
                useDocument()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func useDocument()
    {
        if !NSFileManager.defaultManager().fileExistsAtPath(database?.fileURL.path) {
            database.saveToURL(database.fileURL, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: {
                success in
                if success {
                    self.databaseReady = true
                }
            })
        } else {
            switch database.documentState {
            case UIDocumentState.Closed:
                database.openWithCompletionHandler( {
                    success in
                    if success {
                        self.databaseReady = success
                    }
                })
            case UIDocumentState.Normal:
                self.databaseReady = true
            default:
                self.databaseReady = false
            }
        }
    }
    
    @IBAction func save(sender: UIButton)
    {
        databaseReady ? Person.create(nameTextField.text, email: emailTextField.text, context: database.managedObjectContext) : println("Database is not ready.")
    }
    
    @IBAction func fetch(sender: UIButton)
    {
        var request = NSFetchRequest(entityName: kPersonEntityName)
        var error: NSError?
        let results: Array <Person> = database.managedObjectContext.executeFetchRequest(request, error: &error) as Array
        for item in results {
            let person = item as Person
            println(person)
        }
    }
}
