//
//  ProfileView.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 5/1/25.
//

import SwiftUI

private enum Constants {
    static let cardCornerRadius: CGFloat = 10
    static let circleStrokeWidth: CGFloat = 5
    static let circlePadding: CGFloat = 25
    static let circleFontSize: CGFloat = 80
    static let circleFontWeight: Font.Weight = .black
    static let textPadding: CGFloat = 5
    static let capsuleHeight: CGFloat = 30
    static let hStackSpacing: CGFloat = 20
    static let vStackSpacing: CGFloat = 20
    static let sectionSpacing: CGFloat = 10
    static let overlayPadding: CGFloat = 10
}

struct ProfileView: View {
    @ObservedObject private var  viewModel: ProfileViewModel = .init()
    
    private let user: UserModel

    init(user: UserModel) {
        self.user = user
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Constants.hStackSpacing) {
            basicInformationCard
            
            VStack(spacing: Constants.vStackSpacing) {
                historyInformation
                updatePassword
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .showSpinner($viewModel.isLoading)
    }
    
    private var fullName: String {
        "\(user.firstName) \(user.lastName)"
    }
    
    // MARK: - Card Container View
    
    private func cardContainer<Content: View>(title: String,
                                              @ViewBuilder _ content: () -> Content) -> some View {
        VStack(spacing: Constants.sectionSpacing) {
            Text(title)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding(Constants.textPadding)
                .background(.msPrimary)
                .foregroundStyle(.msWhite)
            
            content()
        }
        .padding(.bottom)
        .background(.msWhite, in: RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
        .foregroundStyle(.msDarkBlue)
    }
    
    // MARK: - Update Password View
    
    private var updatePassword: some View {
        cardContainer(title: "Actualizar Contraseña") {
            Group {
                MSTextField(title: "Contraseña Actual", text: $viewModel.currentPassword, isSecure: true)
                MSTextField(title: "Nueva Contraseña", text: $viewModel.newPassword, isSecure: true)
                MSTextField(title: "Confirmar Contraseña", text: $viewModel.confirmPassword, isSecure: true)
                
                PrimaryButton("Actualizar") {
                    viewModel.updatePassword(with: user.email)
                }
                .disabled(viewModel.cannotUpdatePassword)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - History Information
    
    private var historyInformation: some View {
        cardContainer(title: "Historial") {
            Text("Creado: ").font(.headline) + Text(user.createdAt.formattedDate ?? "")
            Text("Actualizado: ").font(.headline) + Text(user.updatedAt?.formattedDate ?? "-")
        }
    }
    
    // MARK: - Contact Information View
    
    private var basicInformationCard: some View {
        VStack(spacing: Constants.sectionSpacing) {
            userProfileImage
            
            Text(fullName)
                .font(.title2)
                .frame(height: Constants.capsuleHeight)
                .padding(.horizontal)
                .background(.msPrimary, in: Capsule())
            
            contactInformation
        }
        .padding()
        .background(.msWhite, in: RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
        .foregroundStyle(.msWhite)
        .overlay(alignment: .topTrailing) {
            Text(user.roles.first?.name.capitalized ?? "")
                .foregroundStyle(.msDarkGray)
                .padding(Constants.overlayPadding)
        }
    }
    
    // MARK: - User Profile Image View
    
    private var userProfileImage: some View {
        Text(fullName.abbreviated)
            .font(.system(size: Constants.circleFontSize))
            .fontWeight(Constants.circleFontWeight)
            .padding(Constants.circlePadding)
            .background(.msPrimary, in: Circle())
            .overlay {
                Circle()
                    .stroke(.msGray, lineWidth: Constants.circleStrokeWidth)
            }
            .padding(.bottom)
    }
    
    // MARK: - Contact Information View
    
    private var contactInformation: some View {
        VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
            HStack(spacing: Constants.hStackSpacing) {
                Label(user.identification, systemImage: "person.text.rectangle.fill")
                Label(user.phone, systemImage: "phone.fill")
            }
            
            Label(user.email, systemImage: "envelope.fill")
            Label(user.address, systemImage: "location.fill")
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius).stroke(.msGray)
        }
        .foregroundStyle(.msDarkGray)
    }
}
