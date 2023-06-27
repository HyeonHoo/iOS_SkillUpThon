//
//  ViewController.swift
//  COVID19
//
//  Created by Gunter on 2021/09/18.
//

import UIKit

import Alamofire
import Charts   //파이차트뷰를 사용하기 위한 선언

class ViewController: UIViewController {
  @IBOutlet weak var totalCaseLabel: UILabel!
  @IBOutlet weak var newCaseLabel: UILabel!
  @IBOutlet weak var pieChartView: PieChartView!
  @IBOutlet weak var labelStackView: UIStackView!
  @IBOutlet weak var indicatorView: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.indicatorView.startAnimating()
    self.fetchCovidOverview(completionHandler: { [weak self] result in
      guard let self = self else { return }
      self.indicatorView.stopAnimating()
      self.indicatorView.isHidden = true
      self.labelStackView.isHidden = false
      self.pieChartView.isHidden = false
      switch result {
      case let .success(result):
        self.configureStackView(koreaCovidOverview: result.korea)
          //af는 자동으로 .main에서 동작하므로 async 설정 안해도 됩니다.
        let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
        self.configureChartView(covidOverviewList: covidOverviewList)

      case let .failure(error):
        debugPrint("failure \(error)")
      }
    })
  }

  func makeCovidOverviewList(cityCovidOverview: CityCovidOverview) -> [CovidOverview] {
    return [
      cityCovidOverview.seoul,
      cityCovidOverview.busan,
      cityCovidOverview.daegu,
      cityCovidOverview.incheon,
      cityCovidOverview.gwangju,
      cityCovidOverview.daejeon,
      cityCovidOverview.ulsan,
      cityCovidOverview.sejong,
      cityCovidOverview.gyeonggi,
      cityCovidOverview.chungbuk,
      cityCovidOverview.chungnam,
      cityCovidOverview.jeonnam,
      cityCovidOverview.gyeongbuk,
      cityCovidOverview.gyeongnam,
      cityCovidOverview.jeju,
    ]
  }

  func configureStackView(koreaCovidOverview: CovidOverview) {
    self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase) 명"
    self.newCaseLabel.text = "\(koreaCovidOverview.newCase) 명"
  }

  func configureChartView(covidOverviewList: [CovidOverview]) { //파일차트에 데이터 추가
    self.pieChartView.delegate = self
    let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
      guard let self = self else { return nil }
      return PieChartDataEntry(
        value: self.removeFormatString(string: overview.newCase),   //차트 항목 값
        label: overview.countryName,
        data: overview
      )
    }
    let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
    dataSet.sliceSpace = 1  //차트 모양 설정
    dataSet.entryLabelColor = .black
    dataSet.xValuePosition = .outsideSlice
    dataSet.valueTextColor = .black
    dataSet.valueLinePart1OffsetPercentage = 0.8
    dataSet.valueLinePart1Length = 0.2
    dataSet.valueLinePart2Length = 0.3

    dataSet.colors = ChartColorTemplates.vordiplom() //다양한 색상 추가를 위함.
      + ChartColorTemplates.joyful()
      + ChartColorTemplates.colorful()
      + ChartColorTemplates.liberty()
      + ChartColorTemplates.pastel()
      + ChartColorTemplates.material()

    self.pieChartView.data = PieChartData(dataSet: dataSet) //차트뷰에 전달해줍니다.
    self.pieChartView.spin(duration: 0.3, fromAngle: pieChartView.rotationAngle, toAngle: pieChartView.rotationAngle + 80)  //차트 회전기능
  }

  func removeFormatString(string: String) -> Double {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.number(from: string)?.doubleValue ?? 0
  }

  func fetchCovidOverview(  //Alamofire 활용한 API전달받기위한 소스
    completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void
    // @escaping  함수의 로컬범위를 넘어서 사용하기위해서 사용합니다.
    // 비동기 작업을 하는 경우  @escaping 많이 사용합니다.
  ) {
    let url = "https://api.corona-19.kr/korea/country/new/"
    let param = [
      "serviceKey": "GbxNkY4w6mSZpiXcP25F7gEjyr1fnDWVC" //딕셔너리 키
    ]
    AF.request(url, method: .get, parameters: param)
      .responseData(completionHandler: { response in
        switch response.result {
        case let .success(data):
          do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(CityCovidOverview.self, from: data)
            completionHandler(.success(result))
          } catch {
            completionHandler(.failure(error))
          }
        case let .failure(error):
          completionHandler(.failure(error))
        }
      })
  }
}

extension ViewController: ChartViewDelegate { //차트 항목이 선택됐을때 항목의 데이터 값을 불러오기위해서?
  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    guard let covidDetailViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailViewController") as? CovidDetailViewController else {
         return
       }
    guard let covidOverview = entry.data as? CovidOverview else { return }
    covidDetailViewController.covidOverview = covidOverview
    self.navigationController?.pushViewController(covidDetailViewController, animated: true)
  }
}

