//
//  UserBalance.swift
//  Paysera
//
//  Created by Jeric Miana on 8/9/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreData Class

public class UserBalance: NSManagedObject { }

// MARK: - CoreData Properties

extension UserBalance {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserBalance> {
        return NSFetchRequest<UserBalance>(entityName: "UserBalance")
    }
    
    @NSManaged public var eur: Double
    @NSManaged public var usd: Double
    @NSManaged public var jpy: Double
}
