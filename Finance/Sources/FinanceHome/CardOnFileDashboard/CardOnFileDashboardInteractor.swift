//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by devming on 2021/11/08.
//

import Foundation
import ModernRIBs
import Combine
import FinanceRepository

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    /// 이 listner는 부모 RIBlet의 Interactor임.
    /// 따라서 이 리스너를 통해 여기서 발생한 이벤트를 부모에게 전달할 수 있음
    weak var listener: CardOnFileDashboardListener?
    
    private let dependency: CardOnFileDashboardInteractorDependency

    private var cancellables: Set<AnyCancellable>
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CardOnFileDashboardPresentable,
        dependency: CardOnFileDashboardInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        dependency.cardsOnFileRepository.cardOnFile
            .receive(on: DispatchQueue.main)
            .sink { methods in
                // vc는 그리라는 것만 최대한 그리게 하는 바보객체로 만들기 위해
                let viewModels = methods.prefix(5).map(PaymentMethodViewModel.init)
                self.presenter.update(with: viewModels)
            }.store(in: &cancellables)
    }

    // interactor가 detach되기 직전에 호출됨
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        
        // 아래의 cancellables 제거 구문을 통해 combine에서 사용하는 클로저에서 retain cycle을 제거할 수 있다.
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didTapAddPaymentMethod() {
        /// 여기서 AddPaymentMethod RIBlet을 추가할 수 도 있다.
        /// 그러나  화면의 일부만 담당하고 있는 CardOnFileDashboard에서 띄우기보단 더 넓은 범위를 가지고 있는 FinanceHome(부모) RIBlet에서 띄워주면 의미가 더 명확할 것 같다.
        /// 따라서 CardOnFileDashboard에서 FinanceHome에게 여기서 버튼이 눌렸다는 이벤트를 알려줘야한다.
        /// RIBlet끼리의 통신은 두뇌인 Interactor끼리 한다.
        
        listener?.cardOnFileDashboardDidTapAddPaymentMethod()
        // -> 그리고 이 것은 FinanceHomeInteractor에서 구현된다.
    }
}
