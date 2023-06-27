//
//  ViewController.swift
//  pomodoro
//
//  Created by Gunter on 2021/09/12.
//

import UIKit
import AudioToolbox

enum TimerStatus {
  case start
  case pause
  case end
}

class ViewController: UIViewController {

  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var datePicker: UIDatePicker!

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var toggleButton: UIButton!

  var duration = 60     //타이머 생성된 시간을 초로 저장합니다.
  var timerStatus: TimerStatus = .end
  var currentSeconds = 0
  var timer: DispatchSourceTimer?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureToggleButton()
  }

  @IBAction func tapCancelButton(_ sender: UIButton) {
    switch self.timerStatus {
    case .start, .pause:
      self.stopTimer()

    default:
      break
    }
  }

  @IBAction func tapToggleButton(_ sender: UIButton) {
    self.duration = Int(self.datePicker.countDownDuration)
      //countDownDuration 타이머 시간이 몇초인지 알려줍니다.
    switch self.timerStatus {
    case .end:
      self.currentSeconds = duration
      self.timerStatus = .start     //시간종료시 스타트 버튼으로 변환
      UIView.animate(withDuration: 0.5, animations: {
        self.timerLabel.alpha = 1
        self.progressView.alpha = 1
        self.datePicker.alpha = 0
      })
      self.toggleButton.isSelected = true   //일시정지 버튼 활성화 하게 된다.
      self.cancelButton.isEnabled = true    //취소버튼 활성화 하게 된다.
      self.startTimer()

    case .start:
      self.timerStatus = .pause     //시작시 중지 버튼 변환
      self.toggleButton.isSelected = false  //시작버튼으로 변경되게 구현.
      self.timer?.suspend()

    case .pause:
      self.timerStatus = .start
      self.toggleButton.isSelected = true
      self.timer?.resume()
    }
  }

  func configureToggleButton() {    //상태에 따른 버튼의 표현형식 변환.
    self.toggleButton.setTitle("시작", for: .normal)
    self.toggleButton.setTitle("일시정지", for: .selected)
  }

  func startTimer() {
    if self.timer == nil {
      self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        //ui와 관련된 작업은 queue가 main 이여야한다.
      self.timer?.schedule(deadline: .now(), repeating: 1) //// 타이머를 즉시 시작 .now하고 1초마다 반복하도록 설정
      self.timer?.setEventHandler(handler: { [weak self] in //지정된 시간 마다 실행되는 핸들러(클로저 함수)를 설정
          //[weak self]를 사용하여 순환 참조를 방지합니다.
        guard let self = self else { return }
        self.currentSeconds -= 1
        let hour = self.currentSeconds / 3600
        let minutes = (self.currentSeconds % 3600) / 60
        let seconds = (self.currentSeconds % 3600) % 60
        self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
        self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
        UIView.animate(withDuration: 0.5, delay: 0, animations: { //180도 회전
          self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
        })
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: { //다시 180도 회전하여 원래 위치로 변경
          self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
        })
        if self.currentSeconds <= 0 {   //타이머 종료
          AudioServicesPlaySystemSound(1005)
          self.stopTimer()
        }
      })
      self.timer?.resume()
    }
  }

  func stopTimer() {
    if self.timerStatus == .pause {
      self.timer?.resume()
    }
    self.timerStatus = .end
    self.cancelButton.isEnabled = false

    UIView.animate(withDuration: 0.5, animations: {
      self.timerLabel.alpha = 0
      self.progressView.alpha = 0
      self.datePicker.alpha = 1
      self.imageView.transform = .identity
    })
    self.toggleButton.isSelected = false
    self.timer?.cancel()
    self.timer = nil
  }
}

