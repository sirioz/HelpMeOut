//
//  CaregiversTableViewCell.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 27/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit

class PatientsTableViewCell: UITableViewCell {

    @IBOutlet weak var rightImageView: UIImageView!
    
    var patient: Patient?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PatientsTableViewCell {
    
    func configure(with patient: Patient) {
        self.patient = patient
        
        let imgStatus = patient.waiting ? UIImage.circle(diameter: 25.0, color: UIColor.yellow) : UIImage.circle(diameter: 25.0, color: UIColor.green)
        self.textLabel?.text = patient.shortId
        self.rightImageView.image = imgStatus
    }
}
