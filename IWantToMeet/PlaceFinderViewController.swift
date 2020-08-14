//
//  MapViewController.swift
//  IWantToMeet
//
//  Created by Rafaela Galdino on 12/08/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit
import MapKit

protocol PlaceFinderDelegate: class {
    func addPlace(_ place: Place)
}

class PlaceFinderViewController: UIViewController {
    enum PlaceFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    let container = UIView()
    let closeButton = UIButton()
    let typeTheLocationLabel = UILabel()
    let touchTheMapLabel = UILabel()
    let textfield = UITextField()
    let choseButton = UIButton()
    let map = MKMapView()
    let viewLoading = UIView()
    let activeIndicator = UIActivityIndicatorView()
    
    var place: Place?
    weak var delegate: PlaceFinderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        addGesture()
        addContainer()
        addCloseButton()
        addTypeTheLocationLabel()
        addTextField()
        addChoseButton()
        addTouchTheMapLabel()
        addMapView()
        addViewLoanding()
        addActivity()
    }
    
    private func addGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        gesture.minimumPressDuration = 2.0
        map.addGestureRecognizer(gesture)
    }
    
    @objc func longPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            load(show: true)
            let point = gesture.location(in: map)
            let coordinate = map.convert(point, toCoordinateFrom: map)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                self.load(show: false)
                if error == nil {
                    if !self.savePlace(with: placemarks?.first) {
                        self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
                    }
                } else {
                    self.showMessage(type: .error("Erro desconhecido"))
                }
            }
        }
    }
    
    private func addContainer() {
        container.backgroundColor = .white
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
    }
    
    private func addCloseButton() {
        closeButton.setImage(UIImage(named: "cancel"), for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: -15).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 15).isActive = true
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    private func addTypeTheLocationLabel() {
        typeTheLocationLabel.text = "Digite o nome do local que você quer conhecer..."
        typeTheLocationLabel.textColor = .darkGray
        typeTheLocationLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        typeTheLocationLabel.numberOfLines = 0
        typeTheLocationLabel.textAlignment = .center
        container.addSubview(typeTheLocationLabel)
        typeTheLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        typeTheLocationLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        typeTheLocationLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 80).isActive = true
        typeTheLocationLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -80).isActive = true
    }
    
    private func addTextField() {
        textfield.borderStyle = .roundedRect
        container.addSubview(textfield)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.topAnchor.constraint(equalTo: typeTheLocationLabel.bottomAnchor, constant: 30).isActive = true
        textfield.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textfield.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func addChoseButton() {
        choseButton.backgroundColor = UIColor(named: "main")
        choseButton.setTitle("Escolher", for: .normal)
        choseButton.addTarget(self, action: #selector(chose), for: .touchUpInside)
        container.addSubview(choseButton)
        choseButton.translatesAutoresizingMaskIntoConstraints = false
        choseButton.topAnchor.constraint(equalTo: typeTheLocationLabel.bottomAnchor, constant: 30).isActive = true
        choseButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
        choseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        choseButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    @objc func chose() {
        textfield.resignFirstResponder()
        guard let address = textfield.text else { return }
        load(show: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { placemarks, error in
            self.load(show: false)
            if error == nil {
                if !self.savePlace(with: placemarks?.first) {
                    self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
                }
            } else {
                self.showMessage(type: .error("Erro desconhecido"))
            }
        }
    }
    
    private func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else { return false }
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = Place.getFormattedAddress(with: placemark)
        place = Place(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 3500, longitudinalMeters: 3500)
        map.setRegion(region, animated: true)
        
        showMessage(type: .confirmation(place?.name ?? ""))
        return true
        
    }
    
    private func showMessage(type: PlaceFinderMessageType) {
        let title: String, message: String
        var hasConfirmation: Bool = false
        
        switch type {
        case .confirmation(let name):
            title = "Local encontrado"
            message = "Deseja adicionar \(name)"
            hasConfirmation = true
        case .error(let errorMessage):
            title = "Erro"
            message = errorMessage
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmAction = UIAlertAction(title: "Ok", style: .default) { action in
                guard let place = self.place else { return }
                self.delegate?.addPlace(place)
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(confirmAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func load(show: Bool) {
        viewLoading.isHidden = !show
        if show {
            activeIndicator.startAnimating()
        } else {
            activeIndicator.stopAnimating()
        }
    }
    
    private func addTouchTheMapLabel() {
        touchTheMapLabel.text = "...ou escolha tocando no mapa por 2 segundos"
        touchTheMapLabel.tintColor = .darkGray
        touchTheMapLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        touchTheMapLabel.numberOfLines = 0
        touchTheMapLabel.textAlignment = .center
        container.addSubview(touchTheMapLabel)
        touchTheMapLabel.translatesAutoresizingMaskIntoConstraints = false
        touchTheMapLabel.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 30).isActive = true
        touchTheMapLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 80).isActive = true
        touchTheMapLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -80).isActive = true
    }
    
    private func addMapView() {
        container.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: touchTheMapLabel.bottomAnchor, constant: 30).isActive = true
        map.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10).isActive = true
        map.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10).isActive = true
        map.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
    }
    
    private func addViewLoanding() {
        viewLoading.isHidden = true
        viewLoading.backgroundColor = UIColor(white: 1, alpha: 0.9)
        container.addSubview(viewLoading)
        viewLoading.translatesAutoresizingMaskIntoConstraints = false
        viewLoading.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        viewLoading.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        viewLoading.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
        viewLoading.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
    }
    
    private func addActivity() {
        activeIndicator.color = UIColor(named: "main")
        activeIndicator.startAnimating()
        
        viewLoading.addSubview(activeIndicator)
        activeIndicator.translatesAutoresizingMaskIntoConstraints = false
        activeIndicator.centerXAnchor.constraint(equalTo: viewLoading.centerXAnchor).isActive = true
        activeIndicator.centerYAnchor.constraint(equalTo: viewLoading.centerYAnchor).isActive = true
    }
}
