//
//  HomeHeaderCell.swift
//  Things
//
//  Created by Govind Solanki on 2022-07-29.
//

import UIKit

class HomeHeaderCell: UITableViewCell {

    // MARK: - Outlets
    // =========================
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    // MARK: - Cell life Cycle
    // =========================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
    }
}

// MARK: - Private Extention
// =========================
private extension HomeHeaderCell {
    
    func initialSetUp(){
        setUpCurve()
        setUpColor()
        setUpText()
    }
    
    func getCuredLayer(for rect: CGRect) -> CAShapeLayer{
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.darkGray.cgColor
        layer.path = getPath(for: rect)
        return layer
    }
    
    func getPath(for rect: CGRect)-> CGPath{
        let path = UIBezierPath()
        // moving to origin of view
        path.move(to: rect.origin)
        // top left to bottom left
        path.addLine(to: CGPoint(x: rect.minX, y: (2*rect.height/3 + 26)))
        //adding curve from bottom left to top right
        path.addQuadCurve(to: CGPoint(x:rect.maxX-40, y: rect.minY), controlPoint: CGPoint(x:rect.midX + 40, y: rect.maxY - 4 ))
        //top right to top left
        path.close()
        //
        return path.cgPath
    }
    
    func setUpColor() {
        headingLbl.textColor = .white
        descriptionLbl.textColor = .white
    }
    
    func setUpText() {
        headingLbl.text = StringConstants.homeHeaderHeading.localize
        descriptionLbl.text = StringConstants.homeHeaderDescription.localize
    }

    func setUpCurve(){
        contentView.layer.insertSublayer(getCuredLayer(for: contentView.frame), at: 0)
    }
}
