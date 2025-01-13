//
//  AppTransition.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 9/12/24.
//

enum AppTransition: Hashable {
    case login
    case main(UserModel)
}
