//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import UIKit
import SwiftUI
import CoreLocation

class CityListViewController: UIViewController {
    @IBOutlet private weak var cityListTableView: UITableView!
    @IBOutlet private weak var showWeatherReportButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var currentLocationWeatherView: UIView!
    @IBOutlet private weak var weatherViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var currentCity: UILabel!
    @IBOutlet private weak var currentCityTemp: UILabel!
    @IBOutlet private weak var currentCityTempStatus: UILabel!
    @IBOutlet private weak var currentCityHighAndLowTemp: UILabel!
    
    private var viewModel: CityListViewModel? = CityListViewModel()
    
    private var selectedCities: [City] = []
    
    private var locationManager: CLLocationManager?
    private var coordinates = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel?.title
        self.currentLocationWeatherView.isHidden = true
        self.weatherViewHeight.constant = 0
        
        setUpLocationManager()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        currentLocationWeatherView.layer.cornerRadius = 10
        currentLocationWeatherView.clipsToBounds = true
    }
    
    private func setUpLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestAlwaysAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.startUpdatingLocation()
            }
        }
    }
    
    private func updateCurrentLocationWeatherView(weather: WeatherForecast?) {
        if let weatherinfo = weather {
            DispatchQueue.main.async {
                self.currentLocationWeatherView.isHidden = false
                self.weatherViewHeight.constant = 150
                self.currentCity.text = weatherinfo.city.name
                
                let temp = "\(String(Int(weather?.list.first?.main.temp ?? 0.0)))°C"
                self.currentCityTemp.text = temp
                
                let status = weather?.list.first?.weather.first?.description.uppercased() ?? ""
                self.currentCityTempStatus.text = status
                
                let highTemp = "H \(String(Int(weather?.list.first?.main.tempMax ?? 0.0)))°C"
                let lowTemp = "L \(String(Int(weather?.list.first?.main.tempMin ?? 0.0)))°C"
                self.currentCityHighAndLowTemp.text = highTemp + "   " + lowTemp
            }
        }
    }
    
    private func configureTableView() {
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(
            UINib(nibName: "CityListTVCellTableViewCell", bundle: nil),
            forCellReuseIdentifier: "CityListTVCellTableViewCell"
        )
        cityListTableView.reloadData()
    }
    
    private func callWeatherAPIForCurrentLocation() {
        self.showSpinner()
        viewModel?.callWeatherAPIForCurrentLocation(
            coordinates: self.coordinates
        ) { [weak self] weather, errorMessage in
            
            self?.hideSpinner()
            
            if errorMessage != "" {
                self?.showAlert(title: "Something Went Wrong", message: errorMessage)
                return
            }
            
            guard weather != nil else {
                self?.showAlert(title: "Something Went Wrong", message: "Please try again later.")
                return
            }
            
            self?.updateCurrentLocationWeatherView(weather: weather)
        }
    }
    
    private func callWeatherForecastAPI() {
        self.showSpinner()
        viewModel?.callWeatherForecatAPI(
            selectedCities: selectedCities
        ) { [weak self] weatherForecast, errorMessage in
            
            self?.hideSpinner()
            
            if errorMessage != "" {
                self?.showAlert(title: "Something Went Wrong", message: errorMessage)
                return
            }
            
            guard !weatherForecast.isEmpty else {
                self?.showAlert(title: "Something Went Wrong", message: "Please try again later.")
                return
            }
            
            let weatherDetailsViewModel = WeatherDetailsViewModel(weatherForecast: weatherForecast)
            let vc = UIHostingController(
                rootView: WeatherDetailsView().environmentObject(weatherDetailsViewModel)
            )
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func showWeatherReportAction() {
        selectedCities.removeAll()
        if let selectedRows = cityListTableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let city = viewModel?.cities[indexPath.row] {
                    selectedCities.append(city)
                }
            }
        }
        guard !selectedCities.isEmpty else {
            showAlert(title: "Warning", message: "Please select cities to see weather report.")
            return
        }
        callWeatherForecastAPI()
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.citiesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTVCellTableViewCell", for: indexPath) as! CityListTVCellTableViewCell
        cell.cityName.text = viewModel?.cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityListTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        cityListTableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension CityListViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    private func hideSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}

extension CityListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationvalue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        self.coordinates = locationvalue
        
        self.callWeatherAPIForCurrentLocation()
    }
}
