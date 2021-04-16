//
//  File.swift
//  
//
//  Created by Oleksii Moisieienko on 16.04.2021.
//

import Foundation
import UIKit
import SafariServices

public protocol OpenSafariURLRoute: AnyObject {
    var openSafariURL: ((URL) -> Void)! { get set }
}

// For opening any URL in Safari

public final class SafariURLCoordinator: ModalCoordinator, SFSafariViewControllerDelegate  {

    private var presentedController: UIViewController!

    private let url: URL

    public init(sourceViewController: UIViewController, url: URL) {
        self.url = url
        super.init(sourceViewController: sourceViewController)
    }

    override public  func performStop(completionHandler: @escaping () -> Void) {
        presentedController?.dismiss(animated: true, completion: completionHandler)
    }

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        stop {[weak self] in
            self?.removeFromParentCoordinator()
        }
    }

    override public func start() {
        let safariController = SFSafariViewController(url: url)
        safariController.modalPresentationStyle = .overFullScreen
        if #available(iOS 10.0, *) {
            safariController.preferredBarTintColor =  .black
        }
        if #available(iOS 11.0, *) {
            safariController.dismissButtonStyle = .close
        }
        safariController.delegate = self
        presentedController = safariController
        sourceViewController.present(safariController, animated: true, completion: nil)
    }

}

public extension Coordinator {

    func observeSafariURL(safariRoute: OpenSafariURLRoute, andShowIn context: UIViewController) {
        safariRoute.openSafariURL = { [weak self, weak context] url in
            guard let self = self, let context = context else {
                return
            }
            self.showURLInSafari(url: url, in: context)
        }
    }

    func showURLInSafari(url: URL, in sourceViewController: UIViewController) {
        let coordinator = SafariURLCoordinator(sourceViewController: sourceViewController, url: url)
        addDependency(coordinator)
        coordinator.start()
    }
}
