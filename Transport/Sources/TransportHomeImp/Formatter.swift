//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by devming on 2021/12/10.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
