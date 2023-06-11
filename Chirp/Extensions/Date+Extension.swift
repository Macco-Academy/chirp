//
//  Date+Extension.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/9/23.
//

import Foundation

extension Date {
    
    func getCurrentTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        let timestampString = dateFormatter.string(from: self)
        return timestampString
    }
    
}
