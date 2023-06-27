//
//  ViewController.swift
//  Diary
//
//  Created by Gunter on 2021/09/10.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!

  private var diaryList = [Diary]() { //Diary배열로 초기화
    didSet {    //프로퍼티 옵저버
      self.saveDiaryList()  //추가 변경이 있으면 userdefault에저장
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureCollectionView()
    self.loadDiaryList()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(editDiaryNotification(_:)),
      name: NSNotification.Name("editDiary"),
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(starDiaryNotification(_:)),
      name: NSNotification.Name("starDiary"),
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(deleteDiaryNotification(_:)),
      name: Notification.Name("deleteDiary"),
      object: nil
    )
  }

  private func configureCollectionView() {
    self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }

  @objc func editDiaryNotification(_ notification: Notification) {
    guard let diary = notification.object as? Diary else { return }
    guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }
    self.diaryList[index] = diary
    self.diaryList = self.diaryList.sorted(by: {
      $0.date.compare($1.date) == .orderedDescending    //날짜 최신순 정렬
    })
    self.collectionView.reloadData()
  }

  @objc func starDiaryNotification(_ notification: Notification) {
    guard let starDiary = notification.object as? [String: Any] else { return }
    guard let isStar = starDiary["isStar"] as? Bool else { return }
    guard let uuidString = starDiary["uuidString"] as? String else { return }
    guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
    self.diaryList[index].isStar = isStar
  }

  @objc func deleteDiaryNotification(_ notification: Notification) {
    guard let uuidString = notification.object as? String else { return }
    guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
    self.diaryList.remove(at: index)
    self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let wireDiaryViewContoller = segue.destination as? WriteDiaryViewController {
      wireDiaryViewContoller.delegate = self //delegate 값전달을 받기위해,delegate위임
    }
  }

  private func saveDiaryList() {
    let date = self.diaryList.map { //딕셔너리 매핑
      [
        "uuidString": $0.uuidString,
        "title": $0.title,
        "contents": $0.contents,
        "date": $0.date,
        "isStar": $0.isStar
      ] as [String : Any]
    }
    let userDefaults = UserDefaults.standard
    userDefaults.set(date, forKey: "diaryList")
  }

  private func loadDiaryList() {
    let userDefaults = UserDefaults.standard
    guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
      //[[String: Any]]딕셔너리 형태의 타입캐스팅
    self.diaryList = data.compactMap {  //불어온 값을 diaryList형식의 딕셔너리 매핑
      guard let uuidString = $0["uuidString"] as? String else { return nil}
      guard let title = $0["title"] as? String else { return nil }
      guard let contents = $0["contents"] as? String else { return nil }
      guard let date = $0["date"] as? Date else { return nil }
    //  guard let isStar = $0["isStar"] as? Bool else { return nil }
        guard let isStar = $0["isStar"] as? Bool, isStar else { return nil }
      return Diary(uuidString: uuidString, title: title, contents: contents, date: date, isStar: isStar)
        //값 인스턴스화.
    }
    self.diaryList = self.diaryList.sorted(by: { //날짜가 최신순으로 정렬하게 해줍니다.
      $0.date.compare($1.date) == .orderedDescending //오른쪽의 값과 비교해서 내림차순으로 정렬합니다.
    })
  }

  private func dateToString(date: Date) -> String { //date타입을 문자열로 반환해서 가져옵니다.
    let formatter = DateFormatter()
    formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: date)
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.diaryList.count  //지정된 섹션의 갯수 표시
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //지정된 객체의 표시할 셀을 표시.
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
    let diary = self.diaryList[indexPath.row]   //배열에 저장되어있는 셀 값을 가져옵니다.
    cell.titleLabel.text = diary.title
    cell.dateLabel.text = self.dateToString(date: diary.date)
    return cell
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {//CGSize => 설정한 사이즈대로 표시됩니다.
    return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200) //양옆에 10 사이즈 만큼 -20
  }
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //특정 셀 선택됨을 알려줍니다.
    guard let viewContoller = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
    let diary = self.diaryList[indexPath.row]
    viewContoller.diary = diary
    viewContoller.indexPath = indexPath
    self.navigationController?.pushViewController(viewContoller, animated: true)
  }
}

extension ViewController: WriteDiaryViewDelegate {
  func didSelectReigster(diary: Diary) {    //일기작성된 내용이 담겨져있는 객체 전달
    self.diaryList.append(diary)
    self.diaryList = self.diaryList.sorted(by: {
      $0.date.compare($1.date) == .orderedDescending
    })
    self.collectionView.reloadData()
  }
}
