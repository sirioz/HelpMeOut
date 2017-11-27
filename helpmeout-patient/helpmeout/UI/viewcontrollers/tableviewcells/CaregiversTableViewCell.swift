//
//  CaregiversTableViewCell.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 27/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit

class CaregiversTableViewCell: UITableViewCell {

    @IBOutlet weak var rightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CaregiversTableViewCell {
    
    func configure(title: String, rightImage: UIImage) {
        self.textLabel?.text = title
        self.rightImageView.image = rightImage
    }
}
