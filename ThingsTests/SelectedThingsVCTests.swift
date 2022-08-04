//
//  SelectedThingsVCTests.swift
//  ThingsTests
//
//  Created by Aashini Sharma on 2022-08-02.
//

import XCTest
@testable import Things

class SelectedThingsVCTests: XCTestCase {

    // MARK: - Properties
    // ===================
    var sut: SelectedThingsVC!
    let fileName:StaticString = "SelectedThingsVCTests"

    // MARK: - Instance Methods
    // =========================

    override func setUp() {
        super.setUp()
        sut = SelectedThingsVC.instantiate(fromAppStoryboard: .main)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_IBoutlet_connectionst() throws {
        // Act and Assert
        _ = try XCTUnwrap(sut.selectedThingsTableView, "selectedThingsTableView not connected" ,file: fileName, line: 33)
        _ = try XCTUnwrap(sut.chosenThingsLbl, "chosenThingsLbl not connected" ,file: fileName, line: 34)
        _ = try XCTUnwrap(sut.headerView, "headerView not connected" ,file: fileName, line: 35)
        _ = try XCTUnwrap(sut.footerView, "footerView not connected" ,file: fileName, line: 36)
        _ = try XCTUnwrap(sut.headingLbl, "headingLbl not connected" ,file: fileName, line: 37)
        _ = try XCTUnwrap(sut.descriptionLbl, "descriptionLbl not connected" ,file: fileName, line: 38)
        _ = try XCTUnwrap(sut.backButton, "backButton not connected" ,file: fileName, line: 39)
        _ = try XCTUnwrap(sut.choosenThingsTableView, "choosenThingsTableView not connected" ,file: fileName, line: 40)
    }
    
    func test_Colors() {
        sut.viewWillAppear(true)
        XCTAssertEqual(sut.headingLbl.textColor, AppColors.textColor)
        XCTAssertEqual(sut.descriptionLbl.textColor, AppColors.textColor)
        XCTAssertEqual(sut.backButton.tintColor, AppColors.buttonsTintColor)
        XCTAssertEqual(sut.backButton.backgroundColor, AppColors.textColor)
        XCTAssertEqual(sut.chosenThingsLbl.textColor, AppColors.textColor)
        XCTAssertEqual(sut.chosenThingsLbl.backgroundColor, AppColors.themeColor)
    }
    
    
    func test_Textsetup() {
        sut.viewWillAppear(true)
        XCTAssertEqual(sut.headingLbl.text, StringConstants.homeHeaderHeading.localize)
        XCTAssertEqual(sut.descriptionLbl.text, StringConstants.homeHeaderDescription.localize)
        XCTAssertEqual(sut.chosenThingsLbl.text, StringConstants.chosenThings.localize)
    }
    
    func test_TableViewDelegateAndDataSource_ViewDidLoad_Success() throws {
        // Act and Assert
        XCTAssertNotNil(sut.selectedThingsTableView.delegate)
        XCTAssertNotNil(sut.selectedThingsTableView.dataSource)
        
        //Testing SelectedDataTableView
        
        XCTAssertNotNil(sut.choosenThingsTableView.delegate)
        XCTAssertNotNil(sut.choosenThingsTableView.dataSource)
    }
    
    func test_TableViewCell_NumberOfItemInSection_Success() {
        let noOfCells = sut.selectedThingsTableView.numberOfRows(inSection: 0)
        XCTAssertEqual(noOfCells, sut.thingsList.count)
        
    }
    
    func test_ThingsCellOutLets() throws {
        guard let cell = sut.selectedThingsTableView.dequeueReusableCell(withIdentifier: AppConstants.thingsCellIdentifier) as? ThingsCell else { return }
        XCTAssertNotNil(cell)
        _ = try XCTUnwrap(cell.thingNameLbl, "thingNameLbl not connected" ,file: fileName, line: 83)
        _ = try XCTUnwrap(cell.cardView, "cardView not connected" ,file: fileName, line: 84)
        _ = try XCTUnwrap(cell.checkMarkImgView, "    checkMarkImgView not connected" ,file: fileName, line: 85)
    }
    
    func test_ThingsCellColors() {
        guard let cell = sut.selectedThingsTableView.dequeueReusableCell(withIdentifier: AppConstants.thingsCellIdentifier) as? ThingsCell else { return }
        XCTAssertNotNil(cell)
        cell.awakeFromNib()
        XCTAssertEqual(cell.contentView.backgroundColor, UIColor.clear)
        XCTAssertEqual(cell.cardView.backgroundColor, AppColors.themeColor)
        XCTAssertEqual(cell.checkMarkImgView.tintColor, AppColors.themeLightColor)
        XCTAssertEqual(cell.thingNameLbl.textColor, AppColors.textColor)
    }
    
    func test_CellConfigureFunc() {
        guard let cell = sut.selectedThingsTableView.dequeueReusableCell(withIdentifier: AppConstants.thingsCellIdentifier) as? ThingsCell else { return }
        XCTAssertNotNil(cell)
        cell.awakeFromNib()
        let testData = ThingsData(name: "iPhone", isSelected: true)
        cell.configureCell(with: testData, withoutCheckmark: true)
        XCTAssertEqual(cell.thingNameLbl.text, testData.name)
        XCTAssertTrue(cell.checkMarkImgView.isHidden)
        
        let testData2 = ThingsData(name: "iPhone13", isSelected: false)
        cell.configureCell(with: testData2 , withoutCheckmark: true)
        XCTAssertEqual(cell.thingNameLbl.text, testData2.name)
        XCTAssertTrue(cell.checkMarkImgView.isHidden)
    }
    
    func test_SelectedCell_Outlets() throws {
        guard let cell = sut.choosenThingsTableView.dequeueReusableCell(withIdentifier: AppConstants.selectedThingsCellIdentifier) as? SelectedThingsCell else { return }
        _ = try XCTUnwrap(cell.thingNameLbl, "thingNameLbl not connected" ,file: fileName, line: 113)
        _ = try XCTUnwrap(cell.bottomConstraint, "bottomConstraint not connected" ,file: fileName, line: 114)
    }
    
    func test_SelectedCellCurveBottomFunc(){
        guard let cell = sut.choosenThingsTableView.dequeueReusableCell(withIdentifier: AppConstants.selectedThingsCellIdentifier) as? SelectedThingsCell else { return }
        cell.curveBottom()
        XCTAssertEqual(cell.contentView.layer.cornerRadius, AppConstants.cornerRadius)
        XCTAssertEqual(cell.bottomConstraint.constant, 10)
    }
    
    func test_SelectedCellColorSetupFunc() {
        guard let cell = sut.choosenThingsTableView.dequeueReusableCell(withIdentifier: AppConstants.selectedThingsCellIdentifier) as? SelectedThingsCell else { return }
        cell.awakeFromNib()
        XCTAssertEqual(cell.contentView.backgroundColor, AppColors.themeColor)
        XCTAssertEqual(cell.thingNameLbl.textColor, AppColors.textColor)
        XCTAssertEqual(cell.thingNameLbl.backgroundColor, AppColors.themeColor)
    }
    
    func test_BackButtonCornerRadius() {
        sut.viewWillLayoutSubviews()
        XCTAssertEqual(sut.backButton.layer.cornerRadius , AppConstants.cornerRadius)
    }
}
