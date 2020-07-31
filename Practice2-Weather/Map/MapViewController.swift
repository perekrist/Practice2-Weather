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
    private var mapPickView: MapPickView?
    
    var timer: Timer?
    
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
        bindToViewModel()
        setupNavigationBar()
        configureMapView()
        setupMapView()
        configureMapPickView()
        setupMapPickView(bottomConstraint: 170)
    }
    
    private func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            guard let cityName = self?.viewModel.selectedCity else {
                self?.closeMapPickView()
                return
            }
            self?.mapPickView?.coordinateLabel.text = "\(String((self?.viewModel.selectedCoordinate?.latitude.description) ?? "-")) \(String( (self?.viewModel.selectedCoordinate?.longitude.description) ?? "-"))"
            self?.mapPickView?.cityLabel.text = cityName
            
            guard let isOpened = self?.mapPickView?.viewModel?.isOpened else { return }
            if isOpened {
                self?.closeMapPickView()
            } else {
                self?.showMapPickView()
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = "Global Weather"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func configureMapView() {
        mapView = MKMapView()
        view.addSubview(mapView!)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapRecognizer))
        gestureRecognizer.delegate = self
        mapView!.addGestureRecognizer(gestureRecognizer)
        mapView!.setCenter(CLLocationCoordinate2D(latitude: 45.16447, longitude: 9.43332), animated: true)
        mapView!.mapType = .mutedStandard
    }
    
    private func setupMapView() {
        mapView!.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.topMargin)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func configureMapPickView() {
        mapPickView = MapPickView()
        let mapPickViewModel = MapPickViewModel(delegate: viewModel)
        mapPickView!.setup(with: mapPickViewModel)
        view.addSubview(mapPickView!)
    }
    
    private func setupMapPickView(bottomConstraint: Int) {
        mapPickView?.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.bottom.equalTo(view.snp.bottom).offset(bottomConstraint)
        }
    }
    
}

extension MapViewController: UIGestureRecognizerDelegate {
    @objc func mapTapRecognizer(sender: UIGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        let coordinate = mapView!.convert(location, toCoordinateFrom: mapView)
        
        viewModel.geocodeCityFromCoordinate(coordinate: coordinate)
    }
}

extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard !text.isEmpty else { return }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            self.viewModel.geocodeCoordinateFromCity(city: text)
        })
    }
}

extension MapViewController {
    private func showMapPickView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.setupMapPickView(bottomConstraint: -16)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func closeMapPickView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.setupMapPickView(bottomConstraint: 170)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
