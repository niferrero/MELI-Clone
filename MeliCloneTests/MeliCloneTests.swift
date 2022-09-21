//
//  MeliCloneTests.swift
//  MeliCloneTests
//
//  Created by Nicolas Alejandro Ferrero on 21/09/2022.
//

import XCTest
@testable import MeliClone

class MeliCloneTests: XCTestCase {
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetTableDataCategory() throws {
        let service = TableService()
        let promise = expectation(description: "El servicio me debera traer los elementos para armar la tabla.")
        service.getTable(categoryName: "libro") { result in
            promise.fulfill()
            switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(let error):
                print(error.rawValue)
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testGetTableDataCategoryWithError() throws {
        let service = TableService()
        let promise = expectation(description: "El servicio debe devolverme un error de que no se encontro la categoria.")
        service.getTable(categoryName: "aaaaa") { result in
            promise.fulfill()
            switch result {
            case .success(_):
                print("")
            case .failure(let error):
                XCTAssertEqual(error, .CategoryNotFound)
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testGetFavorites() throws {
        let service = TableService()
        UDHelper.save(key: "MLA885686820", value: "MLA885686820")
        let promise = expectation(description: "El servicio debe devolverme un elemento favorito")
        service.getFavorites(ids: UDHelper.getIds()) { result in
            promise.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(data.count, 1)
            case .failure(_):
                print("")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testGetFavoritesWithError() throws {
        let service = TableService()
        let promise = expectation(description: "El servicio debe devolver un error por no encontrar al item")
        UDHelper.remove(key: "MLA885686820")
        service.getFavorites(ids: UDHelper.getIds()) { result in
            promise.fulfill()
            switch result {
            case .success(_):
                print("")
            case .failure(let error):
                XCTAssertEqual(error, .ItemNotFound)
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testDescription() throws {
        let service = ProductService()
        let promise = expectation(description: "El servicio debe devolver una descripcion")
        service.getDescription(itemId: "MLA885686820", completion: { result in
            promise.fulfill()
            switch result {
            case .success(let data):
                XCTAssertNotEqual(data.plainText, "")
            case .failure(_):
                print("")
            }
        })
            
        wait(for: [promise], timeout: 5)
    }
    
    func testDescriptionWithError() throws {
        let service = ProductService()
        let promise = expectation(description: "El servicio debe devolver un error por no encontrar la descricpion del item inexistente")
        service.getDescription(itemId: "MLA885686820a", completion: { result in
            promise.fulfill()
            switch result {
            case .success(_):
                print("")
            case .failure(let error):
                XCTAssertEqual(error, .DescriptionNotFound)
            }
        })
            
        wait(for: [promise], timeout: 5)
    }
    
    func testSaveFavoriteUD() {
        UDHelper.save(key: "MLA885686820", value: "MLA885686820")
        UDHelper.save(key: "MLA885686821", value: "MLA885686821")
        UDHelper.save(key: "MLA885686822", value: "MLA885686822")
        UDHelper.save(key: "MLA885686823", value: "MLA885686823")
        XCTAssertEqual(UDHelper.getIds().split(separator: ",").count, 4)
    }
}
