//
//  Observable.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation

public class ObservationToken {
    
    private let cancellationClosure: () -> Void
    
    public init(cancellationClosure: @escaping () -> Void) {
        self.cancellationClosure = cancellationClosure
    }
    
    public func cancel() {
        cancellationClosure()
    }
}

extension Dictionary where Key == UUID {
    mutating func insert(_ value: Value) -> UUID {
        let id = UUID()
        self[id] = value
        return id
    }
}


public final class Observable<Value> {
    
    struct Observer<Value> {
        weak var observer: AnyObject?
        let closure: (Value) -> Void
    }
    
    private var observers = [UUID: (Value) -> Void]()
    
    public var value: Value {
        didSet { notifyObservers() }
    }
    
    public init(_ value: Value) {
        self.value = value
    }
    
    @discardableResult
    public func observe(using closure: @escaping (Value) -> Void) -> ObservationToken {
        let id = observers.insert(closure)
        
        return ObservationToken { [weak self] in
            self?.observers.removeValue(forKey: id)
        }
    }
    
    func notifyObservers() {
        observers.values.forEach { $0(value) }
    }
}
