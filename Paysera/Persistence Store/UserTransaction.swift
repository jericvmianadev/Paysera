//
//  UserTransaction.swift
//  Paysera
//
//  Created by Jeric Miana on 8/10/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreData Class

public class UserTransaction: NSManagedObject { }

// MARK: - CoreData Properties

extension UserTransaction {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserTransaction> {
        return NSFetchRequest<UserTransaction>(entityName: "UserTransaction")
    }
    
    @NSManaged public var transactionCount: Int16
}
