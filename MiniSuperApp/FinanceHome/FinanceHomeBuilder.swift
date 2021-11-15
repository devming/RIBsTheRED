import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

// 상위 Component에서 하위 RIBlet들의 의존성들을 채택한다.
final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashBoardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency {
    let cardOnFileRepository: CardOnFileRepository
    var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
    
    private let balancePublisher: CurrentValuePublisher<Double>
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    init(
        dependency: FinanceHomeDependency,
        balance: CurrentValuePublisher<Double>,
        cardOnFileRepository: CardOnFileRepository
    ) {
        self.balancePublisher = balance
        self.cardOnFileRepository = cardOnFileRepository
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
        let balance = CurrentValuePublisher<Double>(10000)
        let component = FinanceHomeComponent(
            dependency: dependency,
            balance: balance,
            cardOnFileRepository: CardOnfileRepositoryImp()
        )
        let viewController = FinanceHomeViewController()
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashBoardBuilder = SuperPayDashBoardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashBoardBuildable: superPayDashBoardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: addPaymentMethodBuilder
        )
    }
}
