//
//  UDHelper.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 20/09/2022.
//

import Foundation
class UDHelper {
    static let defaults = UserDefaults.standard
    
    static func save(key: String, value: Any) {
        defaults.set(value, forKey: key)
    }
    
    static func remove(key: String) {
        defaults.removeObject(forKey: key)
    }
    
    static func get(key: String) -> Any? {
        return defaults.object(forKey: key)
    }
    
    static func getIds() -> String {
        var ids = ""
        defaults.dictionaryRepresentation().forEach { (key, value) in
            if key.contains("ML") { ids += "\(key)," }
        }
        return ids
    }
}
