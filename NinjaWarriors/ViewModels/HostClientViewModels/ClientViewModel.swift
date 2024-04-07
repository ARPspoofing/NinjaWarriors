//
//  ClientViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 6/4/24.
//

import Foundation
import SwiftUI

@MainActor
final class ClientViewModel: ObservableObject, HostClientObserver  {
    var manager: EntitiesManager
    var entityComponentManager: EntityComponentManager
    var entities: [Entity] = []
    var queue = EventQueue(label: "clientEventQueue")
    var matchId: String
    var currPlayerId: String

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.manager = RealTimeManagerAdapter(matchId: matchId)
        self.entityComponentManager = EntityComponentManager(for: matchId)
        self.entityComponentManager.addObserver(self)
        entityComponentManager.startListening()
    }

    nonisolated func entityComponentManagerDidUpdate() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    func getEntity(from id: EntityID) -> Entity? {
        for entity in entities {
            if entity.id == id {
                return entity
            }
        }
        return nil
    }

    func getCurrPlayer() -> Entity? {
        for entity in entities where entity.id == currPlayerId {
            return entity
        }
        return nil
    }

    func updateEntities() {
        entities = entityComponentManager.getAllEntities()
    }

    func move(_ vector: CGVector) {
        guard let entityIdComponents = entityComponentManager.entityComponentMap[currPlayerId] else {
            return
        }
        for entityIdComponent in entityIdComponents {
            if let entityIdComponent = entityIdComponent as? Rigidbody {
                if entityIdComponent.attachedCollider?.isColliding == true {
                    entityIdComponent.collidingVelocity = Vector(horizontal: vector.dx,
                                                                 vertical: vector.dy)
                } else {
                    entityIdComponent.velocity = Vector(horizontal: vector.dx, vertical: vector.dy)
                }
            }
        }
        Task {
            try await entityComponentManager.publish()
        }
    }

    func render(for entity: Entity) -> (image: Image, position: CGPoint)? {
        let entityComponents = entityComponentManager.getAllComponents(for: entity)

        guard let rigidbody = entityComponents.first(where: { $0 is Rigidbody }) as? Rigidbody,
              let sprite = entityComponents.first(where: { $0 is Sprite }) as? Sprite else {
            return nil
        }
        return (image: Image(sprite.image), position: rigidbody.position.get())
    }
}

extension ClientViewModel {
    func activateSkill(forEntity entity: Entity, skillId: String) {
        let entityId = entity.id
        guard let components = entityComponentManager.entityComponentMap[entityId] else {
            return
        }
        for component in components {
            if let skillCaster = component as? SkillCaster {
                skillCaster.queueSkillActivation(skillId)
            }
        }
        Task {
            try await entityComponentManager.publish()
        }
    }

    func getSkillIds(for entity: Entity) -> [String] {
        let entityId = entity.id
        guard let components = entityComponentManager.entityComponentMap[entityId] else {
            return []
        }
        for component in components {
            if let skillCaster = component as? SkillCaster {
                let skillCasterIds = skillCaster.skills.keys
                return Array(skillCasterIds)
            }
        }
        return []
    }

    func getSkills(for entity: Entity) -> [Dictionary<SkillID, any Skill>.Element] {
        let entityId = entity.id
        guard let components = entityComponentManager.entityComponentMap[entityId] else {
            return []
        }
        for component in components {
            if let skillCaster = component as? SkillCaster {
                let skills = skillCaster.skills
                return Array(skills)
            }
        }
        return []
    }

    func getSkillCooldowns(for entity: Entity) -> Dictionary<SkillID, TimeInterval> {
        let entityId = entity.id
        guard let components = entityComponentManager.entityComponentMap[entityId] else {
            return [:]
        }
        for component in components {
            if let skillCaster = component as? SkillCaster {
                let skillsCooldown = skillCaster.skillCooldowns
                return skillsCooldown
            }
        }
        return [:]
    }
}