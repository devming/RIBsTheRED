//
//  SuperPayDashBoardInteractor.swift
//  MiniSuperApp
//
//  Created by devming on 2021/10/30.
//

import Foundation
import ModernRIBs
import Combine

protocol SuperPayDashBoardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashBoardPresentable: Presentable {
    var listener: SuperPayDashBoardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func updateBalance(_ balance: String)
}

protocol SuperPayDashBoardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol SuperPayDashboardInteractorDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    var balanceFormatter: NumberFormatter { get }
}

final class SuperPayDashBoardInteractor: PresentableInteractor<SuperPayDashBoardPresentable>, SuperPayDashBoardInteractable, SuperPayDashBoardPresentableListener {

    weak var router: SuperPayDashBoardRouting?
    weak var listener: SuperPayDashBoardListener?
    
    private let dependency: SuperPayDashboardInteractorDependency
    
    private var cancellable: Set<AnyCancellable>
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: SuperPayDashBoardPresentable,
        dependency: SuperPayDashboardInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellable = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        dependency.balance
            .map { NSNumber(value: $0) }
            .compactMap { [weak self] balance in  self?.dependency.balanceFormatter.string(from: balance)
            }
            .sink(receiveValue: self.presenter.updateBalance)
            .store(in: &cancellable)
//        dependency.balance.sink { [weak self] balance in
//            self?.dependency.balanceFormatter
//                .string(from: NSNumber(value: balance))
//                .map { self?.presenter.updateBalance($0) }
//        }
//        .store(in: &cancellable)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
