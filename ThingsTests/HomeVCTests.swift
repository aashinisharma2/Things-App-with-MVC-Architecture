//
//  HomeVCTests.swift
//  ThingsTests
//
//  Created by Aashini Sharma on 2022-08-02.
//

import XCTest
@testable import Things

class HomeVCTests: XCTestCase {

    // MARK: - Properties
    // ===================
    var sut: HomeVC!
    let fileName:StaticString = "HomeVCTests"

    // MARK: - Instance Methods
    // =========================

    override func setUp() {
        super.setUp()
        sut = HomeVC.instantiate(fromAppStoryboard: .main)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_IBoutlet_connectionst() throws {
        // Act and Assert
        _ = try XCTUnwrap(sut.tableView, "tableView not connected" ,file: fileName, line: 33)
        _ = try XCTUnwrap(sut.activityIndicator, "activityIndicator not connected" ,file: fileName, line: 34)
        _ = try XCTUnwrap(sut.headerView, "headerView not connected" ,file: fileName, line: 35)
        _ = try XCTUnwrap(sut.footerView, "footerView not connected" ,file: fileName, line: 36)
        _ = try XCTUnwrap(sut.headingLbl, "headingLbl not connected" ,file: fileName, line: 37)
        _ = try XCTUnwrap(sut.descriptionLbl, "descriptionLbl not connected" ,file: fileName, line: 38)
        _ = try XCTUnwrap(sut.nextButton, "nextButton not connected" ,file: fileName, line: 39)
        _ = try XCTUnwrap(sut.addThingsBtn, "addThingsBtn not connected" ,file: fileName, line: 40)
    }
    
    func test_Colors(){
        sut.viewWillAppear(true)
        XCTAssertEqual(sut.headingLbl.textColor, AppColors.textColor)
        XCTAssertEqual(sut.descriptionLbl.textColor, AppColors.textColor)
        XCTAssertEqual(sut.nextButton.tintColor, AppColors.buttonsTintColor)
        XCTAssertEqual(sut.nextButton.backgroundColor, AppColors.textColor)
        XCTAssertEqual(sut.addThingsBtn.tintColor, AppColors.themeColor)
    }
    
    
    func test_Textsetup(){
        sut.viewWillAppear(true)
        XCTAssertEqual(sut.headingLbl.text, StringConstants.homeHeaderHeading.localize)
        XCTAssertEqual(sut.descriptionLbl.text, StringConstants.homeHeaderDescription.localize)
        XCTAssertEqual(sut.nextButton.titleLabel?.text, StringConstants.next.localize)
    }
    
    func test_TableViewDelegateAndDataSource_ViewDidLoad_Success() throws {
        // Act and Assert
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertNotNil(sut.tableView.dataSource)
    }
    
    func test_TableViewCell_NumberOfItemInSection_Success() {
        let noOfCells = sut.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(noOfCells, sut.thingsList.count)
    }

    func test_getDataApi(){
        let expectations = expectation(description: "Wating for getData API")
        var data:[ThingsData] = []
        var error:String = ""
        WebServices.getThingsList(parameters: [:]) { list in
            data = list
            expectations.fulfill()
        } failure: { err in
            error = err.localizedDescription
            expectations.fulfill()
        }
        self.wait(for: [expectations], timeout: 2)
        if data.isEmpty {
            XCTAssertFalse(error.isEmpty)
        }
        if error.isEmpty {
            XCTAssertFalse(data.isEmpty)
        }
    }
    
    func test_ThingsCellOutLets() throws {
        guard let cell = sut.tableView.dequeueReusableCell(withIdentifier: AppConstants.thingsCellIdentifier) as? ThingsCell else { return }
        XCTAssertNotNil(cell)
        _ = try XCTUnwrap(cell.thingNameLbl, "thingNameLbl not connected" ,file: fileName, line: 97)
        _ = try XCTUnwrap(cell.cardView, "cardView not connected" ,file: fileName, line: 98)
        _ = try XCTUnwrap(cell.checkMarkImgView, "    checkMarkImgView not connected" ,file: fileName, line: 99)
    }
    
    func test_ThingsCellColors() {
        guard let cell = sut.tableView.dequeueReusableCell(withIdentifier: AppConstants.thingsCellIdentifier) as? ThingsCell else { return }
        XCTAssertNotNil(cell)
        cell.awakeFromNib()
        XCTAssertEqual(cell.contentView.backgroundColor, UIColor.clear)
        XCTAssertEqual(cell.cardView.backgroundColor, AppColors.themeColor)
        XCTAssertEqual(cell.checkMarkImgView.tintColor, AppColors.themeLightColor)
        XCTAssertEqual(cell.thingNameLbl.textColor, AppColors.textColor)
    }
    
    func test_CellStates(){
        guard let cell = sut.tableView.dequeueReusableCell(withIdentifier: AppConstants.thingsCellIdentifier) as? ThingsCell else { return }
        XCTAssertNotNil(cell)
        cell.awakeFromNib()
        cell.isCheckmarked = true
        cell.changeState()
        XCTAssertFalse(cell.isCheckmarked)
        XCTAssertTrue(cell.checkMarkImgView.isHidden)
        cell.changeState()
        XCTAssertTrue(cell.isCheckmarked)
        XCTAssertFalse(cell.checkMarkImgView.isHidden)
    }
    
    func test_CellConfigureFunc(){
        guard let cell = sut.tableView.dequeueReusableCell(withIdentifier: AppConstants.thingsCellIdentifier) as? ThingsCell else { return }
        XCTAssertNotNil(cell)
        cell.awakeFromNib()
        let testData = ThingsData(name: "iPhone", isSelected: true)
        cell.configureCell(with: testData)
        XCTAssertEqual(cell.thingNameLbl.text, testData.name)
        XCTAssertEqual(cell.isCheckmarked, testData.isSelected)
        XCTAssertFalse(cell.checkMarkImgView.isHidden)
        
        let testData2 = ThingsData(name: "iPhone13", isSelected: false)
        cell.configureCell(with: testData2)
        XCTAssertEqual(cell.thingNameLbl.text, testData2.name)
        XCTAssertEqual(cell.isCheckmarked, testData2.isSelected)
        XCTAssertTrue(cell.checkMarkImgView.isHidden)
    }
    
    func test_NextButtonCornerRadius(){
        sut.viewWillLayoutSubviews()
        XCTAssertEqual(sut.nextButton.layer.cornerRadius , AppConstants.cornerRadius)
    }
}
