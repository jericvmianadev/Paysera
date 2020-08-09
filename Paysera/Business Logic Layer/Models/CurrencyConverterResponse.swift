//
//  CurrencyConverterResponse.swift
//  Paysera
//
//  Created by Jeric Miana on 8/9/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation

struct CurrencyConverterResponse: Decodable {
    
    let amount: String
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
}
