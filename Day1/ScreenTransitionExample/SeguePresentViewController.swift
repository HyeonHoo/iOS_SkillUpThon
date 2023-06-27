//
//  SeguePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by Gunter on 2021/08/16.
//

import UIKit

class SeguePresentViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  @IBAction func tapBackButton(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}
