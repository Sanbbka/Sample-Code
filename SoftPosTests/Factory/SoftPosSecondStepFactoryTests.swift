//
//  SoftPosSecondStepFactoryTests.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 05.03.2022.
//
//

import XCTest

/// Тест [класса](x-source-tag://DigitalSales.SoftPosSecondStepFactory)
/// - Tag: DigitalSales.SoftPosSecondStepFactoryTests
class SoftPosSecondStepFactoryTests: XCTestCase {

    func testThatFactoryMakeFullModule() {
        // arrange
        let factory = SoftPosSecondStepFactory(softPosDataController: SoftPosDataControllerStub())

        // act
        let vc = factory.makeVC() as? SoftPosSecondStepViewController
        let vm = vc?.viewModel as? SoftPosSecondStepViewModel

        // assert
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vm)
        XCTAssertNotNil(vc?.diffableObserver)
    }
}
