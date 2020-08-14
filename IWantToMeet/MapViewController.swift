//
//  MapViewController.swift
//  IWantToMeet
//
//  Created by Rafaela Galdino on 12/08/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let container = UIView()
    let searchBar = UISearchBar()
    let map = MKMapView()
    let infoView = UIView()
    var places: [Place]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "TO DO"
        view.backgroundColor = .white
        
        map.delegate = self
        
        if places?.count == 1 {
            title = places?[0].name
        } else {
            title = "Meus lugares"
        }
        
        if let places = places {
            for place in places {
                addToMap(place)
            }
        }
        
        addContainer()
        addSeachBar()
        addMap()
        addInfoView()
        addElemtensInfoView()
        showPlaces()
    }
    
    func addToMap(_ place: Place) {
        let annotation = PlaceAnnotation(coordinate: place.coordinate, placeType: .place)
        annotation.title = place.name
        annotation.address = place.address
        map.addAnnotation(annotation)
    }
    
    func showPlaces() {
        map.showAnnotations(map.annotations, animated: true)
    }
    
    private func addContainer() {
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func addSeachBar() {
        searchBar.placeholder = "O que você deseja buscar?"
        container.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
    }
    
    private func addMap() {
        container.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        map.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        map.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true

    }
    
    private func addInfoView() {
        infoView.backgroundColor = .white
        container.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: map.bottomAnchor, constant: 0).isActive = true
        infoView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        infoView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
        infoView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }

    private func addElemtensInfoView() {
        let name = UILabel()
        let address = UILabel()
        let plotRoute = UIButton()

        name.text = "Nome"
        name.textColor = .black
        name.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        infoView.addSubview(name)
        
        address.text = "Endereço"
        address.font = UIFont.systemFont(ofSize: 15, weight: .light)
        address.numberOfLines = 0
        infoView.addSubview(address)
        
        plotRoute.setTitle("Traçar Rota", for: .normal)
        plotRoute.setTitleColor(.black, for: .normal)
        plotRoute.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        infoView.addSubview(plotRoute)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10.0).isActive = true
        name.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 12.0).isActive = true
        name.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -12.0).isActive = true
        
        address.translatesAutoresizingMaskIntoConstraints = false
        address.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10.0).isActive = true
        address.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 12.0).isActive = true
        address.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -12.0).isActive = true
        
        plotRoute.translatesAutoresizingMaskIntoConstraints = false
        plotRoute.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 12.0).isActive = true
        plotRoute.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -12.0).isActive = true
        plotRoute.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -12.0).isActive = true
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // TO DO
        return nil
    }
}
