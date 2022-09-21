//
//  favoritesViewModel.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 20/09/2022.
//

import Foundation

class favoritesViewModel {
    var items = Bindable<[APIResponseMultiget]>()
    var error = Bindable<CustomError>()
    var isSearching = Bindable<Bool>()
    
    func getFavorites(ids: String) {
        isSearching.value = true
        ApiCaller.shared.fetch(url: "items?ids=PARAM", param: ids, model: [APIResponseMultiget].self, completion: { [weak self] result in
                switch result {
                    case .success(let data):
                        self?.items.value = data
                        self?.isSearching.value = false
                    case .failure(let error):
                        self?.isSearching.value = false
                        self?.error.value = error == .APIError ? nil : error
                }
        })
    }
}
