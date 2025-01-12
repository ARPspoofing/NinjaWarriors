//
//  Obstacle.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

class Obstacle: Equatable, Entity {
    let id: EntityID
    var initializePosition: Point = Point(xCoord: 400, yCoord: 400)

    init(id: EntityID) {
        self.id = id
    }

    convenience init(id: EntityID, position: Point) {
        self.init(id: id)
        self.initializePosition = position
    }

    func getInitializingComponents() -> [Component] {
        let position = initializePosition

        let shape: Shape = CircleShape(center: position, radius: Constants.defaultSize)
        let mass = 8.0
        let width = 50.0
        let height = 50.0
        let image = "rock"

        let collider = Collider(id: RandomNonce().randomNonceString(), entity: self,
                                colliderShape: shape, isColliding: false, isOutOfBounds: false)

        let rigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: self, angularDrag: .zero,
                                  angularVelocity: .zero, mass: mass, rotation: .zero, totalForce: Vector.zero,
                                  inertia: .zero, position: shape.center, velocity: Vector.zero,
                                  attachedCollider: collider)

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(),
                                     entity: self, image: image, width: width,
                                     height: height, health: 10, maxHealth: 100)
        
        let health = Health(id: RandomNonce().randomNonceString(), entity: self,
                                entityInflictDamageMap: [:], health: 100, maxHealth: 100)

        return [collider, rigidbody, spriteComponent, health]
    }

    func deepCopy() -> Entity {
        Obstacle(id: id)
    }

    func wrapper() -> EntityWrapper? {
        ObstacleWrapper(id: id)
    }

    static func == (lhs: Obstacle, rhs: Obstacle) -> Bool {
        lhs.id == rhs.id
    }
}
