//
//  File.swift
//  
//
//  Created by Oleksii Moisieienko on 16.04.2021.
//

import Foundation
import UIKit

public protocol ShowAlertRoute: AnyObject {
    var showAlert: ((AlertController) -> Void)! { get set }
}

public extension ShowAlertRoute where Self: UIViewController {

    func showError(error: Error) {
        let alertController = AlertController(title: NSLocalizedString("Error has occured", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
            
        }))
        showAlert(alertController)
    }
}

public class AlertController: UIAlertController {

    fileprivate var dismissed: (() -> Void)!
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissed?()
    }
}

final public class AlertCoordinator: ModalCoordinator {

    private let alertController: AlertController

    public init(alertController: AlertController, sourceViewController: UIViewController) {
        self.alertController = alertController
        super.init(sourceViewController: sourceViewController)
    }

    override public  func performStop(completionHandler: @escaping () -> Void) {
        alertController.dismiss(animated: true, completion: completionHandler)
    }

    override public  func start() {
        alertController.dismissed = { [weak self] in
            self?.removeFromParentCoordinator()
        }
        sourceViewController.present(alertController, animated: true, completion: nil)
    }
}

public extension Coordinator {

    func observeAlert(alertRoute: ShowAlertRoute, andShowIn context: UIViewController) {
        alertRoute.showAlert = { [weak self, weak context] alertController in
            guard let self = self, let context = context else {
                return
            }
            self.showAlert(alert: alertController, in: context)
        }
    }

    func showAlert(alert: AlertController, in sourceViewController: UIViewController) {
        let coordinator = AlertCoordinator(alertController: alert, sourceViewController: sourceViewController)
        addDependency(coordinator)
        coordinator.start()
    }
}
