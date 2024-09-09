//
//  Item.swift
//  shortsSummary
//
//  Created by 김이예은 on 9/10/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
