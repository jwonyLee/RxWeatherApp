//
//  MainViewController.swift
//  RxWeatherApp
//
//  Created by 이지원 on 2021/04/28.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!

    // MARK: - Properties
    private let viewModel = MainViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
    }

    private func bindUI() {
        viewModel.weatherObservable
            .map { $0.city }
            .asDriver(onErrorJustReturn: "-")
            .drive(cityLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.weatherObservable
            .map { $0.status }
            .asDriver(onErrorJustReturn: "-")
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.weatherObservable
            .map { $0.icon }
            .flatMap { OpenWeatherService.fetchIcon($0) }
            .asDriver(onErrorJustReturn: UIImage(named: "sun.max"))
            .drive(iconImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.weatherObservable
            .map { "\($0.temp)°C" }
            .asDriver(onErrorJustReturn: "17")
            .drive(temperatureLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.weatherObservable
            .map { "\($0.windSpeed)m/s" }
            .asDriver(onErrorJustReturn: "0")
            .drive(windLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.weatherObservable
            .map { "\($0.humidity)%" }
            .asDriver(onErrorJustReturn: "0")
            .drive(waterLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.weatherObservable
            .map { "\($0.cloud)%" }
            .asDriver(onErrorJustReturn: "0")
            .drive(cloudLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
