//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by devming on 2021/11/08.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil
import Network


// server API를 호출해서 그 유저에게 등록된 카드 목록을 가져온다.
public protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
    func fetch()
}

public final class CardOnFileRepositoryImp: CardOnFileRepository {
    
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> {
        return paymentMethodSubject
    }
    
    private let paymentMethodSubject = CurrentValuePublisher<[PaymentMethod]>([
//        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
//        PaymentMethod(id: "1", name: "신한카드", digits: "9064", color: "#347828ff", isPrimary: false),
//        PaymentMethod(id: "2", name: "현대카드", digits: "1733", color: "#f929a0ff", isPrimary: false),
//        PaymentMethod(id: "3", name: "삼성카드", digits: "6422", color: "#99ab02ff", isPrimary: false),
//        PaymentMethod(id: "4", name: "토스카드", digits: "5134", color: "#33ffaaff", isPrimary: false),
    ])
    
    public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
        
        let request = AddCardRequest(baseURL: baseURL, info: info)
        
        return network.send(request)
            .map(\.output.card)
            .handleEvents(receiveOutput: { [weak self] method in
                guard let this = self else {
                    return
                }
                this.paymentMethodSubject.send(this.paymentMethodSubject.value + [method])
            })
            .eraseToAnyPublisher()
    }
    
    public func fetch() {
        let request = CardOnFileRequest(baseURL: baseURL)
        network.send(request).map(\.output.cards)
            .sink { _ in
                
            } receiveValue: { [weak self] cards in
                self?.paymentMethodSubject.send(cards)
            }
            .store(in: &cancellables)

    }
    
    private let network: Network
    private let baseURL: URL
    private var cancellables: Set<AnyCancellable>
    
    public init(network: Network, baseURL: URL) {
        self.network = network
        self.baseURL = baseURL
        self.cancellables = .init()
    }
}
