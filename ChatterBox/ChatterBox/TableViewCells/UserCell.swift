//
//  UserCell.swift
//  ChatterBox
//
//  Created by Navdeep  Singh on 6/11/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
