//
//  HomeVCValidation.swift
//  Things
//
//  Created by Aashini Sharma on 2022-08-04.
//

import Foundation

struct HomeVCValidation  {

    func validate(selectedData: [ThingsData] ) -> ValidationResult {

        if selectedData.count > 2 {
            return ValidationResult(success: true, errorMessage: nil)
        }
        return ValidationResult(success: false, errorMessage: StringConstants.selectAtleastThreeThings.localize )
    }
}

