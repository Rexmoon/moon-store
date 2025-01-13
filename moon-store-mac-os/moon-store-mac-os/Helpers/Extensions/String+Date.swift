//
//  String+Date.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 3/1/25.
//

import Foundation

private enum Constants {
    static let apiDateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let eSIdentifier: String = "es_ES"
    static let uSIdentifier: String = "en_US_POSIX"
    static let spanishFormat: String = "EE, d MMM, yyyy"
    static let weekDayFormat: String = "EEEE"
}

extension String {
    
    /// Formats an ISO 8601 date string (`yyyy-MM-dd'T'HH:mm:ss.SSSZ`)
    /// into a readable Spanish format (`MMMM d yyyy`).
    /// Returns "nil" if the input is not a valid date.
    var formattedDate: String? {
        let dateFormatter = dateFormatter(for: Constants.apiDateFormat,
                                          with: Constants.uSIdentifier)
        
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = Constants.spanishFormat
        dateFormatter.locale = Locale(identifier: Constants.eSIdentifier)
        
        let stringFormattedDate = dateFormatter.string(from: date)
        
        return stringFormattedDate.capitalized
    }
    
    var weekday: String? {
        let apiDateFormatter = dateFormatter(for: Constants.apiDateFormat)
        
        let weekDateFormatter = dateFormatter(for: Constants.weekDayFormat,
                                                with: Constants.eSIdentifier)
        
        guard let apiDateFormatted = apiDateFormatter.date(from: self) else { return nil }
        
        return weekDateFormatter.string(from: apiDateFormatted).capitalized
    }
    
    private func dateFormatter(for format: String,
                               with identifier: String? = nil) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let identifier {
            dateFormatter.locale = Locale(identifier: identifier)
        }
        
        return dateFormatter
    }
}
