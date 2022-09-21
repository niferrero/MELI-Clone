//
//  APIResponseMultiget.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import Foundation
struct APIResponseMultiget: Codable {
    let body: Body
}

struct Body: Codable {
    let id: String
    let title: String
    let originalPrice: Double?
    let price: Double?
    let secureThumbnail: String
    let descriptions: [String]
    let sellerAddress: SellerAddress
    let attributes: [Attribute]?
}

struct Attribute : Codable {
    let name: String?
    let valueName: String?
}

struct SellerAddress: Codable {
    let city: City
    let state, country: Country
    let searchLocation: SearchLocation?
    let id: Int
}

struct City: Codable {
    let name: String
}

struct Country: Codable {
    let id, name: String
}

struct SearchLocation: Codable {
    let neighborhood, city, state: Country?
}

struct APIDescriptionResponse: Codable {
    let plainText : String
}
