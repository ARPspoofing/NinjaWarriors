//
//  LifespanSystem.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

class LifespanSystem: System {
    var manager: EntityComponentManager
    var accumulatedTime: TimeInterval = 0

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after deltaTime: TimeInterval) {
        accumulatedTime += deltaTime

        if accumulatedTime >= 1.0 {
            let lifespanComponents = manager.getAllComponents(ofType: Lifespan.self)
            for lifespanComponent in lifespanComponents {
                lifespanComponent.elapsedTime += 1.0
                lifespanComponent.timeLeft -= 1.0
                if lifespanComponent.elapsedTime > Double(lifespanComponent.lifespan) {
                    manager.remove(entity: lifespanComponent.entity, isRemoved: false)
                }
            }
            accumulatedTime = 0
        }
    }
}
