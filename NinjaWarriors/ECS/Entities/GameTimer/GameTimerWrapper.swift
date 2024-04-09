//
//  GameTimerWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation

class GameTimerWrapper: EntityWrapper {

    override init(id: EntityID) {
        super.init(id: id)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        return GameTimer(id: id)
    }
}
