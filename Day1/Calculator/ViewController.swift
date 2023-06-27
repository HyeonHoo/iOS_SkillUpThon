//
//  ViewController.swift
//  Calculator
//
//  Created by Gunter on 2021/08/23.
//

import UIKit

enum Operation { //열거형 [연산자가 열거형 값이 되도록 선언합니다.]
  case Add
  case Subtract
  case Divide
  case Multiply
  case unknown
}

class ViewController: UIViewController {

  @IBOutlet weak var numberOutputLabel: UILabel!

  var displayNumber = ""    //화면에 입력한 숫자값 저장합니다.
  var firstOperand = ""     //이전계산값을기억합니다.
  var secondOperand = ""    //새롭게 입력된 값을 저장합니다.
  var result = ""           //계산의 결과값을 저장합니다.
  var currentOperation: Operation = .unknown //현재 계산기에 어떤 연산자가 입력된지 알기위한 연산자 저장값

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


  @IBAction func tapNumberButton(_ sender: UIButton) {  // 7894561230 숫자들의 호출 함수.
    guard let numberValue = sender.title(for: .normal) else { return }
    if self.displayNumber.count < 9 {   //9자리 숫자까지만 입력을 가능하게 합니다.
      self.displayNumber += numberValue
      self.numberOutputLabel.text = self.displayNumber
    }
  }

  @IBAction func tapClearButton(_ sender: UIButton) { //AC 클리어 함수.
    self.displayNumber = ""
    self.firstOperand = ""
    self.secondOperand = ""
    self.result = ""
    self.currentOperation = .unknown
    self.numberOutputLabel.text = "0"
  }


  @IBAction func tapDotButton(_ sender: UIButton) { // 숫자에 소수점 추가를 위한 함수
    if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
        //소수점 포함 9 자리를 가능하게하는 예외처리 + 중복 으로 소수점 포함 불가능하게 하는 구문
      self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
      self.numberOutputLabel.text = self.displayNumber
    }
  }

  @IBAction func tapDivideButton(_ sender: UIButton) {
    self.operation(.Divide)
  }

  @IBAction func tapMultiplyButton(_ sender: UIButton) {
    self.operation(.Multiply)
  }


  @IBAction func tapSubtractButton(_ sender: UIButton) {
    self.operation(.Subtract)
  }

  @IBAction func tapAddButton(_ sender: UIButton) {
    self.operation(.Add)
  }
  
  @IBAction func tapEqualButton(_ sender: UIButton) {
    self.operation(self.currentOperation)
  }

  func operation(_ operation: Operation) { //계산을 해주는 함수 구현
    if self.currentOperation != .unknown {
      if !self.displayNumber.isEmpty { //비어있지 않을때
        self.secondOperand = self.displayNumber
        self.displayNumber = ""     //결과값을 표시해야하니까 빈문자열 초기화

        guard let firstOperand = Double(self.firstOperand) else { return }
        guard let secondOperand = Double(self.secondOperand) else { return }

        switch self.currentOperation {  //연산자를 연산하기위한 switch 구문
        case .Add:
          self.result = "\(firstOperand + secondOperand)"

        case .Subtract:
          self.result = "\(firstOperand - secondOperand)"

        case .Divide:
          self.result = "\(firstOperand / secondOperand)"

        case .Multiply:
          self.result = "\(firstOperand * secondOperand)"

        default:
          break
        }

        if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
          self.result = "\(Int(result))"    //결과값 소수점이 없으면 Int 형으로 변환해서 출력해줍니다.
        }

        self.firstOperand = self.result     //다음 연산을 위한 결과값을 처음 결과값에 저장 => 누적연산
        self.numberOutputLabel.text = self.result
      }

      self.currentOperation = operation //함수 파라미터로 전달한 operation 값
    } else {
      self.firstOperand = self.displayNumber    //초기값 저장
      self.currentOperation = operation         //연산자 값 저장
      self.displayNumber = ""                   //빈문자열 저장 후 새로운 숫자값을 받기위함
    }
  }
  
}


