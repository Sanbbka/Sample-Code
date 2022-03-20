//
//  SoftPosViewModelProtocol.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 29.11.2021.
//
//

import Foundation
import SOLIDArch

/// Протокол вью-модели лэндинга для тарифа `SoftPos`
/// - Tag: DigitalSales.SoftPosViewModelProtocol
protocol SoftPosViewModelProtocol {
    var softPosDataController: SoftPosDataControllerProtocol { get }

    func buildSections()
    func sliderCellDidChangeValue(value: Int) -> Int
}
