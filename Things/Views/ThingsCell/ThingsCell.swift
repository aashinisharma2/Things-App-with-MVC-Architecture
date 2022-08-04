//
//  ThingsCell.swift
//  Things
//
//  Created by Aashini Sharma on 2022-07-29.
//

import UIKit

class ThingsCell: UITableViewCell {

    // MARK: - Outlets
    // =========================
    @IBOutlet weak var thingNameLbl: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var checkMarkImgView: UIImageView!
    
    // MARK: - Properties
    // =========================
    var isCheckmarked:Bool = false
    
    // MARK: - Cell life Cycle
    // =========================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkMarkImgView.isHidden = true
        isCheckmarked = false
    }
}

// MARK: - Private Extention
// =========================
private extension ThingsCell {
    
    func initialSetUp() {
        checkMarkImgView.layer.cornerRadius = checkMarkImgView.frame.height / 2
        cardView.layer.cornerRadius = AppConstants.cornerRadius
        checkMarkImgView.isHidden = true
        checkMarkImgView.image = AppImage.checkMarked
        colorSetup()
    }
    
    func colorSetup() {
        contentView.backgroundColor = .clear
        cardView.backgroundColor = AppColors.themeColor
        checkMarkImgView.backgroundColor = AppColors.buttonsTintColor
        checkMarkImgView.tintColor = AppColors.themeLightColor
        thingNameLbl.textColor = AppColors.textColor
    }
}

// MARK: - Public Extention
// =========================
extension ThingsCell {
    
    func changeState() {
        isCheckmarked.toggle()
        checkMarkImgView.isHidden = !isCheckmarked
    }
    
    func configureCell( with data: ThingsData , withoutCheckmark:Bool = false) {
        thingNameLbl.text = data.name
        isCheckmarked = data.isSelected
        if withoutCheckmark == false {
            checkMarkImgView.isHidden = !data.isSelected
        } else {
            checkMarkImgView.isHidden = true
        }
    }
}
