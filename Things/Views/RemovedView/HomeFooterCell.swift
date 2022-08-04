//
//  HomeFooterCell.swift
//  Things
//
//  Created by Govind Solanki on 2022-07-29.
//

import UIKit

class HomeFooterCell: UITableViewCell {
    
    // MARK: - Outlets
    // =========================
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties
    // =========================
    var nextBtn: (() -> ())? = nil
    
    // MARK: - Cell life Cycle
    // =========================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let btnAction = nextBtn else {return }
        btnAction()
    }
}

// MARK: - Private Extention
// =========================
private extension HomeFooterCell {
    
    func initialSetUp(){
        setUpCurve()
        setUpColor()
        nextButton.layer.cornerRadius = 5
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
        // moving to bottom right
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        //bottom right to 2/3 of rect height towords top
        path.addLine(to: CGPoint(x: rect.maxX, y: (rect.origin.y + (rect.height/3 - 10))))
        //adding curve from 1/3 of rect height to bottom left
        path.addQuadCurve(to: CGPoint(x:rect.minX + 20 , y: rect.maxY), controlPoint: CGPoint(x:2*rect.midX/3 + 30, y: rect.minY - rect.height/6 + 5))
        path.close()
        //
        return path.cgPath
    }
    
    func setUpColor() {
        nextButton.tintColor = .black
        nextButton.backgroundColor = .white
    }
    
    func setUpText() {
        nextButton.setTitle(StringConstants.next.localize, for: .normal)
    }
    
    func setUpCurve(){
        contentView.layer.insertSublayer(getCuredLayer(for: contentView.bounds), at: 0)
    }
}
