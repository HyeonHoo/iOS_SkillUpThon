//
//  SuguePresentViewController.swift
//  ScrenTrain
//
//  Created by 신현호 on 2023/06/20.
//

import UIKit

class SuguePresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
  
    }

