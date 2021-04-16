//
//  File.swift
//  
//
//  Created by Oleksii Moisieienko on 16.04.2021.
//

import Foundation
import MessageUI


public protocol MailCoordinatorParent {
    
}

public struct EmailInfo {
    let address: String
    let subject : String?
}



public final class MailCoordinator: ModalCoordinator, MFMailComposeViewControllerDelegate {

    private var presentedController: UIViewController!

    private let email: String
    private let subject: String?

    public init(sourceViewController: UIViewController, emailInfo: EmailInfo) {
        self.email = emailInfo.address
        self.subject = emailInfo.subject
        super.init(sourceViewController: sourceViewController)
    }

    override public func performStop(completionHandler: @escaping () -> Void) {
        presentedController?.dismiss(animated: true, completion: completionHandler)
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        stop {[weak self] in
            self?.removeFromParentCoordinator()
        }
    }

    override public func start() {
        if !MFMailComposeViewController.canSendMail() {
            let alertController = UIAlertController(title: NSLocalizedString("Configure your email", comment: ""), message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: { [weak self]_ in
                self?.removeFromParentCoordinator()
            }))
            presentedController = alertController
            sourceViewController.present(alertController, animated: true, completion: nil)
            return
        }
        let mailController = MFMailComposeViewController()
        mailController.setToRecipients([email])
        if let subject = subject {
            mailController.setSubject(subject)
        }
        mailController.mailComposeDelegate = self
        presentedController = mailController
        sourceViewController.present(mailController, animated: true, completion: nil)
    }

}

public extension MailCoordinatorParent where Self: Coordinator {
    func sendEmail(emailInfo: EmailInfo, in context: UIViewController) {
        let coordinator = MailCoordinator(sourceViewController: context, emailInfo: emailInfo)
        addDependency(coordinator)
        coordinator.start()
    }
}
