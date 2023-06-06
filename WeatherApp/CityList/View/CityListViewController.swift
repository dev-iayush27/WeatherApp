//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import UIKit
import SwiftUI

class CityListViewController: UIViewController {
    @IBOutlet private weak var cityListTableView: UITableView!
    @IBOutlet private weak var showWeatherReportButton: UIButton!
    
    private var activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private var viewModel: CityListViewModel? = CityListViewModel()
    
    private var selectedCities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Multiple Cities"
        self.view.addSubview(activityIndicatorView)
        configureTableView()
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
    
    @IBAction func showWeatherReportAction() {
        selectedCities.removeAll()
        if let selectedRows = cityListTableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let city = viewModel?.cities[indexPath.row] {
                    selectedCities.append(city)
                }
            }
        }
        callWeatherAPI()
    }
    
    private func callWeatherAPI() {
        self.activityIndicatorView.startAnimating()
        viewModel?.callWeatherForecatAPI(
            selectedCities: selectedCities
        ) { [weak self] weatherForecast, errorMessage in
            self?.activityIndicatorView.stopAnimating()
            let weatherDetailsViewModel = WeatherDetailsViewModel(weatherForecast: weatherForecast)
            let vc = UIHostingController(
                rootView: WeatherDetailsView().environmentObject(weatherDetailsViewModel)
            )
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cities.count ?? 0
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
        return 50
    }
}
