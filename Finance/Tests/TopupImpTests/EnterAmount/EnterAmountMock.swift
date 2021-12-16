//
//  EnterAmountMock.swift
//  
//
//  Created by devming on 2021/12/16.
//

import Foundation
@testable import TopupImp
import CombineUtil
import FinanceEntity

final class EnterAmountPresentableMock: EnterAmountPresentable {
    var listener: EnterAmountPresentableListener?
    
    var updateSelectedPaymentMethodCallCount = 0
    var updateSelectedPaymentMethodViewModel: SelectedPaymentMethodViewModel
    
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel) {
        updateSelectedPaymentMethodCallCount += 1
        updateSelectedPaymentMethodViewModel = viewModel
    }
    
    var startLoadingCallCount = 0
    func startLoading() {
        startLoadingCallCount += 1
    }
    
    var stopLoadingCallCount = 0
    func stopLoading() {
        stopLoadingCallCount += 1
    }
    
    init() {
        
    }
    
}

//final class EnterAmountDependencyMock: EnterAmountInteractorDependency {
//    var selectedPaymentMethodSubject: CurrentValuePublisher<PaymentMethod>(
//        PaymentMethod(
//            id: "",
//            name: "",
//            digits: "",
//            color: "",
//            isPrimary: false
//        )
//    )
//    
//    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { selectedPaymentMethodSubject }
//    var superPayRepository: SuperPayRepository
//    9:25
//}
