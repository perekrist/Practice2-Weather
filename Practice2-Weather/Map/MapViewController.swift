//
//  MapViewController.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 30.07.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    
    private let viewModel: MapViewModel
    
    private var mapView: MKMapView?
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

extension MapViewController {
    
    private func initialSetup() {
        view.backgroundColor = .white
        mapView = MKMapView()
        view.addSubview(mapView!)
        setupNavigationBar()
        setupMapView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = "Global Weather"
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    private func setupMapView() {
        mapView!.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.topMargin)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    
}


