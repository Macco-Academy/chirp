//
//  Date+Extention.swift
//  Chirp
//
//  Created by Ady on 6/8/23.
//

import Foundation

extension Date {
  var asTimeAgo: String {
    elapsedTime(future: false)
  }

  private func elapsedTime(future: Bool = false) -> String {
    let now = Date()
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    formatter.zeroFormattingBehavior = .dropAll
    formatter.maximumUnitCount = 1 //increase it if you want more precision
    formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]

    let formatString = NSLocalizedString("%@ \(future ? "remaining" : "ago")", comment: "")
    let timeString = formatter.string(from: self, to: now)
    if let timeString = timeString, timeString == "0 seconds" {
      return "now"
    }
    return String(format: formatString, timeString ?? "").replacingOccurrences(of: "-", with: "")
  }
    
    func getCurrentTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        let timestampString = dateFormatter.string(from: self)
        return timestampString
    }
}
