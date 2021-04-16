//
//  File.swift
//  
//
//  Created by Oleksii Moisieienko on 16.04.2021.
//

import Foundation
import UIKit

public final class ShareCoordinator: ModalCoordinator {

    private let transparentController: UIViewController = {
        let controller = UIViewController()
        controller.view.isOpaque = true
        controller.view.backgroundColor = .clear
        controller.modalPresentationStyle = .overCurrentContext
        return controller
    }()

    private let activityItems: [Any]

    public unowned let anchorView: UIView

    public init(sourceViewController: UIViewController, activityItems: [Any], anchorView: UIView) {
        self.anchorView = anchorView
        self.activityItems = activityItems
        super.init(sourceViewController: sourceViewController)
    }

    override public func start() {
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.completionWithItemsHandler = {[weak self](_,_,_,_) in
            if let presented = self?.transparentController.presentingViewController {
                presented.dismiss(animated: true) {
                    self?.removeFromParentCoordinator()
                }
            } else {
                self?.transparentController.dismiss(animated: true) {
                    self?.removeFromParentCoordinator()
                }
            }
        }
        if let popoverController = activityController.popoverPresentationController  {
            popoverController.sourceView = anchorView;
        }
        sourceViewController.present(transparentController, animated: false) {[weak transparentController] in
            transparentController?.present(activityController, animated: true, completion: nil)
        }
    }

}
public protocol ShareCoordinatorParent {

}

public extension ShareCoordinatorParent where Self: Coordinator {
    func share(items: [Any], in vc: UIViewController) {
        let coordinator = ShareCoordinator(sourceViewController: vc, activityItems: items, anchorView: vc.view)
        coordinator.start()
        addDependency(coordinator)
    }
}
