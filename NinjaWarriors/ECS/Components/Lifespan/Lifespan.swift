//
//  Lifespan.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

class Lifespan: Component {
    var lifespan: TimeInterval
    var elapsedTime: TimeInterval
    var timeLeft: TimeInterval

    init(id: ComponentID, entity: Entity, lifespan: TimeInterval, elapsedTime: TimeInterval = 0) {
        self.lifespan = lifespan
        self.elapsedTime = elapsedTime
        timeLeft = lifespan
        super.init(id: id, entity: entity)
    }

    func getTimeLeft() -> TimeInterval {
        timeLeft = lifespan - elapsedTime
        return timeLeft
    }

    override func updateAttributes(_ newLifespan: Component) {
        guard let newLifespan = newLifespan as? Lifespan else {
            return
        }
        self.lifespan = newLifespan.lifespan
        self.elapsedTime = newLifespan.elapsedTime
        self.timeLeft = newLifespan.timeLeft
    }

    override func changeEntity(to entity: Entity) -> Component {
        Lifespan(id: self.id, entity: entity, lifespan: self.lifespan,
                 elapsedTime: self.elapsedTime)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return LifespanWrapper(id: id, entity: entityWrapper, lifespan: self.lifespan,
                               elapsedTime: self.elapsedTime, timeLeft: self.timeLeft)
    }
}
