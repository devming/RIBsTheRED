//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by devming on 2021/11/08.
//

import UIKit
import FinanceEntity


// 데이터 모델이 아니라 View와 Interactor를 이어주는 모듈이기 때문에 중복해서 사용하도록 한다. 
struct PaymentMethodViewModel {
    let name: String
    let digits: String
    let color: UIColor
    
    init(_ paymentMethod: PaymentMethod) {
        name = paymentMethod.name
        digits = "**** \(paymentMethod.digits)"
        color = UIColor(hex: paymentMethod.color) ?? .systemGray2
    }
}
