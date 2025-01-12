//
//  EventQueue.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 5/4/24.
//

import Foundation

class EventQueue {
    private var queue: DispatchQueue
    var deletedEntities: [EntityID] = []

    init(label: String) {
        self.queue = DispatchQueue(label: label)
    }

    func async(execute work: @escaping () -> Void) {
        queue.async {
            work()
        }
    }

    func sync<T>(execute work: () throws -> T) rethrows -> T {
        return try queue.sync {
            try work()
        }
    }

    func contains(_ entity: Entity) -> Bool {
        deletedEntities.contains(entity.id)
    }

    func process(_ entity: Entity) {
        deletedEntities.append(entity.id)
    }

    func suspend() {
        queue.suspend()
    }

    func resume() {
        queue.resume()
    }

    func barrierAsync(execute work: @escaping () -> Void) {
        queue.async(flags: .barrier) {
            work()
        }
    }
}
