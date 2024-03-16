//
//  PlayerPublisher.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
/*
final class PlayerPublisher: FactoryPublisher {
    //typealias UpdateClosure = ([FactoryWrapper]) -> Void
    //typealias UpdateClosure = ([PlayerWrapper]) -> Void
    typealias ErrorClosure = (Error) -> Void

    var updateClosure: UpdateClosure?
    var errorClosure: ErrorClosure?

    func subscribe(update: @escaping UpdateClosure, error: @escaping ErrorClosure) {
        self.updateClosure = update
        self.errorClosure = error
    }

    /*
    func publish(_ update: [PlayerWrapper]) {
        updateClosure?(update)
    }
    */

    func publish(_ update: [FactoryWrapper]) {
        updateClosure?(update)
    }

    func publishError(_ error: Error) {
        errorClosure?(error)
    }
}
*/

/*
final class PlayerPublisher: FactoryPublisher {
    //typealias UpdateClosure = ([FactoryWrapper]) -> Void
    typealias UpdateClosure = ([PlayerWrapper]) -> Void
    typealias ErrorClosure = (Error) -> Void

    var updateClosure: UpdateClosure?
    var errorClosure: ErrorClosure?

    func subscribe(update: @escaping UpdateClosure, error: @escaping ErrorClosure) {
        self.updateClosure = update
        self.errorClosure = error
    }

    func publish(_ update: [FactoryWrapper]) {
        if let playerWrappers = update as? [PlayerWrapper] {
            updateClosure?(playerWrappers)
        }
    }

    func publishError(_ error: Error) {
        errorClosure?(error)
    }
}
*/


final class PlayerPublisher: FactoryPublisher {
    typealias T = PlayerWrapper
    typealias UpdateClosure = ([PlayerWrapper]) -> Void
    typealias ErrorClosure = (Error) -> Void

    var updateClosure: UpdateClosure?
    var errorClosure: ErrorClosure?

    func subscribe(update: @escaping UpdateClosure, error: @escaping ErrorClosure) {
        self.updateClosure = update
        self.errorClosure = error
    }

    func publish(_ update: [PlayerWrapper]) {
        updateClosure?(update)
    }

    func publishError(_ error: Error) {
        errorClosure?(error)
    }
}

