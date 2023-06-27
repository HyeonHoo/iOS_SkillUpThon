//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Gunter on 2021/09/10.
//

import UIKit

class DiaryDetailViewController: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentsTextView: UITextView!
  @IBOutlet weak var dateLabel: UILabel!
  var starButton: UIBarButtonItem?  //즐겨찾기 버튼 생성

  var diary: Diary?
  var indexPath: IndexPath?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureView() //일기장 상세화면에 값을 전달합니다.
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(starDiaryNotification(_:)),
      name: NSNotification.Name("starDiary"),
      object: nil
    )
  }

  private func configureView() {
    guard let diary = self.diary else { return }
    self.titleLabel.text = diary.title
    self.contentsTextView.text = diary.contents
    self.dateLabel.text = self.dateToString(date: diary.date)
    self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
    self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    //즐겨찾기 버튼 만들기
    self.starButton?.tintColor = .orange
    self.navigationItem.rightBarButtonItem = self.starButton
  }

  private func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: date)
  }

  @objc func editDiaryNotification(_ notification: Notification) {
    guard let diary = notification.object as? Diary else { return } //포스트 수정된 객체를 가져오는 작업
    self.diary = diary  //수정된 diary객체 대입
    self.configureView()    //수정된 값으로 뷰 업데이트
  }

  @objc func starDiaryNotification(_ notification: Notification) {
    guard let starDiary = notification.object as? [String: Any] else { return }
    guard let isStar = starDiary["isStar"] as? Bool else { return }
    guard let uuidString = starDiary["uuidString"] as? String else { return }
    guard let diary = self.diary else { return }
    if diary.uuidString == uuidString {
      self.diary?.isStar = isStar
      self.configureView()
    }
  }

  @IBAction func tapEditButton(_ sender: UIButton) {
    guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
    guard let indexPath = self.indexPath else { return }
    guard let diary = self.diary else { return }
    viewController.diaryEditorMode = .edit(indexPath, diary)
      //수정 버튼을 누르면 diaryEditorMode안의 연관값인 값을 전달받는다.
    NotificationCenter.default.addObserver(
      self, //어떤 인스턴스에서 옵저빙 할건지 설정
      selector: #selector(editDiaryNotification(_:)),   //변경되면 editDiaryNotification값 전달
      name: NSNotification.Name("editDiary"),   //editDiary 을 관찰하고있습니다.
      object: nil
    )
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction func tapDeleteButton(_ sender: UIButton) {
    guard let uuidString = self.diary?.uuidString else { return }
    NotificationCenter.default.post(
      name: NSNotification.Name("deleteDiary"),
      object: uuidString,
      userInfo: nil
    )
    self.navigationController?.popViewController(animated: true)
  }

  @objc func tapStarButton() {
    guard let isStar = self.diary?.isStar else { return }

    if isStar {
      self.starButton?.image = UIImage(systemName: "star")
    } else {
      self.starButton?.image = UIImage(systemName: "star.fill")
    }
    self.diary?.isStar = !isStar    
    NotificationCenter.default.post(
      name: NSNotification.Name("starDiary"),
      object: [
        "diary": self.diary,
        "isStar": self.diary?.isStar ?? false,
        "uuidString": diary?.uuidString
      ] as [String : Any],
      userInfo: nil
    )
  }

  deinit {
    NotificationCenter.default.removeObserver(self) //해당 인스턴스에 추가된 옵저버를 제거합니다.
  }

}
