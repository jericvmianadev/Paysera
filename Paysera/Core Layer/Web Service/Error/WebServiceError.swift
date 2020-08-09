//
//  WebServiceError.swift
//  Paysera
//
//  Created by Jeric Miana on 8/9/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation

enum WebServiceError: Error {
    case invalidUrl
    case invalidData
    case invalidResponse
    
    var description: String {
        switch self {
        case .invalidUrl:
            return Strings.Error.invalidUrl
        case .invalidData:
            return Strings.Error.invalidData
        case .invalidResponse:
            return Strings.Error.invalidResponse
        }
    }
}
