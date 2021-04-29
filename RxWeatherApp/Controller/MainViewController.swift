//
//  MainViewController.swift
//  RxWeatherApp
//
//  Created by 이지원 on 2021/04/28.
//

import UIKit

class MainViewController: UIViewController {

    // MARK:- IBOutlet
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
