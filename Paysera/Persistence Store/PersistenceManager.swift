//
//  PersistenceManager.swift
//  Paysera
//
//  Created by Jeric Miana on 8/9/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Enum Currency
enum Currency: String {
    case eur
    case usd
    case jpy
    
    var description: String {
        return rawValue.uppercased()
    }
}

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
    
    // MARK: - Get User Balance
    
    func getUserBalance() -> UserBalance? {
        return retrieve(UserBalance.self).first
    }
    
    // MARK: - Update User Balance
    
    func updateUserBalance(sellValue: Double,
                           sellCurrency: String,
                           buyValue: Double,
                           buyCurrency: String,
                           comissionFee: Double,
                           success: () -> Void,
                           failure: (String) -> Void) {
        
        let sellCurrency = Currency(rawValue: sellCurrency.lowercased())
        let buyCurrency = Currency(rawValue: buyCurrency.lowercased())
       
        guard let userBalance = getUserBalance() else {
            return
        }
        
        /// Add comission fee to current sell value
        let totalSellValue = sellValue + comissionFee
        
        switch sellCurrency {
        case .eur:
            guard userBalance.eur >= totalSellValue else {
                failure(Strings.Alert.Message.insufficientBalance)
                return
            }
            userBalance.eur -= totalSellValue
        case .usd:
            guard userBalance.usd >= totalSellValue else {
                failure(Strings.Alert.Message.insufficientBalance)
                return
            }
            userBalance.usd -= totalSellValue
        case .jpy:
            guard userBalance.jpy >= totalSellValue else {
                failure(Strings.Alert.Message.insufficientBalance)
                return
            }
            userBalance.jpy -= totalSellValue
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
        incrementTransactionCount()
        save()
        success()
    }
}

extension PersistenceManager {
    
    // MARK: - Get User Transaction
    
    func getUserTransaction() -> UserTransaction? {
        return retrieve(UserTransaction.self).first
    }
    
    // MARK: - Increment Transaction Count

    func incrementTransactionCount() {
        if getUserTransaction() == nil {
            let userTransaction = UserTransaction(context: context)
            userTransaction.transactionCount += 1
        } else {
            getUserTransaction()?.transactionCount += 1
        }
    }
}
