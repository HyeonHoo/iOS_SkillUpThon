//
//  RoundButton.swift
//  Calculator
//
//  Created by Gunter on 2021/08/23.
//

import UIKit

@IBDesignable
class RoundButton: UIButton { //UIButton 의 기능을 사용합니다.
  @IBInspectable var isRound: Bool = false {
      //@IBInspectable 스토리보드에서도 값을 변경하기위해서 사용합니다.
    didSet {
      if isRound {
        self.layer.cornerRadius = self.frame.height / 2
      }
    }
  }
}
