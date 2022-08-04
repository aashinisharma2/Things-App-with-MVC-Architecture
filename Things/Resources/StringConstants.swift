//
//  StringConstants.swift
//  Things
//
//  Created by Aashini Sharma on 2022-07-29.
//

import Foundation

enum StringConstants: String {
    
    case homeHeaderHeading =  "THINGS"
    case homeHeaderDescription =  "The App"
    case next =  "Next"
    case back =  "Back"
    case chosenThings = "Chosen Things:"
    case addThing = "Add Things"
    case youCanAddThingsByName = "You can a thing with is name"
    case add = "Add"
    case cancel = "Cancel"
    case name = "Name"
    case delete = "Delete"
    case selectAtleastThreeThings = "Select atleast three things"
    case ok = "Ok"
    case alert = "Alert"
    
}

extension StringConstants {
    var localize: String {
        return self.rawValue.localized
    }
}
