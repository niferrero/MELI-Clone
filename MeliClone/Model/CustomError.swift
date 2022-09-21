//
//  CustomError.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import Foundation
enum CustomError: String, Error {
    case NoItemInCategory = "No hay elementos en la categoria buscada"
    case CategoryNotFound = "No se encontró la categoria deseada"
    case ItemNotFound = "El item solicitado no se pudo encontrar"
    case APIError = "Ocurrio un error en una peticion"
}
