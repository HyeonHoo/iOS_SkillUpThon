//
//  ViewController.swift
//  Weather
//
//  Created by 신현호 on 2023/06/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    @IBOutlet weak var cityNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
          self.getCurrentWeather(cityName: cityName)
          self.view.endEditing(true)    //버튼이 누르면 키보드가 사라지게하는 코드.
        }
    }
    
    func configureView(weatherInformation: WeatherInformation) {
      self.cityNameLabel.text = weatherInformation.name
      if let weather = weatherInformation.weather.first {
        self.weatherDescriptionLabel.text = weather.description   //현재 날씨정보 표시
      }
      self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
      self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))℃"
      self.maxTempLabel.text = "최고: \(Int(weatherInformation.temp.maxTemp - 273.15))℃"
    }

    func showAlert(message: String) {
      let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }

    func getCurrentWeather(cityName: String) {
      guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=5bb4f17b9abe3688a33a27272c989cd7") else { return }
      let session = URLSession(configuration: .default)
      session.dataTask(with: url) { [weak self] data, response, error in
          //서버데이터 요청과 응답받는. data,response,error 내용 ios 기말 정리 가져오기.
          //순환참조 해결을 해주는 이유는 뭘까.
        let successRange = (200..<300)    //에러가 발생하지 않을 시 실행하기 위해 변수 생성
        guard let data = data, error == nil else { return }
        let decoder = JSONDecoder()
        if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
            //응답받은 statusCode가 에러발생 코드가 아닌지 확인.
          guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
          DispatchQueue.main.async {
            self?.weatherStackView.isHidden = false   //날씨정보 표시를 위해 히든속성 false
            self?.configureView(weatherInformation: weatherInformation)
          }
        } else {
          guard let errorMesaage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
          DispatchQueue.main.async {
            self?.showAlert(message: errorMesaage.message)
          }
        }

      }.resume()
    }
  }
