//
//  SelectedThingsCell.swift
//  Things
//
//  Created by Aashini Sharma on 2022-08-02.
//

import UIKit

class SelectedThingsCell: UITableViewCell {
    
    // MARK: - Outlets
    // =========================
    @IBOutlet weak var thingNameLbl: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Cell life Cycle
    // =========================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
    }
    
    override func prepareForReuse() {
        contentView.layer.cornerRadius = 0;
        bottomConstraint.constant = 0
    }
}

// MARK: - Private Extention
// =========================
private extension SelectedThingsCell {
    
    func initialSetUp() {
        colorSetup()
    }
    
    func colorSetup() {
        contentView.backgroundColor = AppColors.themeColor
        thingNameLbl.textColor = AppColors.textColor
        thingNameLbl.backgroundColor = AppColors.themeColor
    }
}

// MARK: - Public Extention
// =========================
extension SelectedThingsCell {
    func curveBottom() {
        contentView.layer.maskedCorners = [.layerMaxXMaxYCorner , .layerMinXMaxYCorner]
        contentView.layer.cornerRadius = AppConstants.cornerRadius
        bottomConstraint.constant = 10
    }
    
    func configureCell(with model:ThingsData) {
        thingNameLbl.text = model.name
    }
}
