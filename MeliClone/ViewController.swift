//
//  ViewController.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTabBarItems()
    }
    
    // MARK: - Metodos Privados
    private func setupView() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor.accentColor
        let topline = CALayer()
        topline.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 1)
        topline.backgroundColor = UIColor.lightGray.cgColor
        tabBar.layer.addSublayer(topline)
    }
    
    private func setupTabBarItems() {
        let InicioView = InicioViewController()
        let favoritosView = FavoritosViewController()
        let comprasView = UIViewController()
        let notificacionesView = UIViewController()
        let masView = MasViewController()
                
        InicioView.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house"), tag: 1)
        favoritosView.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart"), tag: 2)
        comprasView.tabBarItem = UITabBarItem(title: "Mis Compras", image: UIImage(systemName: "bag"), tag: 3)
        notificacionesView.tabBarItem = UITabBarItem(title: "Notificaciones", image: UIImage(systemName: "bell"), tag: 4)
        masView.tabBarItem = UITabBarItem(title: "Más", image: UIImage(systemName: "line.3.horizontal"), tag: 5)

        setViewControllers([InicioView, favoritosView, comprasView, notificacionesView, masView], animated: true)
    }
}

