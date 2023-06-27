//
//  ViewController.swift
//  LEDBoard
//
//  Created by Gunter on 2021/08/17.
//

import UIKit

class ViewController: UIViewController, LEDBoardSettingDelegate {

  @IBOutlet weak var contentsLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.contentsLabel.textColor = .yellow
  }
    //segue 방식의 화면전환 방법을 구현해서 prepare 메소드를 활용합니다.
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let settingViewController = segue.destination as? SettingViewController {
      settingViewController.delegate = self   //프로토콜을 채택 후 준수사항을 정의해야합니다.
      settingViewController.ledText = self.contentsLabel.text
        //설정된 값을 설정창으로 값을 넘겨주기 위함
      settingViewController.textColor = self.contentsLabel.textColor
      settingViewController.backgroudColor = self.view.backgroundColor ?? .black
        //옵셔널이기 때문에 값이 없으면 balck 으로 설정합니다.
    }
  }

  func changedSetting(text: String?, textColor: UIColor, backgroudColor: UIColor) {
    if let text = text {
      self.contentsLabel.text = text
    }
    self.contentsLabel.textColor = textColor
    self.view.backgroundColor = backgroudColor
  }
}


