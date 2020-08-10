//
//  Strings.swift
//  Paysera
//
//  Created by Jeric Miana on 8/9/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation

// MARK: - Alert

struct Strings {
    struct App {
        static let name = "App.Name".localized
    }
    struct Alert {
        struct Title {
            static let currencyConverted = "Title.CurrencyConverted".localized
        }
        struct Message {
            static let currencyConverted: ( _ currency1: String,
                                            _ currency2: String,
                                            _ comission: String) -> String = { p1, p2, p3 in
                return String(format: "Message.CurrencyConverted".localized, p1, p2, p3)
            }
            static let insufficientBalance = "Message.InsufficientBalance".localized
        }
        struct Action {
            static let done = "Button.Title.Done".localized
            static let ok = "Button.Title.Ok".localized
        }
    }
}

// MARK: - Error

extension Strings {
    struct Error {
        static let invalidUrl = "Error.invalidUrl".localized
        static let invalidData = "Error.invalidData".localized
        static let invalidResponse = "Error.invalidResponse".localized
    }
}
