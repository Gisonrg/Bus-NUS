//
//  NextBusTableViewCell.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 1/7/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class NextBusTableViewCell: UITableViewCell {

    @IBOutlet weak var busName: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!

    @IBOutlet weak var progressView: M13ProgressViewRing!
    
    func startLoading() {
        self.progressView.showPercentage = false
        self.progressView.indeterminate = true
        self.progressView.hidden = false
        self.arrivalTime.hidden = true
    }
    
    func hideLoading() {
        self.progressView.showPercentage = false
        self.progressView.indeterminate = false
        self.progressView.hidden = true
        self.arrivalTime.hidden = false
    }
}
