//
//  File.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 07/12/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TCDate {
    
    public static func formatTimestamp(
        from timestamp: Timestamp
    ) -> String {
        let currentDate = Date()
        let postDate = timestamp.dateValue()
        
        let components = Calendar.current.dateComponents(
            [.minute, .hour, .day, .weekOfYear],
            from: postDate,
            to: currentDate
        )
        
        if let week = components.weekOfYear, week > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: postDate)
        } else if let day = components.day, day > 0 {
            return "\(day)d"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m"
        } else {
            return "now"
        }
    }
    
}
