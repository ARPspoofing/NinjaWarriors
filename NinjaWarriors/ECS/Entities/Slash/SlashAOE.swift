//
//  SlashAOE.swift
//  NinjaWarriors
//
//  Created by proglab on 23/3/24.
//

import Foundation

class SlashAOE: Entity {
    let id: EntityID
    var casterEntity: Entity

    init(id: EntityID, casterEntity: Entity) {
        self.id = id
        self.casterEntity = casterEntity
    }

    func getInitializingComponents() -> [Component] {
        return []
    }

    func deepCopy() -> Entity {
        SlashAOE(id: id, casterEntity: casterEntity.deepCopy())
    }

    func wrapper() -> EntityWrapper? {
        guard let casterEntityWrapper = casterEntity.wrapper() else {
            return nil
        }
        return SlashAOEWrapper(id: id, casterEntity: casterEntityWrapper)
    }
}
