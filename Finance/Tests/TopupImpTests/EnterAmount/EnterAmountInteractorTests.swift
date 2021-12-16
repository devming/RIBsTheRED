//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by devming on 2021/12/16.
//

@testable import TopupImp
import XCTest

final class EnterAmountInteractorTests: XCTestCase {

    private var sut: EnterAmountInteractor! // sut (=system under test, 검증대상이 되는 객체의 이름)
    private var presenter: EnterAmountPresentableMock!

    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()

//        sut = EnterAmountInteractor(
//            presenter: self.presenter,
//            dependency: <#T##EnterAmountInteractorDependency#>
//        )
    }

    // MARK: - Tests

    func test_exampleObservable_callsRouterOrListener_exampleProtocol() {
        // This is an example of an interactor test case.
        // Test your interactor binds observables and sends messages to router or listener.
    }
}
