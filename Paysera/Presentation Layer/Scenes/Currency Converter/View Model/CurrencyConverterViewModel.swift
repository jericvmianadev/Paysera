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
    
    private let disposeBag = DisposeBag()
    
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
}
