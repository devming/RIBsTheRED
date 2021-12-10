//
//  SuperPayDashBoardBuilder.swift
//  MiniSuperApp
//
//  Created by devming on 2021/10/30.
//

import ModernRIBs
import Foundation
import CombineUtil

// 부모로 부터 받고 싶은 dependency는 여기서 선언
protocol SuperPayDashBoardDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.

    // Builder에서 만들던지, 부모로부터 받던지.
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class SuperPayDashBoardComponent: Component<SuperPayDashBoardDependency>, SuperPayDashboardInteractorDependency {
    var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
    
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance }
}

// MARK: - Builder

protocol SuperPayDashBoardBuildable: Buildable {
    func build(withListener listener: SuperPayDashBoardListener) -> SuperPayDashBoardRouting
}

final class SuperPayDashBoardBuilder: Builder<SuperPayDashBoardDependency>, SuperPayDashBoardBuildable {

    override init(dependency: SuperPayDashBoardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SuperPayDashBoardListener) -> SuperPayDashBoardRouting {
        let component = SuperPayDashBoardComponent(dependency: dependency)
        let viewController = SuperPayDashBoardViewController()
        let interactor = SuperPayDashBoardInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SuperPayDashBoardRouter(interactor: interactor, viewController: viewController)
    }
}
