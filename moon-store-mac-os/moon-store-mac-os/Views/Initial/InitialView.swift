//
//  InitialView.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 18/12/24.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            router.associatedView
                .navigationDestination(for: AppTransition.self) { route in
                    router.build(for: route)
                }
        }
    }
}
