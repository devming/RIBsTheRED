import ModernRIBs
import UIKit

// XXXRouting에 attach할 RIBlet 메소드 정의
protocol FinanceHomeRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachSuperPayDashboard()
    func attachCardOnFileDashboard()
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    func attachTopup()
    func detachTopup()
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener, AdaptivePresentationControllerDelegate {
    
  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: FinanceHomePresentable) {
      self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
      self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
      
      router?.attachSuperPayDashboard()
      router?.attachCardOnFileDashboard()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
    
    func presentationControllerDidDismiss() {
        router?.detachAddPaymentMethod()
    }
    
    // MARK: - CardOnFileDashboardListener
    func cardOnFileDashboardDidTapAddPaymentMethod() {
        router?.attachAddPaymentMethod()
    }
    
    // MARK: - AddPaymentMethodListener
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        router?.detachAddPaymentMethod()
    }
    
    func superPayDashboardDidTapTopup() {
        router?.attachTopup()
    }
    
    func topupDidClose() {
        router?.detachTopup()
    }
    
    func topupDidFinish() {
        router?.detachTopup()
    }
}
