//
//  SoftPosFirstStepFactoryTests.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 17.02.2022.
//
//

import XCTest
import UIKit
import SOLIDArch

/// Тест [класса](x-source-tag://DigitalSales.SoftPosFirstStepFactory)
/// - Tag: DigitalSales.SoftPosFirstStepFactoryTests
class SoftPosFirstStepFactoryTests: XCTestCase {

    func testThatFactoryMakeFullModule() {
        // arrange
        let factory = SoftPosFirstStepFactory(softPosDataController: SoftPosDataControllerStub())

        // act
        let vc = factory.makeVC()
        let firstSoftPosVC = vc as? SoftPosFirstStepViewController
        let firstSoftPosVM = firstSoftPosVC?.viewModel as? SoftPosFirstStepViewModel

        // assert
        XCTAssertNotNil(firstSoftPosVC)
        XCTAssertNotNil(firstSoftPosVM)
        XCTAssertNotNil(firstSoftPosVC?.diffableObserver)
        XCTAssertNotNil(firstSoftPosVM?.bottomAction)
    }
}
