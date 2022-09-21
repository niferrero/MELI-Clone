//
//  ApiCaller.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import Foundation

class ApiCaller {
    private static let BASE_URL = "https://api.mercadolibre.com/"
    private static let ACCESS_TOKEN = "APP_USR-6736820626071391-092114-e22d0cf6311831c42bc3de4563db89bb-113702612"
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
}
