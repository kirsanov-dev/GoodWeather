//
//  ViewController.swift
//  GoodWeather
//
//  Created by Oleg Kirsanov on 25.11.2022.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(for: city)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            let temperature = String(format: "%.1f", weather.temp)
            self.temperatureLabel.text = "\(temperature) ℃"
            self.humidityLabel.text = "\(weather.humidity) 💧"
        } else {
            self.temperatureLabel.text = "🙂"
            self.humidityLabel.text = "🚫"
        }
    }

    private func fetchWeather(for city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherApi(city: cityEncoded) else {
            return
        }

        let resource = Resource<WeatherResult>(url: url)

        let searchObservable = URLRequest.load(resource: resource)
            .observe(on: MainScheduler.instance)
            .retry(3) // retries to get data a number of times
            .catch { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }
            .asDriver(onErrorJustReturn: WeatherResult.empty)

        searchObservable
            .map { "\($0.main.temp) ℃" }
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)

        searchObservable
            .map{ "\($0.main.humidity) 💧" }
            .drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

