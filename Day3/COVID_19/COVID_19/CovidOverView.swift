//
//  CovidOverView.swift
//  COVID_19
//
//  Created by HyeonHo on 2023/06/25.
//

import Foundation

struct CityCovidOverview: Codable {
  let korea: CovidOverview
  let seoul: CovidOverview
  let busan: CovidOverview
  let daegu: CovidOverview
  let incheon: CovidOverview
  let gwangju: CovidOverview
  let daejeon: CovidOverview
  let ulsan: CovidOverview
  let sejong: CovidOverview
  let gyeonggi: CovidOverview
  let chungbuk: CovidOverview
  let chungnam: CovidOverview
  let jeonbuk: CovidOverview
  let jeonnam: CovidOverview
  let gyeongbuk: CovidOverview
  let gyeongnam: CovidOverview
  let jeju: CovidOverview
}

struct CovidOverview: Codable {
  let countryName: String   //시도별 이름
  let newCase: String       //신규 확진자
  let totalCase: String     //총 확진자
  let recovered: String     //완치자
  let death: String         //사망자
  let percentage: String    //발생률
  let newCcase: String      //해외유입 신규 확진자
  let newFcase: String      //지역발생 신규 확진자
}
