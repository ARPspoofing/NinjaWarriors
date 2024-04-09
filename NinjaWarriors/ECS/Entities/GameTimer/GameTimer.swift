//
//  GameTimer.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation

class GameTimer: Equatable, Entity {
    let id: EntityID
    let totalLife: TimeInterval = 60.0

    init(id: EntityID) {
        self.id = id
    }

    func getInitializingComponents() -> [Component] {
        let lifespan = Lifespan(id: RandomNonce().randomNonceString(), entity: self, lifespan: totalLife)
        return [lifespan]
    }

    func deepCopy() -> Entity {
        GameTimer(id: id)
    }

    func wrapper() -> EntityWrapper? {
        GameTimerWrapper(id: id)
    }

    static func == (lhs: GameTimer, rhs: GameTimer) -> Bool {
        lhs.id == rhs.id
    }
}
