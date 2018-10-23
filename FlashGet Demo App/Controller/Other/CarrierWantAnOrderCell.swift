//
//  CarrierWantAnOrderCell.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-13.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase

class CarrierWantAnOrderCell: UITableViewCell {

    @IBOutlet weak var itemPhoto: UIImageView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderRewardLabel: UILabel!
    @IBOutlet weak var orderDistanceLabel: UILabel!
    @IBOutlet weak var orderAwayLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    func configureCell(itemImage: UIImage, id: String, reward: String, distance: String, away: String){
        
        itemPhoto.image = itemImage
        orderIdLabel.text = id
        orderRewardLabel.text = reward
        orderDistanceLabel.text = distance
        orderAwayLabel.text = away
        
    }

}
