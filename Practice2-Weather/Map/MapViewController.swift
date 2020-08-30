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
}

extension MapViewController {
    private func initialSetup() {
        view.backgroundColor = .white
        bindToViewModel()
        setupNavigationBar()
        configureMapView()
        setupMapView()
        configureMapPickView()
    }
    
    private func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            guard let self = self else { return }
            guard let cityName = self.viewModel.selectedCity else {
                self.mapView?.removeAnnotations(self.mapView?.annotations ?? [])
                self.closeMapPickView()
                return
            }
            self.mapPickView?.coordinateLabel.text = self.viewModel.selectedCoordinate?.dms
            self.mapPickView?.cityLabel.text = cityName
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = self.viewModel.selectedCoordinate!
            self.mapView!.removeAnnotations(self.mapView!.annotations)
            self.mapView!.addAnnotation(annotation)
            self.mapView!.setCenter(self.viewModel.selectedCoordinate!, animated: true)
            
            self.showMapPickView()
        }
        
        viewModel.onDidError = { [weak self] in
            guard let error = self?.viewModel.error else { return }
            self?.showError(error)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = R.string.map.navBarTitle()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: R.string.weather.backButtonTitle(), style: .plain, target: nil, action: nil)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 16.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.310066
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    private func configureMapView() {
        mapView = MKMapView()
        view.addSubview(mapView!)
        
        let coordinate = Constants.startCoordinates
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapRecognizer))
        gestureRecognizer.delegate = self
        mapView!.addGestureRecognizer(gestureRecognizer)
        mapView!.setCenter(coordinate, animated: true)
        mapView!.mapType = .mutedStandard
    }
    
    private func setupMapView() {
        mapView!.snp.makeConstraints { make in
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
        mapPickView?.snp.remakeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.bottom.equalTo(view.snp.bottom).offset(bottomConstraint)
        }
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: R.string.common.errorTitle(), message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: R.string.common.okTitle(), style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension MapViewController: UIGestureRecognizerDelegate {
    @objc func mapTapRecognizer(sender: UIGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        let coordinate = mapView!.convert(location, toCoordinateFrom: mapView)
        
        viewModel.selectedCoordinate = coordinate
        viewModel.geocodeCityFromCoordinate(coordinate: coordinate)
    }
}

extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard !text.isEmpty else { return }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
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
