//
//  tableService.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 21/09/2022.
//

import Foundation

protocol TableMethods {
    func getTable(categoryName: String, completion: @escaping (Result<[APIResponseMultiget], CustomError>) -> Void)
    func getFavorites(ids: String, completion: @escaping (Result<[APIResponseMultiget], CustomError>) -> Void)
}

class TableService: TableMethods {
    func getTable(categoryName: String, completion: @escaping (Result<[APIResponseMultiget], CustomError>) -> Void) {
        ApiCaller.shared.fetch(url: "sites/MLA/domain_discovery/search?limit=1&q=PARAM", param: categoryName, model: [APIResponseCategory].self) { result in
            switch result {
                case .success(let data):
                    if data.count > 0 {
                        let categoryId = data[0].categoryId
                        ApiCaller.shared.fetch(url: "highlights/MLA/category/PARAM", param: categoryId, model: APIResponseTopItems.self) { result in
                            switch result {
                                case .success(let data):
                                    if data.content == nil { completion(.failure(CustomError.NoItemInCategory)) }
                                    let categories = data.content?.filter({ $0.type == .item }).map({ $0.id }).joined(separator: ",")
                                ApiCaller.shared.fetch(url: "items?ids=PARAM", param: categories ?? "", model: [APIResponseMultiget].self, completion: { result in
                                        switch result {
                                            case .success(let data):
                                                completion(.success(data))
                                        case .failure(_):
                                            completion(.failure(CustomError.ItemNotFound))
                                        }
                                    })
                            case .failure(_):
                                completion(.failure(CustomError.NoItemInCategory))
                            }
                        }
                    } else {
                        completion(.failure(CustomError.CategoryNotFound))
                    }
            case .failure(_):
                    completion(.failure(CustomError.CategoryNotFound))
            }
        }
    }
    
    func getFavorites(ids: String, completion: @escaping (Result<[APIResponseMultiget], CustomError>) -> Void) {
        ApiCaller.shared.fetch(url: "items?ids=PARAM", param: ids, model: [APIResponseMultiget].self) { result in
            switch result {
                case.success(let data):
                    completion(.success(data))
                case .failure(_):
                    completion(.failure(CustomError.ItemNotFound))
            }
        }
    }
}
