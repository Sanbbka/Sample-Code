//
//  SoftPosDataControllerProtocol.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 29.11.2021.
//
//

import Foundation
import SMBCore

/// Протокол контроллера данных для тарифа `SoftPos`
/// - Tag: DigitalSales.SoftPosDataControllerProtocol
protocol SoftPosDataControllerProtocol: AnyObject {
    var tariffPercent: String { get }
    var isOnePercentTarification: Bool { get }
    var softPosViewModel: AcquiringAppSoftPosCreateCommand { get }
    var landingFooterViewModel: SoftPosLandingFooterViewModel { get }
    var secondStep: SecondStepResult { get }
    var selectedAccount: PSBAccount? { get }
    var accounts: [PSBAccount] { get }
    var softPosData: SoftPosData { get }
    var frequentTransferCost: String? { get }

    var terminalCount: Int { get set }
    var selectedAccountIndex: Int { get set }

    func supportQpsToggle(isOn: Bool)
    func supportFrequentTransferToggle(isOn: Bool)
    func supportCashRegisterToggle(isOn: Bool)
    func supportPayLinkToggle(isOn: Bool)

    func selectFieldOfActivity(mcc: SmartCommissionMCC)
    func fillViewModel()
}
