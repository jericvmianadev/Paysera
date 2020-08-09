//
//  ApiController.swift
//  Paysera
//
//  Created by Jeric Miana on 8/9/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation
import RxSwift

class ApiController: NSObject {
    
    static let shared = ApiController()

    func convertCurrency(amount: String, sellCurrency: String, buyCurrency: String) -> Observable<CurrencyConverterResponse?> {
        return CurrencyConverterService(amount: amount,
                                        sellCurrency: sellCurrency,
                                        buyCurrency: buyCurrency).request()
    }
}
