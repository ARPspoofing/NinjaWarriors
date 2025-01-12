//
//  ColliderWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

struct ColliderWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var colliderShape: ShapeWrapper
    var collidedEntities: Set<EntityID>
    var isColliding: Bool
    var isOutOfBounds: Bool
    var wrapperType: String

    init(id: ComponentID, entity: EntityWrapper, colliderShape: ShapeWrapper,
         collidedEntities: Set<EntityID> = [], isColliding: Bool, isOutOfBounds: Bool, wrapperType: String) {
        self.id = id
        self.entity = entity
        self.colliderShape = colliderShape
        self.collidedEntities = collidedEntities
        self.isColliding = isColliding
        self.isOutOfBounds = isOutOfBounds
        self.wrapperType = wrapperType
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(wrapperType, forKey: AnyCodingKey(stringValue: "wrapperType"))
        try container.encode(colliderShape, forKey: AnyCodingKey(stringValue: "colliderShape"))
        try container.encode(collidedEntities, forKey: AnyCodingKey(stringValue: "collidedEntities"))
        try container.encode(isColliding, forKey: AnyCodingKey(stringValue: "isColliding"))
        try container.encode(isOutOfBounds, forKey: AnyCodingKey(stringValue: "isOutOfBounds"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))

        wrapperType = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "wrapperType"))

        guard let wrapperClass = NSClassFromString(wrapperType) as? EntityWrapper.Type else {
            throw NSError(domain: "NinjaWarriors.Wrapper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid wrapper type: \(wrapperType)"])
        }

        entity = try container.decode(wrapperClass.self, forKey: AnyCodingKey(stringValue: "entity"))

        colliderShape = try container.decode(ShapeWrapper.self, forKey: AnyCodingKey(stringValue: "colliderShape"))

        // Check if collidedEntities field is present
        if container.contains(AnyCodingKey(stringValue: "collidedEntities")) {
            collidedEntities = try container.decode(Set<EntityID>.self, forKey: AnyCodingKey(stringValue: "collidedEntities"))
        } else {
            collidedEntities = Set<EntityID>()
        }
        isColliding = try container.decode(Bool.self, forKey: AnyCodingKey(stringValue: "isColliding"))
        isOutOfBounds = try container.decode(Bool.self, forKey: AnyCodingKey(stringValue: "isOutOfBounds"))
    }

    func toComponent(entity: Entity) -> Component? {
        return Collider(id: id, entity: entity, colliderShape: colliderShape.toShape(),
                        collidedEntities: collidedEntities,
                        isColliding: isColliding, isOutOfBounds: isOutOfBounds)
    }
}
