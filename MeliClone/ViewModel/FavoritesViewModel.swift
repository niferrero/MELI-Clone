//
//  favoritesViewModel.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 20/09/2022.
//

import Foundation

class FavoritesViewModel {
    var items = Bindable<[APIResponseMultiget]>()
    var error = Bindable<CustomError>()
    var isSearching = Bindable<Bool>()
    var service: TableMethods
    
    init(service: TableMethods) {
        self.service = service
    }
    
    func getFavorites(ids: String) {
        isSearching.value = true
        service.getFavorites(ids: ids) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.items.value = data
                    self?.isSearching.value = false
                case .failure(let error):
                    self?.isSearching.value = false
                    self?.error.value = error == .ItemNotFound ? nil : error
            }
        }
    }
}
