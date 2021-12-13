//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by devming on 2021/12/11.
//

import Foundation
import ModernRIBs
import AppHome
import FinanceHome
import FinanceRepository
import ProfileHome
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import AddPaymentMethod
import AddPaymentMethodImp
import Network
import NetworkImp

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency, AddPaymentMethodDependency {
    
    let cardOnFileRepository: CardOnFileRepository
    let superPayRepository: SuperPayRepository
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        TransportHomeBuilder(dependency: self)
    }()
    
    lazy var topupBuildable: TopupBuildable = {
        TopupBuilder(dependency: self)
    }()
    
    lazy var addPaymentMethodBuildable: AddPaymentMethodBuildable = {
        AddPaymentMethodBuilder(dependency: self)
    }()
    
    var topupBaseViewController: ViewControllable {
        rootViewController.topViewControllable
    }
    
    private let rootViewController: ViewControllable
    
    init(
        dependency: AppRootDependency,
        rootViewController: ViewControllable
    ) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [SuperAppURLProtocol.self]
        
        setupURLProtocol()
        let network = NetworkImp(session: URLSession(configuration: config))
//        let network = NetworkImp(session: URLSession.shared)  // 기본 URLSession
                
        self.cardOnFileRepository = CardOnFileRepositoryImp()
        self.superPayRepository = SuperPayRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}
