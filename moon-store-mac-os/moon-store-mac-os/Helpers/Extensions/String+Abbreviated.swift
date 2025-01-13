//
//  String+Abbreviated.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 5/1/25.
//

import Foundation

extension String {
    var abbreviated: String {
        let formatter = PersonNameComponentsFormatter()
        
        guard let components = formatter.personNameComponents(from: self) else { return "" }
        formatter.style = .abbreviated
        return formatter.string(from: components)
    }
}
