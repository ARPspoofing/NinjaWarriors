//
//  Rigidbody.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

// https://docs.unity3d.com/ScriptReference/Rigidbody2D.html
class Rigidbody: Component {
    var angularDrag: Double
    var angularVelocity: Double
    var mass: Double
    var rotation: Double
    var totalForce: Double
    var gravityScale: Double
    var gravity: Double
    var inertia: Double
    var attachedColliderCount: Int
    var collisionDetectionMode: Bool
    var position: Point
    var velocity: Vector
    var attachedColliders: [Collider]

    override func wrapper() -> ComponentWrapper? {
        guard let entity = entity?.wrapper() else {
            return nil
        }

        var wrapColliders: [ColliderWrapper] = []

        for collider in attachedColliders {
            if let colliderWrap = collider.wrapper() as? ColliderWrapper {
                wrapColliders.append(colliderWrap)
            }
        }

        return RigidbodyWrapper(id: id, entity: entity, angularDrag: angularDrag, angularVelocity: angularVelocity, mass: mass, rotation: rotation, totalForce: totalForce, gravityScale: gravityScale, gravity: gravity, inertia: inertia, attachedColliderCount: attachedColliderCount, collisionDetectionMode: collisionDetectionMode, position: position.toPointWrapper(), velocity: velocity.toVectorWrapper(), attachedColliders: wrapColliders)

    }

    init(id: EntityID, entity: Entity, angularDrag: Double, angularVelocity: Double, mass: Double,
         rotation: Double, totalForce: Double, gravityScale: Double, gravity: Double, inertia: Double,
         attachedColliderCount: Int, collisionDetectionMode: Bool, position: Point, velocity: Vector,
         attachedColliders: [Collider]) {
        self.angularDrag = angularDrag
        self.angularVelocity = angularVelocity
        self.mass = mass
        self.rotation = rotation
        self.totalForce = totalForce
        self.gravityScale = gravityScale
        self.gravity = gravity
        self.inertia = inertia
        self.attachedColliderCount = attachedColliderCount
        self.collisionDetectionMode = collisionDetectionMode
        self.position = position
        self.velocity = velocity
        self.attachedColliders = attachedColliders

        super.init(id: id, entity: entity)
    }

    func addForce(_ force: Double) {
        totalForce += force
    }

    func addCollider(_ collider: Collider) {
        attachedColliders.append(collider)
    }

    func isAwake() -> Bool {
        collisionDetectionMode
    }

    func isSleeping() -> Bool {
        !collisionDetectionMode
    }

    func sleep() {
        collisionDetectionMode = false
    }

    func wakeUp() {
        collisionDetectionMode = true
    }

    func movePosition(to position: Point) {
        self.position = position
    }

    func moveRotation(to rotation: Double) {
        self.rotation = rotation
    }

    func getShape() -> Shape? {
        entity?.shape
    }

    func minDistancePoint() -> (Double, Point?) {
        var minDistance = Double.greatestFiniteMagnitude
        var closestPoint: Point?
        for collider in attachedColliders {
            let distance = position.distance(to: collider.getPosition())
            if distance < minDistance {
                minDistance = distance
                closestPoint = collider.getPosition()
            }
        }
        return (minDistance, closestPoint)
    }

    func minDistance() -> Double {
        let (minDistance, _) = minDistancePoint()
        return minDistance
    }

    func closestPoint() -> Point? {
        let (_, closestPoint) = minDistancePoint()
        return closestPoint
    }
}
