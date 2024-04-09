//
//  GameTimerSystem.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation

class GameTimerSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let gameTimers = manager.getAllComponents(ofType: Lifespan.self)

        for gameTimer in gameTimers {
            gameTimer.lifespan -= time
        }
    }
}

