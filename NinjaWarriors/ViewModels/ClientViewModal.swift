//
//  ClientViewModal.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 23/4/24.
//

import Foundation
import SwiftUI

final class ClientViewModal: ObservableObject {
    var manager: EntitiesManager
    var gameWorld: GameWorld
    var entityComponents: [EntityID: [Component]] = [:]
    var entities: [Entity] = []
    var matchId: String
    var currPlayerId: String
    var queue = EventQueue(label: "clientEventQueue")

    init(matchId: String, currPlayerId: String, gameMode: GameMode) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.manager = RealTimeManagerAdapter(matchId: matchId)

        let metricsRepository = MetricsRepository(activeUser: currPlayerId, shouldStoreOnCloud: false)
        let achievementsManager = AchievementManager(userID: currPlayerId,
                                                      metricsSubject: metricsRepository,
                                                      shouldStoreOnCloud: false)
        self.gameWorld = GameWorld(for: matchId, metricsRecorder: EntityMetricsRecorderAdapter(metricsRepository: metricsRepository, matchID: matchId), achievementManager: achievementsManager, gameMode: gameMode)
        self.initialPopulate()
        startListening()
    }

    func startListening() {
        manager.addEntitiesListener { _ in
            self.queue.async {
                self.populate()
                Task {
                    await self.publish()
                }
            }
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

    func initialPopulate() {
        Task {
            do {
                let (fetchEntities, fetchEntitiesComponents) = try await manager.getEntitiesWithComponents()

                if entities.isEmpty {
                    entities = fetchEntities
                }
                if entityComponents == [:] {
                    entityComponents = fetchEntitiesComponents
                }
            }
        }
    }

    func populate() {
        Task {
            do {
                let (fetchEntities, fetchEntitiesComponents) = try await manager.getEntitiesWithComponents()
                process(fetchEntities, fetchEntitiesComponents)
            } catch {
                print("Error fetching client data \(error)")
            }
        }
    }

    func process(_ fetchEntities: [Entity], _ fetchComponents: [EntityID: [Component]]) {
        for (entityId, entityIdComponents) in fetchComponents {
            if entityComponents[entityId] == nil {
                entityComponents[entityId] = entityIdComponents
                continue
            } else {
                guard var currEntityIdComponents = entityComponents[entityId] else {
                    continue
                }
                entityIdComponents.forEach { entityIdComponent in
                    var isSameType = false
                    for currEntityIdComponent in currEntityIdComponents {
                        if ComponentType(type(of: entityIdComponent)) == ComponentType(type(of: currEntityIdComponent)) {
                            currEntityIdComponent.updateAttributes(entityIdComponent)
                            isSameType = true
                        }
                    }
                    if !isSameType {
                        guard let currEntity: Entity = getEntity(from: entityId) else {
                            return
                        }
                        currEntityIdComponents.append(entityIdComponent.changeEntity(to: currEntity))
                    }
                }
            }
        }
    }

    func move(_ vector: CGVector) {
        guard let entityIdComponents = entityComponents[currPlayerId] else {
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
            await publish()
        }
    }

    @Sendable func publish() async {
        for entity in entities {
            do {
                let componentsToUpload = entityComponents[entity.id]
                try await manager.uploadEntity(entity: entity, components: componentsToUpload)
            } catch {
                print("Error updating client data \(error)")
            }
        }
    }

    func render(for entity: Entity) -> (image: Image, position: CGPoint)? {
        guard let entityComponents = entityComponents[entity.id] else {
            return nil
        }
        guard let rigidbody = entityComponents.first(where: { $0 is Rigidbody }) as? Rigidbody,
              let sprite = entityComponents.first(where: { $0 is Sprite }) as? Sprite else {
            return nil
        }
        return (image: Image(sprite.image), position: rigidbody.position.get())
    }

    // Only update values that changed
    func updateViews() {
        objectWillChange.send()
    }
}

extension ClientViewModal {
    func activateSkill(forEntity entity: Entity, skillId: String) {
        let entityId = entity.id
        guard let components = entityComponents[entityId] else {
            return
        }
        for component in components {
            if let skillCaster = component as? SkillCaster {
                skillCaster.queueSkillActivation(skillId)
            }
        }
    }

    func getSkillIds(for entity: Entity) -> [String] {
        let entityId = entity.id
        guard let components = entityComponents[entityId] else {
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
        guard let components = entityComponents[entityId] else {
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

    func getSkillCooldowns(for entity: Entity) -> [SkillID: TimeInterval] {
        let entityId = entity.id
        guard let components = entityComponents[entityId] else {
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
