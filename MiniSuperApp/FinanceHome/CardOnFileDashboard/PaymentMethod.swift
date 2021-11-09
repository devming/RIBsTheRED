//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by devming on 2021/11/08.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
