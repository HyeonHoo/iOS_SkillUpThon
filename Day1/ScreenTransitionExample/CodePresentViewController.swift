//
//  CodePresentViewController.swift
//  ScrenTrain
//
//  Created by 신현호 on 2023/06/20.
//

import UIKit

protocol SendDataDelegate : AnyObject{
    func sendData(name:String)
}
class CodePresentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name:String?
    weak var delegate: SendDataDelegate? // delegate 변수 앞엔 weak 키워드 사용해야합니다. =>메모리관련
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.delegate?.sendData(name: "hyeonho")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
       
    }
}
