//
//  DateExtension.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/27.
//

import Foundation

fileprivate let dateFormatter = DateFormatter()

extension String {

    func formatAsDate() -> Date? {
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
}

extension Date {

    func formatAsDefaultString() -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = .init(identifier: "zh")
        return dateFormatter.string(from: self)
    }
}
