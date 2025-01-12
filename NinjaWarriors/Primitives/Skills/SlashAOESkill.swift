//
//  SlashAOESkill.swift
//  NinjaWarriors
//
//  Created by Joshen on 23/3/24.
//

import Foundation
class SlashAOESkill: EntitySpawnerSkill {
    var id: SkillID
    var cooldownDuration: TimeInterval

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 0
    }

    convenience init(id: SkillID, cooldownDuration: TimeInterval) {
        self.init(id: id)
        self.cooldownDuration = cooldownDuration
    }

    func activate(from entity: Entity, in manager: EntityComponentManager) {
       _ = spawnEntity(from: entity, in: manager)
    }

    func updateAttributes(_ newSlashAOESkill: SlashAOESkill) {
        self.id = newSlashAOESkill.id
        self.cooldownDuration = newSlashAOESkill.cooldownDuration
    }

    func spawnEntity(from casterEntity: Entity, in manager: EntityComponentManager) -> Entity {
        print("[SlashAOESkill] Activated by \(casterEntity)")

        let slashAOE = SlashAOE(id: RandomNonce().randomNonceString(), casterEntity: casterEntity)

        guard let playerRigidbody = manager.getComponent(ofType: Rigidbody.self, for: casterEntity) else {
            print("[SlashAOESkill] No player rigidbody found")
            return slashAOE
        }

        let shape = Shape(center: playerRigidbody.position, halfLength: Constants.defaultSize)
        let rigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: slashAOE,
                                  angularDrag: 0.0, angularVelocity: Vector.zero, mass: 8.0,
                                  rotation: playerRigidbody.rotation, totalForce: Vector.zero, inertia: 0.0,
                                  position: shape.center, velocity: Vector.zero)

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(),
                                     entity: slashAOE, image: "slash-effect", width: Constants.slashRadius * 2,
                                     height: Constants.slashRadius * 2, health: 10, maxHealth: 100)

        let meleeAttackStrategy = MeleeAttackStrategy(casterEntity: casterEntity, radius: Constants.slashRadius)
        let attackComponent = Attack(id: RandomNonce().randomNonceString(), entity: slashAOE, attackStrategy: meleeAttackStrategy, damage: Constants.slashDamage)

        let lifespanComponent = Lifespan(id: RandomNonce().randomNonceString(), entity: slashAOE, lifespan: 1)

        manager.add(entity: slashAOE, components: [rigidbody, spriteComponent, attackComponent, lifespanComponent], isAdded: false)

        return slashAOE
    }
    
    func wrapper() -> SkillWrapper {
        return SkillWrapper(id: id, type: "SlashAOESkill", cooldownDuration: cooldownDuration)
    }
}
