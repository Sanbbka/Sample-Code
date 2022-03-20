//
//  SoftPosRouter.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 21.01.2022.
//

import SMBCore

/// Протокол роутера для SoftPos тарифа
/// - Tag: DigitalSales.LandingRouter
protocol SoftPosRouter: AnyObject {
    func showSoftPosFirstStep(dataController: SoftPosDataControllerProtocol)
    func showSoftPosSecondStep(dataController: SoftPosDataControllerProtocol)
}
