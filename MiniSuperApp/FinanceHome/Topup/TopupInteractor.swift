//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by devming on 2021/11/15.
//

/**
 CardOnFile과 EnterAmount RIBlet은 서로 모르기 때문에 직접 데이터를 주고 받을 수 없고(그렇게 해서도 안되고) TopupRIBlet을 통해 데이터를 주고 받아야한다.
 
 attach할 때 데이터를 넘겨주면 된다.
 */

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router. -> interactor에서 호출함으로써 sub-tree 관리하는 router 관련 함수들을 정의한다.
    
    // 결제 수단 추가 화면
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    
    // 카드 충전 화면
    func attachEnterAmount()
    func detachEnterAmount()
    
    // 카드 리스트 화면
    func attachCardOnFile(paymentMethods: [PaymentMethod])
    func detachCardOnFile()
}

// topup RIBlet 자체 리스너
protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    
    func topupDidClose()
    func topupDidFinish()
}

// TopupInteractor의 의존성 - 필요한 의존성들을 한곳에 몰아넣고 주입받음
protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

// TopInteractor는 TopInteractorable 프로토콜을 채택한다.
// Interactor에서 구현해주고 싶은 것은 Interactorable에 프로토콜을 달아주면 된다.
// 이것은 주로 자식 Interactorable들을 채택하게 되는데, 이런 것을 통해 봤을 때, interactor끼리 통신한다는 것이 이런 의미인것 같음
final class TopupInteractor: Interactor, TopupInteractable,  AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

    private var paymentMethods: [PaymentMethod] {
        dependency.cardOnFileRepository.cardOnFile.value
    }
    
    private let dependency: TopupInteractorDependency
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(dependency: TopupInteractorDependency) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
            dependency.paymentMethodStream.send(card)
            // 금액 입력 화면
            router?.attachEnterAmount()
        } else {
            // 카드 추가 화면
            router?.attachAddPaymentMethod()
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        // 입력된 정보로 카드 추가 버튼을 누르면
        // 새로 추가된 카드 정보를 stream으로 보내주고
        dependency.paymentMethodStream.send(paymentMethod)
        // 금액 입력 화면을 보여준다.
        router?.attachEnterAmount()
    }
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentMethods: paymentMethods)
    }
    
    func enterAmountDidFinishTopup() {
        // 충전이 완료되면 topup에서는 전체 flow를 완료하면 됨
        listener?.topupDidFinish()
    }
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        // attach add card
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            dependency.paymentMethodStream.send(selected)
        }
        router?.detachCardOnFile()
    }
}
