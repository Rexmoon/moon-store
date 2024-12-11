//
//  Data+String.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 12/8/24.
//

import Foundation

extension Data {
    mutating func appendStringIfNeeded(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            debugPrint("Could not convert \(string) to UTF8")
            return
        }
        append(data)
    }
}
