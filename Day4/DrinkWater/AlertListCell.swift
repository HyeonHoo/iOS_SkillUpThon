//
//  AlertListCell.swift
//  DrinkWater
//
//  Created by Bo-Young PARK on 2021/07/20.
//

import UIKit
import UserNotifications

class AlertListCell: UITableViewCell {
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var meridiemLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!
    
    @IBAction func alertSwitchValueChanged(_ sender: UISwitch) {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              var alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return }
        alerts[sender.tag].isOn = sender.isOn
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")
        
        if sender.isOn {
            userNotificationCenter.addNotificationRequest(by: alerts[sender.tag])
        } else {
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[sender.tag].id])
        }
    }
}
