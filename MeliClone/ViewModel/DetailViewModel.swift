//
//  detailViewModel.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 20/09/2022.
//

import Foundation
class DetailViewModel {
    var description = Bindable<String>()
    var error = Bindable<CustomError>()
    var isSearching = Bindable<Bool>()
    var service: ProductMethods
    
    init(service: ProductMethods) {
        self.service = service
    }
    
    func getData(itemId: String) {
        isSearching.value = true
        service.getDescription(itemId: itemId) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.description.value = data.plainText
                    self?.isSearching.value = false
                case .failure(let error):
                    self?.isSearching.value = false
                    self?.error.value = error
            }
        }
    }
    
    func addFavorite(key: String, value: Any) {
        UDHelper.save(key: key, value: value)
    }
    
    func removeFavorite(key: String) {
        UDHelper.remove(key: key)
    }
    
    func isFavorite(key: String) -> Bool {
        return UDHelper.get(key: key) == nil
    }
}
