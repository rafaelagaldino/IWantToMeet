//
//  ViewController.swift
//  IWantToMeet
//
//  Created by Rafaela Galdino on 12/08/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tableView = UITableView()
    var places: [Place] = []
    
    let defaults = UserDefaults.standard
        
    let noPlacesLabel = UILabel()
    let footerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quero Conhecer"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        noPlacesLabel.text = "Cadastre os locais que deseja conhecer\n clicando no botão + acima"
        noPlacesLabel.textAlignment = .center
        noPlacesLabel.numberOfLines = 0
        
        loadPlaces()
        addBarButtonItem()
        addTableView()
        
        tableView.tableFooterView = footerView
    }
    
    private func loadPlaces() {
        if let placesData = defaults.data(forKey: "places") {
            do {
                places = try JSONDecoder().decode([Place].self, from: placesData)
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func savePlaces() {
        let json = try? JSONEncoder().encode(places)
        defaults.set(json, forKey: "places")
    }
    
    private func addBarButtonItem() {
        let addRightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAdd(_:)))
        navigationItem.rightBarButtonItem = addRightButton
    }

    @objc func actionAdd(_ sender: AnyObject) {
        let viewController = PlaceFinderViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }

    private func addTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func showAll() {
        let mapViewController = MapViewController()
        mapViewController.places = places
        navigationController?.pushViewController(mapViewController, animated: true)

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count > 0 {
            let btnShowAll = UIBarButtonItem(title: "Mostrar todos no mapa", style: .plain, target: self, action: #selector(showAll))
            navigationItem.leftBarButtonItem = btnShowAll
            tableView.backgroundView = nil
        } else {
            navigationItem.leftBarButtonItem = nil
            tableView.backgroundView = noPlacesLabel
        }
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.cellImage.image = UIImage(named: "cellIcon")
        cell.cellTitle.text = places[indexPath.row].name

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapViewController = MapViewController()
        mapViewController.places = [places[indexPath.row]]
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = places[indexPath.row]
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            savePlaces()
        }
    }
}

extension ViewController: PlaceFinderDelegate {
    func addPlace(_ place: Place) {
        if !places.contains(place) {
            places.append(place)
            savePlaces()
            tableView.reloadData()
        }
    }
    
    
}
