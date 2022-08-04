//
//  String+Extention.swift
//  Things
//
//  Created by Aashini Sharma on 2022-08-01.
//

import Foundation

extension String {
    //Returns a localized string
    var localized:String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
