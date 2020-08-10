//
//  CurrencyConverterViewModel.swift
//  Paysera
//
//  Created by Jeric Miana on 8/9/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation
import RxSwift

class CurrencyConverterViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let persistenceManager = PersistenceManager()
    
    // MARK: - Make API Request
    
    func convertCurrency(sellCurrency: String,
                         buyCurrency: String,
                         amount: String,
                         success: @escaping (CurrencyConverterResponse) -> Void,
                         failure: @escaping (String) -> Void) {
        
        ApiController.shared.convertCurrency(amount: amount,
                                             sellCurrency: sellCurrency,
                                             buyCurrency: buyCurrency)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { response in
                    guard let response = response else {
                        failure(WebServiceError.invalidResponse.description)
                        return
                    }
                    success(response)
                },
                onError: { error in
                    failure((error as? WebServiceError)?.description ?? error.localizedDescription)
                }).disposed(by: disposeBag)
    }
    
    // MARK: - Compute Comission Fee
    
    func computeComissionFee(sellValue: Double) -> Double? {
        guard
            let transactionCount = persistenceManager.getUserTransaction()?.transactionCount,
            transactionCount >= 5
        else {
            return 0.0
        }
        return sellValue * Constants.comissionFee
    }
}
