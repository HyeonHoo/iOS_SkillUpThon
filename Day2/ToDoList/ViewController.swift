//
//  ViewController.swift
//  ToDoList
//
//  Created by Gunter on 2021/08/28.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet var editButton: UIBarButtonItem!
    //편집모드 전환을 위한 strong 아웃렛 edit->done 이동시 edit을 다시 사용하기 위해서
  var doneButton: UIBarButtonItem?
  var tasks = [Task]() {    //할 일을 저장하는 변수
    didSet {
      self.saveTasks()  //할 일 추가될때마다 userDefaults에 저장합니다.
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadTasks()    //뷰를 불러올때 저장된 값을 불러옵니다.
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))   //#selector 해당 타입의 값을 생성할 수 있게해줍니다.
  }

  @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
    guard !self.tasks.isEmpty else { return }   //테이블 뷰가 비어있지 않을때만 사용할 수 있게합니다.
    self.navigationItem.leftBarButtonItem = self.doneButton
    self.tableView.setEditing(true, animated: true)
  }

  @objc func doneButtonTap() {  //@objc objectC에서 호환을 위한 메서드
    self.navigationItem.leftBarButtonItem = self.editButton
    self.tableView.setEditing(false, animated: true)
  }
  
  @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
    let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in //클로저 정의 [weak self] 메모리 누수 해결을 위해 클로저 선언부 에서 캡쳐목록 정의 합니다.
      guard let title = alert.textFields?[0].text else { return }
        //텍스트 필드에 입력된 값이 뭔지 알려주는 코드.
      let task = Task(title: title, done: false)
      self?.tasks.append(task)  //할 일을 등록할 때 마다 task에 저장합니다.
      self?.tableView.reloadData() //task배열에 할 일 추가한 후 테이블을 갱신해서 갱신한걸 보여준다.
    })
    let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addTextField(configurationHandler: { textField in
      textField.placeholder = "할 일을 입력해주세요."
        //반환값이 없고 텍스트 필드객체를 파라미터를 통해 전달받는다.
    })
    alert.addAction(cancelButton) //UI버튼들을 넣어줍니다.
    alert.addAction(registerButton)
    self.present(alert, animated: true, completion: nil) //
  }

  func saveTasks() {
      let data = self.tasks.map {
      [
        "title": $0.title,
        "done": $0.done
      ]
    }
    let userDefaults = UserDefaults.standard    //하나의 인스턴스만존재합니다. 싱글톤 패턴
    userDefaults.set(data, forKey: "tasks")     //처음값 value 두번째 key
  }

  func loadTasks() {
    let userDefaults = UserDefaults.standard //로컬에저장한 할 일 목록을 불러옵니다.
    guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
      //저장된 값을 불러오는 .object메서드
    self.tasks = data.compactMap {
      guard let title = $0["title"] as? String else { return nil } //축약인자 딕셔너리에 접근
      guard let done = $0["done"] as? Bool else { return nil }
      return Task(title: title, done: done)
    }
  }
}

extension ViewController: UITableViewDataSource { //extension 소스코드 가독성을 위해 정의
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tasks.count     //배열의 개수가 반환됩니다.
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)    //dequeueReusableCell 재사용 가능한 셀 반환 + 테이블 뷰에 추가합니다.
      //큐를 사용해서 셀을 재사용 합니다. => 메모리 낭비 방지를 위해서 사용합니다.
    let task = self.tasks[indexPath.row]
    cell.textLabel?.text = task.title   //task에 저장된 title의 값을 셀에 표현
    if task.done {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true //moveRowAt을 사용하기 위해 셀을 움직이는것이 가능하게 하는 true값 반환.
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {  //셀을 재정렬 하기 위한 함수
    var tasks = self.tasks
    let task = tasks[sourceIndexPath.row]   //처음 배열의 위치를 가져옵니다
    tasks.remove(at: sourceIndexPath.row)
    tasks.insert(task, at: destinationIndexPath.row)    //이동한 배열의 위치를 저장합니다.
    self.tasks = tasks
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    self.tasks.remove(at: indexPath.row)    //삭제 버튼을 구현하기 위한 메서드
    tableView.deleteRows(at: [indexPath], with: .automatic)
      //편집모드에 안들어가도 스와이프 딜리트로 삭제가능

    if self.tasks.isEmpty {
      self.doneButtonTap()  //편집모드를 자동으로 나옵니다.
    }
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //셀을 선택할 때 어떤 셀이 선택된지 알려주는 함수
    var task = self.tasks[indexPath.row]
    task.done = !task.done
    self.tasks[indexPath.row] = task    //선택된 셀 값 변경 true / false 값
    self.tableView.reloadRows(at: [indexPath], with: .automatic)    //with=> 값변경 시 보여지는 애니메이션
  }
}

