//
//  HomeModel.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 24/01/24.
//

import SwiftUI

struct ListData: Codable,Hashable {
    var status: Bool?
    var message: String?
    var categories: [Categories]?
}

struct Categories: Codable,Hashable {
    var id: Int?
    var name: String?
    var items: [Items]?
}

struct Items: Codable,Hashable {
    var id: Int?
    var name: String?
    var icon: String?
    var price: Double?
}
