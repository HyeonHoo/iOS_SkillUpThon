//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by Gunter on 2021/08/16.
//

import UIKit

protocol SendDataDelegate: AnyObject {
  func sendData(name: String)
}

class CodePresentViewController: UIViewController {

  @IBOutlet weak var nameLabel: UILabel!
  weak var delegate: SendDataDelegate?
  var name: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    if let name = name {
      self.nameLabel.text = name
      self.nameLabel.sizeToFit()
    }
  }

  @IBAction func tapBackButton(_ sender: Any) {
    self.delegate?.sendData(name: "Gunter")
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}
