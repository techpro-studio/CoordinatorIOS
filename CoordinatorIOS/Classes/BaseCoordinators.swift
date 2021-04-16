//
//  File.swift
//  
//
//  Created by Oleksii Moisieienko on 16.04.2021.
//

import Foundation
import UIKit

open class WindowCoordinator: Coordinator {

    public unowned let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

}

open class NavigationCoordinator: Coordinator {
    public unowned let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

open class ModalCoordinator: Coordinator, UIAdaptivePresentationControllerDelegate {

    public unowned let sourceViewController: UIViewController

    public init(sourceViewController: UIViewController) {
        self.sourceViewController = sourceViewController
    }

    // модалка может жестом закрыться, вот тот метод и обрабатывает этот кейс, тоест ь если уже ты жестом закрыл, то нужно как бы дропнуть координатор.
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        removeFromParentCoordinator()
    }

}

open class NavigationModalCoordinator: ModalCoordinator, UINavigationControllerDelegate {

    let navigationController = UINavigationController()

    override public func performStop(completionHandler: @escaping () -> Void) {
        navigationController.dismiss(animated: true, completion: completionHandler)
    }

    override init(sourceViewController: UIViewController) {
        super.init(sourceViewController: sourceViewController)
        navigationController.presentationController?.delegate = self
    }
}
