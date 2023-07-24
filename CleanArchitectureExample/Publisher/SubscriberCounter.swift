//
//  SubscriberCounter.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import Foundation
import Combine

final class SubscriberCounter: Publisher {
    typealias Output = Int
    typealias Failure = Never
    
    private let lock = NSRecursiveLock()
    private let countSubject = CurrentValueSubject<Int, Never>(0)
    
    deinit {
        countSubject.send(0)
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        countSubject
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .subscribe(subscriber)
    }
    
    fileprivate func increment() {
        lock.lock()
        countSubject.send(self.countSubject.value + 1)
        lock.unlock()
    }
    
    fileprivate func decrement() {
        lock.lock()
        countSubject.send(self.countSubject.value - 1)
        lock.unlock()
    }
}

extension SubscriberCounter {
    var value: Int {
        return countSubject.value
    }
}

extension Publisher {
    func trackCount(_ counter: SubscriberCounter) -> AnyPublisher<Output, Failure> {
        return handleEvents(
            receiveCompletion: { completion in
                counter.decrement()
            },
            receiveCancel: {
                counter.decrement()
            },
            receiveRequest: { _ in
                counter.increment()
            })
        .eraseToAnyPublisher()
    }
}
