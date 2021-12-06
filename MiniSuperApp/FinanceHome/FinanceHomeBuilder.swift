import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
}

// 상위 Component에서 하위 RIBlet들의 의존성들을 채택한다.
final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashBoardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    var topupBaseViewController: ViewControllable
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    init(
        dependency: FinanceHomeDependency,
        topupBaseViewController: ViewControllable
    ) {
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
        let viewController = FinanceHomeViewController()
        let component = FinanceHomeComponent(
            dependency: dependency,
            topupBaseViewController: viewController
        )
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashBoardBuilder = SuperPayDashBoardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let topupBuilder = TopupBuilder(dependency: component)
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashBoardBuildable: superPayDashBoardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: addPaymentMethodBuilder,
            topupBuildable: topupBuilder
        )
    }
}
