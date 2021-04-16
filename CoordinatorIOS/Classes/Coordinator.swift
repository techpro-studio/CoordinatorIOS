import Foundation


open class Coordinator: NSObject {

    public weak var parent: Coordinator?

    public var childCoordinators: [Coordinator] = []

    public final func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator {
                return
            }
        }
        coordinator.parent = self
        childCoordinators.append(coordinator)
    }

    public final func removeFromParentCoordinator() {
        parent?.removeDependency(self)
        parent = nil
    }

    public final func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }

        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    public final func stop(completionHandler: @escaping () -> Void) {
        let group = DispatchGroup()
        childCoordinators.reversed().forEach { coordinator in
            group.enter()
            coordinator.stop {[weak self] in
                guard let self = self else {
                    return
                }
                self.removeDependency(coordinator)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.performStop {
                completionHandler()
            }
        }
    }

    open func performStop(completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    open func process(action: CoordinatorAction) {
        broadcastActionToChildren(action: action)
    }

    public final func getRootCoordinator() -> Coordinator {
        var chainCoordinator = self
        while let next = chainCoordinator.parent {
            chainCoordinator = next
        }
        return chainCoordinator
    }

    public final func broadcastActionToChildren(action: CoordinatorAction) {
        for child in childCoordinators {
            child.process(action: action)
        }
    }

    open func start() {
        fatalError("abstract method. should be implemented")
    }

    deinit {
        print("DEINITED", type(of: self))
    }
}
