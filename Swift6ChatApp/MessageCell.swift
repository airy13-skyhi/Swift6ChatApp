//
//  MessageCell.swift
//  Swift6ChatApp
//
//  Created by Manabu Kuramochi on 2021/04/03.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rightImageView.layer.cornerRadius = 25.0
        leftImageView.layer.cornerRadius = 25.0
        backView.layer.cornerRadius = 10.0
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
