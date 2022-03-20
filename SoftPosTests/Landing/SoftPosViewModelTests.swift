//
//  SoftPosViewModelTests.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 17.02.2022.
//
//

import XCTest
import DSKit

/// Тест [класса](x-source-tag://DigitalSales.SoftPosViewModel)
/// - Tag: DigitalSales.SoftPosViewModelTests
class SoftPosViewModelTests: XCTestCase {

    let dataController = SoftPosDataControllerStub()

    lazy var viewModel = SoftPosViewModel(
        tableViewModel: LandingTableViewModel(),
        builderFactory: SmartBetLandingBuildingFactoryMock(),
        softPosDataController: dataController
    )

    func testThatViewModelGetSliderRoundValueWithStep_2_000() {
        // arrange
        // act
        let value = viewModel.sliderCellDidChangeValue(value: 21430)

        // assert
        XCTAssertEqual(value, 20_000)
    }

    func testThatNumberOfSectionsEqual8() {
        // arrange
        let tableVM = viewModel.tableViewModel as? LandingTableViewModel

        // act
        viewModel.buildSections()

        // assert
        XCTAssertEqual(tableVM?.dataProvider.numberOfSections(), 7)
    }

    func testThatOnePercentTarificationTrueThenCalculatorHide() {
        // arrange
        dataController.isOnePercentTarification = true

        // act
        viewModel.buildSections()
        let tableVM = viewModel.tableViewModel as? LandingTableViewModel
        let row = tableVM?.dataProvider.itemForRow(atIndexPath: IndexPath(row: 1, section: 2)) as? BaseSimpleTextCellVM

        // assert
        XCTAssertEqual(row?.title, "От оборота на любую сферу деятельности")
    }
}
