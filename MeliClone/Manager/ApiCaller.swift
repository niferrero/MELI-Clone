//
//  ApiCaller.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import Foundation

class ApiCaller {
    private static let BASE_URL = "https://api.mercadolibre.com/"
    private static let ACCESS_TOKEN = "APP_USR-6736820626071391-092020-4ef7b2a783a15d084f180659e6a44b0f-113702612"
    static let shared = ApiCaller()
    
    private init() {}
    
    func fetch<T: Codable>(url: String, param: String, model: T.Type, completion: @escaping (Result<T, CustomError>) -> Void) {
        guard let url = URL(string: "\(ApiCaller.BASE_URL)\(generateUrl(url: url, param: param))") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(ApiCaller.ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(CustomError.APIError))
            }
        }
        task.resume()
    }
    
    private func generateUrl(url: String, param: String) -> String {
        return url.replacingOccurrences(of: "PARAM", with: param)
    }
    
    func getTable(categoryName: String, completion: @escaping (Result<[APIResponseMultiget], CustomError>) -> Void) {
        fetch(url: "sites/MLA/domain_discovery/search?limit=1&q=PARAM", param: categoryName, model: [APIResponseCategory].self) { [weak self] result in
            switch result {
                case .success(let data):
                    if data.count > 0 {
                        let categoryId = data[0].categoryId
                        self?.fetch(url: "highlights/MLA/category/PARAM", param: categoryId, model: APIResponseTopItems.self) { result in
                            switch result {
                                case .success(let data):
                                    if data.content == nil { completion(.failure(CustomError.NoItemInCategory)) }
                                    let categories = data.content?.filter({ $0.type == .item }).map({ $0.id }).joined(separator: ",")
                                    self?.fetch(url: "items?ids=PARAM", param: categories ?? "", model: [APIResponseMultiget].self, completion: { result in
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
}
