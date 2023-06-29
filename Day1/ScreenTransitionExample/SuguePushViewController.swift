//
//  SuguePushViewController.swift
//  ScrenTrain
//
//  Created by 신현호 on 2023/06/20.
//

import UIKit

class SuguePushViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    
    override func viewDidLoad() {
      super.viewDidLoad()
      if let name = name {
        self.nameLabel.text = name
        self.nameLabel.sizeToFit()
      }
      print("SeguePushViewController 뷰가 로드 되었다.")
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      print("SeguePushViewController 뷰가 나타날 것이다.")
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      print("SeguePushViewController 뷰가 나타났다.")
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      print("SeguePushViewController 뷰가 사라질 것이다.")
    }

    override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      print("SeguePushViewController 뷰가 사라졌다.")
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.popToRootViewController(animated: true) // 누르면 루트 뷰 컨트롤러로 이동
    }
    

   

}
