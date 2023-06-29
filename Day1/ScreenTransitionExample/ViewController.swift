//
//  ViewController.swift
//  ScrenTrain
//
//  Created by 신현호 on 2023/06/20.
//

import UIKit

class ViewController: UIViewController,SendDataDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      print("ViewController 뷰가 로드 되었다.")
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      print("ViewController 뷰가 나타날 것이다.")
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      print("ViewController 뷰가 나타났다.")
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      print("ViewController 뷰가 사라질 것이다.")
    }

    override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      print("ViewController 뷰가 사라졌다.")
    }
   
   
    @IBAction func tapCodePushButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController") as? CodePushViewController else {
          return
        }
        viewController.name = "hyeonho"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapCodePresent(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePresentViewController") as? CodePresentViewController else {
          return
        }
        viewController.delegate = self
        viewController.name = "hyeonho"
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sendData(name: String) {
      self.nameLabel.text = name
      self.nameLabel.sizeToFit() //사이즈에 맞게 출력을 하기위한 소스
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let viewController = segue.destination as? SuguePushViewController {
        viewController.name = "hyeonho"
      }
    }

}

