//
//  CovidDetailViewController.swift
//  COVID_19
//
//  Created by HyeonHo on 2023/06/25.
//

import UIKit

class CovidDetailViewController: UITableViewController {
    
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!

    @IBOutlet weak var newCaseCell: UITableViewCell!
    
    var covidOverview: CovidOverview? //선택지역 데이터를 전달받는다.

    override func viewDidLoad() {
      super.viewDidLoad()
      self.configureView()
    }

    func configureView() {
      guard let covidOverview = self.covidOverview else { return }
      self.title = covidOverview.countryName
      self.newCaseCell.detailTextLabel?.text = "\(covidOverview.newCase)명"
      self.totalCaseCell.detailTextLabel?.text = "\(covidOverview.totalCase)명"
      self.recoveredCell.detailTextLabel?.text = "\(covidOverview.recovered)명"
      self.deathCell.detailTextLabel?.text = "\(covidOverview.death)명"
      self.percentageCell.detailTextLabel?.text = "\(covidOverview.percentage)%"
      self.overseasInflowCell.detailTextLabel?.text = "\(covidOverview.newFcase)명"
      self.regionalOutbreakCell.detailTextLabel?.text = "\(covidOverview.newCcase)명"
    }
  }

