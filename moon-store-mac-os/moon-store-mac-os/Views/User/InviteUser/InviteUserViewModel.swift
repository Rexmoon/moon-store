//
//  InviteUserViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/6/25.
//

import AppKit

private enum Constants {
    static let emailSubject = "Invitación de MS Store"
    static let emailBody: String = """
    Hola!
    
    Has sido invitado a probar nuestra aplicación MS Store por Bryan Luna, un desarrollador de software en Apple.
    Para acceder a la aplicación y ver más detalles, visita:
    
    https://github.com/Rexmoon/moon-store
    """
}

final class InviteUserViewModel: ObservableObject {
    @Published var email: String = ""
    
    var cannotOpenMailApp: Bool {
        !email.matchesEmail
    }
    
    func showModalToInviteUser() {
        AlertPresenter.showConfirmationAlert(
            message: "La aplicación abrirá un correo electrónico con la invitación. Desea continuar?",
            actionButtonTitle: "Continuar",
            action: #selector(openMailApp)
        )
    }
    
    @objc
    private func openMailApp() {
        let mailtoURLString = "mailto:\(email)?subject=\(Constants.emailSubject)&body=\(Constants.emailBody)"
        
        guard let encodedURLString = mailtoURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else { return }
        NSWorkspace.shared.open(url)
    }
}
