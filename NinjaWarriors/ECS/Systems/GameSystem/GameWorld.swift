//
//  GameWorld.swift
//  NinjaWarriors
//
//  Created by proglab on 20/3/24.
//

import Foundation
import SwiftUI

// Represents the game world, containing entities and systems
class GameWorld {
    let entityComponentManager = EntityComponentManager()
    let systemManager = SystemManager()
    var gameLoopManager = GameLoopManager()
    var updateViewModel: () -> Void = {}

    init() {
        setupGameLoop()

        let transformHandler = TransformHandler(for: entityComponentManager)
        let collisionManager = CollisionManager(for: entityComponentManager)
        let rigidbodyHandler = RigidbodyHandler(for: entityComponentManager)
        let skillsManager = SkillCasterSystem(for: entityComponentManager)

        systemManager.add(system: transformHandler)
        systemManager.add(system: collisionManager)
        systemManager.add(system: rigidbodyHandler)
        systemManager.add(system: skillsManager)
    }

    private func setupGameLoop() {
        gameLoopManager.onUpdate = { [unowned self] deltaTime in
            self.update(deltaTime: deltaTime)
            self.updateViewModel()
        }
    }

    func start() {
        gameLoopManager.start()
    }

    func update(deltaTime: TimeInterval) {
        systemManager.update(after: deltaTime)
    }
}
