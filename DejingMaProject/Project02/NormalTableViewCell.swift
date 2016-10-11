//
//  NormalTableViewCell.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/9/30.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

protocol NormalTableViewCellDelegate: NSObjectProtocol {
	func afterShowModalClick(cell: NormalTableViewCell, buttonFrame: CGRect)
}

class NormalTableViewCell: UITableViewCell {
	
	@IBOutlet weak var label: UILabel!
	weak var delegate: NormalTableViewCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	static func getCellIdentify() -> String {
		return "NormalTableViewCell"
	}
	
	@IBAction func showModal(_ sender: AnyObject, forEvent event: UIEvent) {
		let button = sender as! UIButton
		
		delegate?.afterShowModalClick(cell: self, buttonFrame: button.frame)
	}
	
}

