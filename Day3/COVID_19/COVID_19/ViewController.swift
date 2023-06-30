//
//  ViewController.swift
//  COVID_19
//
//  Created by HyeonHo on 2023/06/25.
//

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
    self.indicatorView.startAnimating()   //뷰 로딩시 인디케이터 애니메이션을 시작합니다.
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
      //파이차트뷰의 델리게이트 설정
    self.pieChartView.delegate = self
    let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
      guard let self = self else { return nil }
      return PieChartDataEntry(
        value: self.removeFormatString(string: overview.newCase),   //차트 항목 값
        label: overview.countryName,
        data: overview
      )
    }
      //파이차트 디자인을 위한 데이트셋 선언
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

    self.pieChartView.data = PieChartData(dataSet: dataSet)  //파이차트뷰에 데이터셋 전달
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
      "serviceKey": "zOMbBfyK5V3CrJ871empWtsuIkvcxYijL" //딕셔너리 키
    ]
    AF.request(url, method: .get, parameters: param) //Alamofire 라이브러리를 사용해 URL에 GET 요청을 보냄
      .responseData(completionHandler: { response in    //response in: 응답결과에 따라 해당 처리를 수행합니다.
        switch response.result {
        case let .success(data):
          do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(CityCovidOverview.self, from: data)
            completionHandler(.success(result))//성공했을 경우, JSONDecoder 객체를 생성해 데이터를 디코딩하고 completionHandler를 통해 결과값을 넘깁니다.
          } catch {
            completionHandler(.failure(error))
          }
        case let .failure(error):
          completionHandler(.failure(error))
        }
      })
  }
}

extension ViewController: ChartViewDelegate {
  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) { //차트에서 항목이 선택됐을 경우 호출된다.
    guard let covidDetailViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailViewController") as? CovidDetailViewController else {
         return //인스턴스 객체를 생성하고 해당 객체가 생성되지 않았다면, 해당 함수를 종료한다.
       }
    guard let covidOverview = entry.data as? CovidOverview else { return } //선택한 항목의 데이터가 CovidOverview 클래스 타입으로 형변환 불가능할 경우, 해당 함수를 종료한다
    covidDetailViewController.covidOverview = covidOverview //프로퍼티를 선택한 항목의 CovidOverview 데이터로 설정한다.
    self.navigationController?.pushViewController(covidDetailViewController, animated: true)
      //navigationController의 push 메서드를 사용해 covidDetailViewController를 push하고 화면 전환이 애니메이션을 동반할 수 있도록 한다.
  }
}

