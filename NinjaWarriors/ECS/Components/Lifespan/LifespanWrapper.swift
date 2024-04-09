//f
//  LifespanWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation

struct LifespanWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    let lifespan: TimeInterval
    var elapsedTime: TimeInterval
    var timeLeft: TimeInterval

    init(id: ComponentID, entity: EntityWrapper, lifespan: TimeInterval,
         elapsedTime: TimeInterval, timeLeft: TimeInterval) {
        self.id = id
        self.entity = entity
        self.lifespan = lifespan
        self.elapsedTime = elapsedTime
        self.timeLeft = timeLeft
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(lifespan, forKey: AnyCodingKey(stringValue: "lifespan"))
        try container.encode(elapsedTime, forKey: AnyCodingKey(stringValue: "elapsedTime"))
        try container.encode(timeLeft, forKey: AnyCodingKey(stringValue: "timeLeft"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))
        entity = try container.decode(EntityWrapper.self, forKey: AnyCodingKey(stringValue: "entity"))
        lifespan = try container.decode(TimeInterval.self, forKey: AnyCodingKey(stringValue: "lifespan"))
        elapsedTime = try container.decode(TimeInterval.self, forKey: AnyCodingKey(stringValue: "elapsedTime"))
        timeLeft = try container.decode(TimeInterval.self, forKey: AnyCodingKey(stringValue: "timeLeft"))
    }

    func toComponent(entity: Entity) -> Component? {
        return Lifespan(id: id, entity: entity, lifespan: lifespan, elapsedTime: elapsedTime)
    }
}
