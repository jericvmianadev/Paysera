//
//  PersistenceManager.swift
//  Paysera
//
//  Created by Jeric Miana on 8/9/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation
import CoreData

class PersistenceManager {
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Paysera")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data Saving support

    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func retrieve<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            let objects = try context.fetch(fetchRequest) as? [T]
            return objects ?? []
        } catch {
            print("CORE DATA: retrieving failed")
            return []
        }
    }
}

extension PersistenceManager {
    
    // MARK: - Enum Currency
    enum Currency: String {
        case eur
        case usd
        case jpy
    }

    // MARK: - Get User Balance
    
    func getUserBalance() -> UserBalance? {
        return retrieve(UserBalance.self).first
    }
    
    // MARK: - Update User Balance
    
    func updateUserBalance(sellValue: Float,
                           sellCurrency: String,
                           buyValue: Float,
                           buyCurrency: String) {
        
        let sellCurrency = Currency(rawValue: sellCurrency)
        let buyCurrency = Currency(rawValue: buyCurrency)
        
        guard let userBalance = getUserBalance() else {
            return
        }
        
        switch sellCurrency {
        case .eur:
            guard userBalance.eur > sellValue else {
                return
            }
            userBalance.eur -= sellValue
        case .usd:
            guard userBalance.usd > sellValue else {
                return
            }
            userBalance.usd -= sellValue
        case .jpy:
            guard userBalance.jpy > sellValue else {
                return
            }
            userBalance.jpy -= sellValue
        default:
            return
        }
        
        switch buyCurrency {
        case .eur:
            userBalance.eur += buyValue
        case .usd:
            userBalance.usd += buyValue
        case .jpy:
            userBalance.jpy += buyValue
        default:
            return
        }
        
        save()
    }
}
