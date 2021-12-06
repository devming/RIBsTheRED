//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by devming on 2021/11/15.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {

    private var navigationControllable: NavigationControllerable?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let enterAmountBuildable: EnterAmountBuildable
    private var enterAmountRouting: Routing?
    
    private let cardOnFileBuildable: CardOnFileBuildable
    private var cardOnFileRouting: Routing?
    
    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        enterAmountBuildable: EnterAmountBuildable,
        cardOnFileBuildable: CardOnFileBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.enterAmountBuildable = enterAmountBuildable
        self.cardOnFileBuildable = cardOnFileBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
        
        // ViewLess RIBlet은 부모가 직접 present한 View가 없기 때문에 dismiss를 하지 않는다.
        // ViewLess RIBlet은 자신의 역할이 끝났을 때, 자신의 띄워줬던 화면을 모두 닫아줘야하는 의무가 있다.
        
        //TopupInteractor의 willResignActive()에서 호출된다. (willResignActive()는 부모가 detachChild가 실행되면 호출되게 된다.)
        if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
        if addPaymentMethodRouting != nil {
            return
        }
        let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)
        
        if let navigationControllable = navigationControllable {
            navigationControllable.pushViewController(router.viewControllable, animated: true)
        } else {
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        addPaymentMethodRouting = router
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else {
            return
        }
        
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        addPaymentMethodRouting = nil
    }
//    22:45
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllable = navigation
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil {
            return
        }
        
        viewController.dismiss(completion: nil)
        self.navigationControllable = nil
    }
    
    func attachEnterAmount() {
        // 1. 처음 화면에서 EnterAmount를 띄우는 경우는 모달로 띄우고
        // 2. 카드 추가화면에서 EnterAmount를 띄우는 경우는 Navigation Push를 해줘야한다.
        if enterAmountRouting != nil {
            return
        }
        
        let router = enterAmountBuildable.build(withListener: interactor)
        
        if let navigation = navigationControllable {
            // navigation이 있다면(카드 추가화면[AddPaymentMethod]에서 이동하는 것이라면)
            // 이동할 때, 기존의 스택(AddPaymentMethod)은 날려주고 새로 추가하는 화면만 남는 방식의 push를 수행한다.
            navigation.setViewControllers([router.viewControllable])
            // 그리고 이미 존재했던 View를 날렸기 때문에, router도 날려줘야한다.
            resetChildRouting()
        } else {
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        enterAmountRouting = router
    }
    
    func detachEnterAmount() {
        guard let router = enterAmountRouting else {
            return 
        }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        enterAmountRouting = nil
    }

    func attachCardOnFile(paymentMethods: [PaymentMethod]) {
        if cardOnFileRouting != nil {
            return
        }
        // 1. topup RIBlet에서는 CardOnFile RIBlet을 어떻게 보여줘야하는지 판단할 수 있다.
        // 2. paymentMethods(RIBlet간 전달 데이터)를 CardOnFile RIBlet으로 전달하기 위해 build메소드를 사용한다.
        let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        cardOnFileRouting = router
        attachChild(router)
    }
    
    
    func detachCardOnFile() {
        guard let router = cardOnFileRouting else {
            return
        }
        
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        cardOnFileRouting = nil
    }
    
    func popToRoot() {
        navigationControllable?.popToRoot(animated: true)
        resetChildRouting()
    }
    
    private func resetChildRouting() {
        if let cardOnFileRouting = cardOnFileRouting {
            detachChild(cardOnFileRouting)
            self.cardOnFileRouting = nil
        }
        
        if let addPaymentMethodRouting = addPaymentMethodRouting {
            detachChild(addPaymentMethodRouting)
            self.addPaymentMethodRouting = nil
        }
    }
    
    // MARK: - Private

    private let viewController: ViewControllable
}
