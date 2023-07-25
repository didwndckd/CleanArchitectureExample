//
//  LoadingTracker.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import Foundation
import Combine

final class LoadingTracker: Publisher {
    typealias Output = Bool
    typealias Failure = Never
    
    fileprivate let countTracker = SubscriberCounter()
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Bool == S.Input {
        countTracker
            .map { $0 > 0 }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .subscribe(subscriber)
    }
}

extension LoadingTracker {
    var value: Bool {
        return countTracker.value > 0
    }
}

extension Publisher {
    func trackLoading(_ tracker: LoadingTracker) -> AnyPublisher<Output, Failure> {
        return trackCount(tracker.countTracker)
    }
}
