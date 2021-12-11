//
//  AddPaymentMethodInterface.swift
//  
//
//  Created by devming on 2021/12/11.
//

import ModernRIBs
import FinanceRepository
import FinanceEntity
import RIBsUtil

public protocol AddPaymentMethodBuildable: Buildable {
    //    func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> AddPaymentMethodRouting
    func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting
}

public protocol AddPaymentMethodListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}
