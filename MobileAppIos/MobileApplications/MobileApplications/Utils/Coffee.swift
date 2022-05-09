//
//  Coffee.swift
//  MobileApplications
//
//  Created by Octavian Custura on 12.12.2021.
//

import Foundation


struct Coffee: Identifiable {
    var id = UUID()
    var cid: String?
    var title: String
    var mark: Int16
    var description: String
    var date: Date
    var recommended: Bool
    var acquiredAt: Date?
    var photo: String
    var position: Any?
}
