//
//  APIResponseTopItems.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import Foundation
struct APIResponseTopItems: Codable {
    var content: [Content]?
}

struct Content: Codable {
    let id: String
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case item = "ITEM"
    case product = "PRODUCT"
}
