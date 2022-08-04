//
//  CommanFunctions.swift
//  Things
//
//  Created by Aashini Sharma on 2022-08-01.
//

import Foundation
import UIKit

class CommonFunctions {
    
    // Delay Functions
    static func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
    }
    
    // Show Alert box with input file
    static func showInputDialog(onVC: UIViewController , title:String? = nil,
                                subtitle:String? = nil,
                                actionTitle:String? = StringConstants.add.localize,
                                cancelTitle:String? = StringConstants.cancel.localize,
                                inputPlaceholder:String? = nil,
                                inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                                cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        onVC.present(alert, animated: true, completion: nil)
    }
    
    // Display an alert with msg and ok button
    static func displayAlert( onVC:UIViewController, alertMessage: String) {
        let alert = UIAlertController(title: StringConstants.alert.localize, message:alertMessage , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.ok.localize, style: .default, handler: nil))
        onVC.present(alert, animated: true)
    }
    
    // Get cureved animatedLayer
    static func getCuredAnimatedLayer(for rect: CGRect , with color: CGColor = UIColor.darkGray.cgColor , forView: CurvedLayerFor) -> CAShapeLayer{
       
        let layer = CAShapeLayer()
        layer.fillColor = color
        var path = CGPath(rect: rect, transform: nil)
        switch forView {
        case .homeHeader , .selectedThingsVCHeader:
            path = getPathForHeader(for: rect)
        case .homeFooter:
            path = getPathForFooterOfHomeVC(for: rect)
        case .selectedThingsVCFooter:
            path = getPathForFooterOfSeletionedItemVC(for: rect)
        }
        layer.path = path
        
        let path2 = UIBezierPath(roundedRect: rect, cornerRadius: 20.0)
        path2.append(UIBezierPath(rect: rect))

        // create new animation
        let anim = CABasicAnimation(keyPath: "path")

        // from value is the current layer path
        anim.fromValue = CGPath(rect: .zero, transform: nil)

        // to value is the new path
        anim.toValue = path

        // duration of your animation
        anim.duration = 1.0

        // custom timing function to make it look smooth
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        // add animation
        layer.add(anim, forKey: "path")

        // update the path property on the layer, using a CATransaction to prevent an implicit animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.path = path
        CATransaction.commit()
        return layer
    }
    
    // Get cgpath for home header
    static private func getPathForHeader(for rect: CGRect)-> CGPath{
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
    
    // Get cgpath for home footer
    static private func getPathForFooterOfHomeVC(for rect: CGRect)-> CGPath{
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
    
    // Get cgpath for Selected itemVC footer
    static private func getPathForFooterOfSeletionedItemVC(for rect: CGRect)-> CGPath{
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
        //
        return path.cgPath
    }
}
