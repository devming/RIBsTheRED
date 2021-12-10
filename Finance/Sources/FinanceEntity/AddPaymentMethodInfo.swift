//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by devming on 2021/11/15.
//

import Foundation

public struct AddPaymentMethodInfo {
    public let number: String
    public let cvc: String
    public let expiry: String
    
    public init(
        number: String,
        cvc: String,
        expiry: String
    ) {
        self.number = number
        self.cvc = cvc
        self.expiry = expiry
    }
}
