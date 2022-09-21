//
//  ProductService.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 21/09/2022.
//

import Foundation

protocol ProductMethods {
    func getDescription(itemId: String, completion: @escaping (Result<APIDescriptionResponse, CustomError>) -> Void)
}

class ProductService: ProductMethods {
    func getDescription(itemId: String, completion: @escaping (Result<APIDescriptionResponse, CustomError>) -> Void) {
        ApiCaller.shared.fetch(url: "items/PARAM/description", param: itemId, model: APIDescriptionResponse.self) { result in
            switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    completion(.failure(.DescriptionNotFound))
            }
        }
    }
}
