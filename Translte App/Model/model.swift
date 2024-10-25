//
//  model.swift
//  Translte App
//
//  Created by Meet Kapadiya on 24/10/24.
//

import Foundation

struct TransModel: Codable {
    let trans: Trans
}

// MARK: - Trans
struct Trans: Codable {
    let title: String
}
