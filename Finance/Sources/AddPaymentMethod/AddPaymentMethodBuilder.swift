//
//  AddPaymentMethodBuilder.swift
//  MiniSuperApp
//
//  Created by devming on 2021/11/09.
//

import ModernRIBs
import FinanceRepository
import RIBsUtil

public protocol AddPaymentMethodDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency>, AddPaymentMethodInteratorDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol AddPaymentMethodBuildable: Buildable {
//    func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> AddPaymentMethodRouting
    func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting
}

public final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {

    public override init(dependency: AddPaymentMethodDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting {
        let component = AddPaymentMethodComponent(dependency: dependency)
        let viewController = AddPaymentMethodViewController(closeButtonType: closeButtonType)
        let interactor = AddPaymentMethodInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
    }
}
