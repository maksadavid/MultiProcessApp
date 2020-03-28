//
//  ViewController.swift
//  MultiProcessApp
//
//  Created by David Maksa on 19.03.20.
//  Copyright © 2020 David Maksa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    
    let databaseManager = DatabaseManager()
    var mappings: YapDatabaseViewMappings? = nil
    var connection: YapDatabaseConnection? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        databaseManager.setupDatabase()
        databaseManager.firstDatabaseConnection.readWrite { transaction in
            transaction.removeAllObjects(inCollection: Message.collection())
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        // mappings
        connection = databaseManager.database.newConnection()
        connection?.beginLongLivedReadTransaction()
        mappings = YapDatabaseViewMappings(groups: ["group"], view: "view")
        connection?.read({ transaction in
            mappings?.update(with: transaction)
        })
        NotificationCenter.default.addObserver(self, selector: #selector(yapDatabaseDidChange), name: NSNotification.Name.YapDatabaseModified, object: nil)
    }
    
    @objc func applicationDidBecomActive() {
        databaseManager.firstDatabaseConnection.readWrite { transaction in
            let contact = Contact()
            transaction.setObject(contact, forKey: contact.uniqueId, inCollection: Contact.collection())
        }
            
        databaseManager.firstDatabaseConnection.read { transaction in
            let n = (transaction.ext("view") as! YapDatabaseViewTransaction).numberOfItems(inGroup: "group")
            firstLabel.text = "firstDatabaseConnection numberOfItems: \(n)"
        }

        databaseManager.secondDatabaseConnection.read { transaction in
          let n = (transaction.ext("view") as! YapDatabaseViewTransaction).numberOfItems(inGroup: "group")
            secondLabel.text = "secondDatabaseConnection numberOfItems: \(n)"
        }
        
        databaseManager.database.newConnection().read { transaction in
          let n = (transaction.ext("view") as! YapDatabaseViewTransaction).numberOfItems(inGroup: "group")
            thirdLabel.text = "newDatabaseConnection numberOfItems: \(n)"
        }
    }
    
    @objc func yapDatabaseDidChange() {
        let notifications = connection!.beginLongLivedReadTransaction()
        if connection!.hasChange(forCollection: Message.collection(), in: notifications) {
            let extConnection = connection!.ext("view") as! YapDatabaseAutoViewConnection
            extConnection.getSectionChanges(nil, rowChanges: nil, for: notifications, with: mappings!)
        } else {
            connection?.read({ transaction in
                mappings?.update(with: transaction)
            })
        }
    }
    
}

