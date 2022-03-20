//
//  SoftPosLandingFactoryTest.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 05.03.2022.
//
//

import XCTest

/// Тест [класса](x-source-tag://DigitalSales.SoftPosLandingFactory)
/// - Tag: DigitalSales.SoftPosLandingFactoryTests
class SoftPosLandingFactoryTest: XCTestCase {

    func testThatFactoryMakeFullModule() {
        // arrange
        let factory = SoftPosLandingFactory()

        // act
        let vc = factory.makeVC(softPosData: SoftPosData.mockSuccess) as? SoftPosLandingViewController
        let vm = vc?.viewModel as? SoftPosViewModel

        // assert
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vm)
    }
}
