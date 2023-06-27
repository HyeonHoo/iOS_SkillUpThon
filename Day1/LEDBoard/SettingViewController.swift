//
//  SettingViewController.swift
//  LEDBoard
//
//  Created by Gunter on 2021/08/17.
//

import UIKit

protocol LEDBoardSettingDelegate: AnyObject {
  func changedSetting(text: String?, textColor: UIColor, backgroudColor: UIColor)
}

class SettingViewController: UIViewController {

  @IBOutlet weak var textField: UITextField!

  @IBOutlet weak var yellowButton: UIButton!
  @IBOutlet weak var purpleButton: UIButton!
  @IBOutlet weak var greenButton: UIButton!

  @IBOutlet weak var blackButton: UIButton!
  @IBOutlet weak var blueButton: UIButton!
  @IBOutlet weak var orangeButton: UIButton!

  weak var delegate: LEDBoardSettingDelegate?

  //기본값 설정
  var ledText: String?
  var textColor: UIColor = .yellow
  var backgroudColor: UIColor = .black

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureView() //호출을 해야지 LED값들을 초기화합니다.
  }

  private func configureView() {    //기존값을 기억해주는 뷰 초기화 방식.
    if let ledText = self.ledText {
      self.textField.text = ledText
    }
    self.changeTextColorButton(color: self.textColor) //설정창에서 선택한 값 저장하기위함
    self.changeBackgroundColorButton(color: self.backgroudColor)
  }

  @IBAction func tapTextColorButton(_ sender: UIButton) {
      //선택된 버튼의 인스턴스를 넘겨줍니다.
      //선택된 알파값 1 로설정하고, 선택안된 버튼은 0.2로 설정합니다.
    if sender == yellowButton {
      self.textColor = .yellow      //저장버튼을 눌렀을때 delegate로 값을 넘겨주기 위함.
      self.changeTextColorButton(color: .yellow)
    } else if sender == purpleButton {
      self.textColor = .purple
      self.changeTextColorButton(color: .purple)
    } else {
      self.textColor = .green
      self.changeTextColorButton(color: .green)
    }
  }

  @IBAction func tapBackgroundColorButton(_ sender: UIButton) {
    if sender == blackButton {
      self.backgroudColor = .black
      self.changeBackgroundColorButton(color: .black)
    } else if sender == blueButton {
      self.backgroudColor = .blue
      self.changeBackgroundColorButton(color: .blue)
    } else {
      self.backgroudColor = .orange
      self.changeBackgroundColorButton(color: .orange)
    }
  }

  @IBAction func tapSaveButton(_ sender: Any) {
    self.delegate?.changedSetting(
      text: self.textField.text,    //text 프로퍼티 넘겨줍니다.
      textColor: self.textColor,
      backgroudColor: self.backgroudColor
    )
    self.navigationController?.popViewController(animated: true)
  }

  private func changeTextColorButton(color: UIColor) {
      //선택된 버튼 확인하기 위한 작업
      //선택된 알파값 1 로설정하고, 선택안된 버튼은 0.2로 설정합니다.
    self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2
    self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2
    self.greenButton.alpha = color == UIColor.green ? 1 : 0.2
  }

  private func changeBackgroundColorButton(color: UIColor) {
    self.blackButton.alpha = color == UIColor.black ? 1 : 0.2
    self.blueButton.alpha = color == UIColor.blue ? 1 : 0.2
    self.orangeButton.alpha = color == UIColor.orange ? 1 : 0.2
  }
}
