import Foundation

public enum Physics {
    public static func initialize() {
        PhysicsBridge.initializePhysics()
    }

    public static func step(dt: Float) {
        PhysicsBridge.stepSimulation(dt)
    }

    public static func shutdown() {
        PhysicsBridge.shutdownPhysics()
    }
}
