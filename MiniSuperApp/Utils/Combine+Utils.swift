//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by devming on 2021/11/04.
//

import Combine
import CombineExt
import Foundation

public class ReadOnlyCurrentValuePublisher<Element>: Publisher {
    public typealias Output = Element
    public typealias Failure = Never
    
    public var value: Element {
        currentValueRelay.value
    }
    
    fileprivate let currentValueRelay: CurrentValueRelay<Output>
    
    fileprivate init(_ initialValue: Element) {
        currentValueRelay = CurrentValueRelay(initialValue)
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Element == S.Input {
        currentValueRelay.receive(subscriber: subscriber)
    }
}

// CurrentValueSubject의 변형
// Subscriber들이 최신값에 접근을 할 수 있되, send는 할 수 없게 해주는 CustomPublisher
public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
    typealias Output = Element
    typealias Failure = Never
    
    public override init(_ initialValue: Element) {
        super.init(initialValue)
    }
    
    public func send(_ value: Element) {
        currentValueRelay.accept(value)
    }
}
// 잔액을 관리하는 객체가 CurrentValuePublisher를 생성해서 잔액이 바뀔 때 마다 send,
// 잔액을 사용하는 객체는 ReadOnlyCurrentValuePublisher를 사용해서 send는 못하고 value 프로퍼티를 사용해서 잔액을 가져갈 수 있도록 만듦
// -> 일종의 Subject와 send가 안되는 BehaviorRelay를 만든 것이라고 보면 될 듯?
