//
//  AlertManager.swift
//  moon-store-mac-os
//
//  Created by Diana Zeledon on 4/12/24.
//

import AppKit

final class AlertPresenter {
    
    private init() { }
    
    static func showAlert(_ message: String, type: AlertType = .info) {
        let alert = NSAlert()
        alert.messageText = type.title
        alert.informativeText = message
        
        alert.icon = NSImage(named: type.icon)
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    static func showAlert(with error: Error) {
        var friendlyMessage: String {
            guard let msError = error as? MSError else {
                return "Algo salió mal. Por favor, intenta más tarde."
            }
            return msError.friendlyMessage
        }
        
        debugPrint("An Error occurred: \(error.localizedDescription)")
        showAlert(friendlyMessage, type: .error)
    }
    
    static func showConfirmationAlert(message: String,
                                      actionButtonTitle: String,
                                      isDestructive: Bool = false,
                                      action: Selector?) {
        let alert = NSAlert()
        
        alert.messageText = AlertType.warning.title
        alert.informativeText = message
        alert.icon = NSImage(named: AlertType.warning.icon)
        
        let button = alert.addButton(withTitle: actionButtonTitle)
        button.hasDestructiveAction = isDestructive
        button.action = action
        
        alert.addButton(withTitle: "Cancelar")
        alert.runModal()
    }
    
    static func showConfirmationAlert(message: String,
                                      actionButtonTitle: String,
                                      isDestructive: Bool = false,
                                      action: (() -> Void)? = nil) {
        let alert = NSAlert()
        
        alert.messageText = AlertType.warning.title
        alert.informativeText = message
        alert.icon = NSImage(named: AlertType.warning.icon)
        
        let button = alert.addButton(withTitle: actionButtonTitle)
        button.hasDestructiveAction = isDestructive
        
        alert.addButton(withTitle: "Cancelar")
        
        let response = alert.runModal()
        
        if response == .alertFirstButtonReturn {
            action?()
        }
    }
}
