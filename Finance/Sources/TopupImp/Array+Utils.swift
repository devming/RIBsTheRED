//
//  Array+Util.swift
//  
//
//  Created by devming on 2021/12/10.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

