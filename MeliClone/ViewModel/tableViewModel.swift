//
//  tableViewModel.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import Foundation

class tableViewModel {
    var items = Bindable<[APIResponseMultiget]>()
    var error = Bindable<CustomError>()
    var isSearching = Bindable<Bool>()
    
    func getData(category: String) {
        isSearching.value = true
        ApiCaller.shared.getTable(categoryName: category) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.items.value = data
                    self?.isSearching.value = false
                case .failure(let error):
                    self?.isSearching.value = false 
                    self?.error.value = error
            }
        }
    }
}
