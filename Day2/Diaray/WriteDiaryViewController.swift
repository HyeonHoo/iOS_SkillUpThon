//
//  WriteDiaryViewController.swift
//  Diaray
//
//  Created by 신현호 on 2023/06/21.
//

import UIKit

enum DiaryEditorMode {
  case new
  case edit(IndexPath, Diary)   //연관값으로 ()안 객체를 전달받는다.
}

protocol WriteDiaryViewDelegate: AnyObject {
  func didSelectReigster(diary: Diary) //일기가 작성된 Diary객체 전달.
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    private let datePicker = UIDatePicker()   //날짜형식으로 입력하는 창 생성
    private var diaryDate: Date?  //데이터 프로퍼티?
    weak var delegate: WriteDiaryViewDelegate?
    var diaryEditorMode: DiaryEditorMode = .new

    override func viewDidLoad() {
      super.viewDidLoad()
      self.configureContentsTextView()
      self.configureDatePicker()
      self.configureInputField()
      self.configureEditMode()
      self.confirmButton.isEnabled = false //등록버튼 비활성화
    }

    private func configureEditMode() {
      switch self.diaryEditorMode {
        case let .edit(_, diary):
          self.titleTextField.text = diary.title
          self.contentTextView.text = diary.contents
          self.dateTextField.text = self.dateToString(date: diary.date)
          self.diaryDate = diary.date
          self.confirmButton.title = "수정"

      default:
        break
      }
    }

    private func dateToString(date: Date) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
      formatter.locale = Locale(identifier: "ko_KR")
      return formatter.string(from: date)
    }

    private func configureContentsTextView() {  //textview 에 테두리색을 넣는 코드
      let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0) //225를 나누는 이유
      self.contentTextView.layer.borderColor = borderColor.cgColor
      self.contentTextView.layer.borderWidth = 0.5   //테두리의 넓이
      self.contentTextView.layer.cornerRadius = 5.0  //테두리의 라운드 설정
    }

    private func configureDatePicker() {  //함수 설명 필요
      self.datePicker.datePickerMode = .date
      self.datePicker.preferredDatePickerStyle = .wheels
      self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        //타겟-액션 패턴을 사용하여 날짜 선택기의 값이 변경될 때 호출될 함수를 설정
      self.datePicker.locale = Locale(identifier: "ko-KR")
      self.dateTextField.inputView = self.datePicker
    }

    private func configureInputField() {
      self.contentTextView.delegate = self
      self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
      self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }

    @IBAction func tapconfirmButton(_ sender: UIBarButtonItem) {
      guard let title = self.titleTextField.text else { return }
      guard let contents = self.contentTextView.text else { return }
      guard let date = self.diaryDate else { return }

      switch self.diaryEditorMode {
      case .new:
        let diary = Diary(
          uuidString: UUID().uuidString,
          title: title,
          contents: contents,
          date: date,
          isStar: false
        )
        self.delegate?.didSelectReigster(diary: diary)

      case let .edit(_, diary):
        let diary = Diary(
          uuidString: diary.uuidString,
          title: title,
          contents: contents,
          date: date,
          isStar: diary.isStar
        )
        NotificationCenter.default.post( //이벤트 포스트 포스트메소드 호출.
          name: NSNotification.Name("editDiary"),//editDiary이 파일내에서 이벤트가 발생하는지 확인
          object: diary,  //NotificationCenter으로 전달할 객체를 설정합니다.
          userInfo: nil   //
        )
      }
      self.navigationController?.popViewController(animated: true)
    }

    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
      let formmater = DateFormatter() //날짜와 텍스트를 반환해줍니다.
      formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)" //(EEEEE) 요일을 한글자만 표현해주는 포멧
      formmater.locale = Locale(identifier: "ko_KR")  //날짜 한국형식
      self.diaryDate = datePicker.date
      self.dateTextField.text = formmater.string(from: datePicker.date)
      self.dateTextField.sendActions(for: .editingChanged) //입력이 키보드입력이 아니라 직접 전달.
    }

    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
      self.validateInputField() //입력 한 후 등록 버튼 활성화 여부를 물어보기 위함.
    }

    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
      self.validateInputField()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)  //빈화면 클릭시 키보드나 날짜 입력형식 사라지게 하는 함수입니다.
    }

    private func validateInputField() {   //등록버튼 활성화 메서드
      self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentTextView.text.isEmpty
        //모든 인풋 버튼이 비어있지않으면 등록버튼을 활성화 합니다.
    }
  }

  extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
      self.validateInputField()   //텍스트뷰의 텍스트가 입력될때마다 메서드 호출됩니다.
    }
  }
