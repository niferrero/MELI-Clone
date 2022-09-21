//
//  BindableClass.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 20/09/2022.
//

import Foundation
class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
