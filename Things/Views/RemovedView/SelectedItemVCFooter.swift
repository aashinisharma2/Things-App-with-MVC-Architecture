//
//  SelectedItemVCFooter.swift
//  Things
//
//  Created by Govind Solanki on 2022-08-01.
//

import UIKit

class SelectedItemVCFooter: UITableViewCell {
    
    // MARK: - Outlets
    // =========================
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Properties
    // =========================
    var backBtn: (() -> ())? = nil
    
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
        guard let btnAction = backBtn else {return }
        btnAction()
    }
}

// MARK: - Private Extention
// =========================
private extension SelectedItemVCFooter {
    
    func initialSetUp(){
        setUpCurve()
        setUpColor()
        backButton.layer.cornerRadius = 5
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
        // starting from top left
        path.move(to: CGPoint(x: rect.minX, y: rect.origin.y + (rect.height/4)))
        // mid left to bottom left
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        // bottom left to bottom right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // bottom right to 1/4 to top right
        path.addLine(to: CGPoint(x: rect.maxX, y: (rect.maxY - (rect.height/4))))
        
        //adding curve y: rect.origin.y + 60
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.origin.y + (rect.height/4)), controlPoint: CGPoint(x:2*rect.maxX/3 - 30, y: rect.minY + rect.height/6 - 50 ))
        
        return path.cgPath
    }
    
    func setUpColor() {
        backButton.tintColor = .black
        backButton.backgroundColor = .white
    }
    
    func setUpText() {
        backButton.setTitle(StringConstants.back.localize, for: .normal)
    }
    
    func setUpCurve(){
        contentView.layer.insertSublayer(getCuredLayer(for: contentView.bounds), at: 0)
    }
}
