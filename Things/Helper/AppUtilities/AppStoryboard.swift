//
//  AppStoryboard.swift
//  Things
//
//  Created by Aashini Sharma on 2022-08-02.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    case main = "Main"
}
extension AppStoryboard {

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(_ viewControllerClass: T.Type,
                                             function: String = #function, // debugging purposes
                                             line: Int = #line,
                                             file: String = #file) -> T {

        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID

        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {

            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile: \(file) \nLine Number: \(line) \nFunction: \(function)")
        }
        return scene
    }

    func initialViewController() -> UIViewController? {

        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    class var storyboardID: String {

        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(self)
    }
}
