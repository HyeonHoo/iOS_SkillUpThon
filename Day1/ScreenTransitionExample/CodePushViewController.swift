//
//  CodePushViewController.swift
//  ScreenTransitionExample
//
//  Created by Gunter on 2021/08/16.
//

import UIKit

class CodePushViewController: UIViewController {

  @IBOutlet weak var nameLabel: UILabel!
  var name: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    if let name = name {
      self.nameLabel.text = name
      self.nameLabel.sizeToFit()
    }
  }

  @IBAction func tapBackButton(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}
