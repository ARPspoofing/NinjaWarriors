//
//  EntitiesManager.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol EntitiesManager {
    func getAllEntities() async throws -> [Entity]?
    func getEntity(entityId: EntityID) async throws -> Entity?
    func getEntitiesWithComponents() async throws -> ([EntityID: Component])

    func uploadEntity(entity: Entity, components: [Component]?) async throws

    func delete()
    func delete(entity: Entity)
    func delete(component: Component, from entity: Entity)


    func addPlayerListeners() -> [PlayerPublisher]
}
