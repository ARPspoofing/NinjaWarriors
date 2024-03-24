//
//  SlashAOESkill.swift
//  NinjaWarriors
//
//  Created by proglab on 23/3/24.
//

import Foundation
class SlashAOESkill: EntitySpawnerSkill {
    var id: SkillID
    private var cooldownDuration: TimeInterval // Cooldown duration in seconds
    private var cooldownRemaining: TimeInterval = 0 // Time remaining on cooldown

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 0
    }

    convenience init(id: SkillID, cooldownDuration: TimeInterval) {
        self.init(id: id)
        // self.id = id
        self.cooldownDuration = cooldownDuration
    }

   func isOnCooldown() -> Bool {
       return cooldownRemaining > 0
   }

   func decrementCooldown(deltaTime: TimeInterval) {
       cooldownRemaining = max(0, cooldownRemaining - deltaTime)
   }

   func activate(from entity: Entity, in manager: EntityComponentManager) {
       print("slash aoe activated")

       if isOnCooldown() { return }

       _ = spawnEntity(from: entity, in: manager)
       cooldownRemaining = cooldownDuration
   }

    func spawnEntity(from casterEntity: Entity, in manager: EntityComponentManager) -> Entity {
        let slashAOE = SlashAOE(id: RandomNonce().randomNonceString(),
                                shape: CircleShape(center: casterEntity.shape.center, radius: 20.0), casterEntity: casterEntity)
        manager.add(entity: slashAOE)
        return slashAOE
    }
}