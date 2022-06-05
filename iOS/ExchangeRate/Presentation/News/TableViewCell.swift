//
//  TableViewCell.swift
//  ExchangeRate
//
//  Created by gwakgh on 2022/05/24.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    var cellLabelTitle : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var cellLabelDate : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func cellSetting() {
        labelSetting()
        widthAnchor.constraint(equalToConstant: 50).isActive = true
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func labelSetting() {
        self.addSubview(self.cellLabelTitle)
        self.addSubview(self.cellLabelDate)
        
        self.cellLabelTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.cellLabelTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        self.cellLabelTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: 15).isActive = true
        self.cellLabelTitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 8.0).isActive = true
        self.cellLabelTitle.numberOfLines = 2
        
        self.cellLabelDate.topAnchor.constraint(equalTo: cellLabelTitle.bottomAnchor, constant: 10).isActive = true
        self.cellLabelDate.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        self.cellLabelDate.rightAnchor.constraint(equalTo: rightAnchor, constant: 25).isActive = true
        self.cellLabelDate.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3.0).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
