//
//  HealthWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

struct HealthWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var entityInflictDamageMap: [EntityID: Bool] = [:]
    var health: Double
    var maxHealth: Double
    var wrapperType: String

    init(id: ComponentID, entity: EntityWrapper, entityInflictDamageMap: [EntityID: Bool], health: Double, maxHealth: Double, wrapperType: String) {
        self.id = id
        self.entity = entity
        self.entityInflictDamageMap = entityInflictDamageMap
        self.health = health
        self.maxHealth = maxHealth
        self.wrapperType = wrapperType
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        var entityContainer = container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                        forKey: AnyCodingKey(stringValue: "entityInflictDamageMap"))

        for (entityID, isDamaged) in entityInflictDamageMap {
            try entityContainer.encode(isDamaged, forKey: AnyCodingKey(stringValue: entityID))
        }
        try container.encode(health, forKey: AnyCodingKey(stringValue: "health"))
        try container.encode(maxHealth, forKey: AnyCodingKey(stringValue: "maxHealth"))
        try container.encode(wrapperType, forKey: AnyCodingKey(stringValue: "wrapperType"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))

        wrapperType = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "wrapperType"))

        guard let wrapperClass = NSClassFromString(wrapperType) as? EntityWrapper.Type else {
            throw NSError(domain: "NinjaWarriors.Wrapper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid wrapper type: \(wrapperType)"])
        }
        entity = try container.decode(wrapperClass.self, forKey: AnyCodingKey(stringValue: "entity"))

        health = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "health"))
        maxHealth = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "maxHealth"))
        do {
            let entityContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                                forKey: AnyCodingKey(stringValue: "entityInflictDamageMap"))
            for key in entityContainer.allKeys {
                let entityID = key.stringValue
                let isDamaged = try entityContainer.decode(Bool.self, forKey: key)
                entityInflictDamageMap[entityID] = isDamaged
            }
        } catch {
            entityInflictDamageMap = [:] // Assign an empty dictionary if field is missing
        }
    }

    func toComponent(entity: Entity) -> Component? {
        return Health(id: id, entity: entity,
                      entityInflictDamageMap: entityInflictDamageMap,
                      health: health, maxHealth: maxHealth)
    }
}
