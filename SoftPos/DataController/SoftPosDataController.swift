//
//  SoftPosDataController.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 29.11.2021.
//

import Foundation
import SMBCore

private enum Constants {
    static let minimumTerminals = 1
    static let maximumTerminals = 1000
    static let tradePointNameLatinMaxCount = 24
}

/// Контроллер данных для тарифа `SoftPos`
///
/// [Тесты](x-source-tag://DigitalSales.SoftPosDataControllerTests)
/// - Tag: DigitalSales.SoftPosDataController
final class SoftPosDataController: SoftPosDataControllerProtocol {
    var isOnePercentTarification: Bool {
        softPosData.commissionGroupTurnover.isOnePercentTarification
    }

    var tariffPercent: String {
        isOnePercentTarification ?
            "1" : "\(softPosData.commissionGroupTurnover.minCommissionPercent.stringUserFriendlyValue)"
    }

    var softPosViewModel = AcquiringAppSoftPosCreateCommand() {
        didSet {
            updateFooterVM()
        }
    }

    var landingFooterViewModel = SoftPosLandingFooterViewModel()

    var terminalCount: Int {
        get {
            softPosViewModel.terminalCount
        }

        set {
            guard newValue >= Constants.minimumTerminals,
                  newValue <= Constants.maximumTerminals else {
                return
            }

            softPosViewModel.terminalCount = newValue
        }
    }

    var selectedAccountIndex = 0

    var selectedAccount: PSBAccount? {
        accounts[safe: selectedAccountIndex]
    }
    let accounts: [PSBAccount]

    let secondStep = SecondStepResult()
    let softPosData: SoftPosData
    var frequentTransfer: FrequentTransferCost? {
        softPosData.frequentTransferCost.frequentTransferCostItems.first(where: { $0.terminalQuantityFrom...$0.terminalQuantityTo ~= terminalCount })
    }
    var frequentTransferCost: String? {
        frequentTransfer.map { "\($0.cost)" }
    }
    var activities: [SmartCommissionMCC] {
        softPosData.softPosCommission.mcc
    }

    private var selectedActivity: SmartCommissionMCC?

    init(
        softPosData: SoftPosData,
        accounts: [PSBAccount],
        userEmail: String?
    ) {
        self.softPosData = softPosData

        let clientRequisistes = softPosData.clientRequisistes
        secondStep.email.text = userEmail
        secondStep.reporingEmail.text = userEmail
        secondStep.companyName.text = clientRequisistes.tradePointName
        secondStep.address.text = clientRequisistes.tradePointAddress

        self.accounts = softPosData.userAccounts.compactMap({ (account) -> PSBAccount? in
            accounts.first(where: { account.code == $0.number })
        })
    }

    func fillViewModel() {
        softPosViewModel.notificationEmail = secondStep.email.text ?? ""
        softPosViewModel.tradePointNameRus = secondStep.companyName.text ?? ""
        softPosViewModel.tradePointNameLat = secondStep.multilineCompanyNameEn.text ?? ""
        softPosViewModel.tradePointWorkingHours = secondStep.openHours.text ?? ""
        softPosViewModel.tradePointAddress = secondStep.address.text ?? ""
        softPosViewModel.premisesOwnershipType = secondStep.placeOfTerminal.switchVM.isOn ? .own : .rent
        softPosViewModel.tradePointContactFullName = secondStep.fullName.text ?? ""
        softPosViewModel.tradePointContactPhone = secondStep.phoneNumber.text ?? ""
        softPosViewModel.reportDaily = secondStep.dailyReportCheckbox.isSelected
        softPosViewModel.reportWeekly = secondStep.weeklyReportCheckbox.isSelected
        softPosViewModel.reportMonthly = secondStep.monthlyReportCheckbox.isSelected
        if secondStep.dailyReportCheckbox.isSelected ||
            secondStep.monthlyReportCheckbox.isSelected ||
            secondStep.weeklyReportCheckbox.isSelected {
            softPosViewModel.reportEmail = secondStep.reporingEmail.text
        }
        softPosViewModel.promocode = secondStep.promocode.text
        softPosViewModel.fz223Customer = secondStep.fz223Customer.isSelected
        if secondStep.fz223Customer.isSelected {
            softPosViewModel.fz223PurchaseNumber = secondStep.purchaseNumber.text
        }
        softPosViewModel.account = selectedAccount?.number ?? ""
        softPosViewModel.isOnePercentTarification = isOnePercentTarification
        softPosViewModel.terminalCount = terminalCount
    }

    func supportQpsToggle(isOn: Bool) {
        softPosViewModel.supportQps = isOn
    }

    func supportFrequentTransferToggle(isOn: Bool) {
        softPosViewModel.supportFrequentTransfer = isOn
    }

    func supportCashRegisterToggle(isOn: Bool) {
        softPosViewModel.supportMobileCashRegister = isOn
    }

    func supportPayLinkToggle(isOn: Bool) {
        softPosViewModel.supportPayLink = isOn
    }

    func selectFieldOfActivity(mcc: SmartCommissionMCC) {
        selectedActivity = mcc
        softPosViewModel.mcc = mcc.mcc
    }
}

// MARK: Private
private extension SoftPosDataController {
    private func updateFooterVM() {
        landingFooterViewModel.phones.value = "\(softPosViewModel.terminalCount)"
        landingFooterViewModel.fieldOfActivity.value = selectedActivity?.name

        if isOnePercentTarification {
            landingFooterViewModel.comission.value = "1%"
        } else if let selectedActivity = selectedActivity {
            landingFooterViewModel.comission.value = SoftPosTexts.Offer.First.Section.Footer.Comission
                .value(selectedActivity.minCommissionText, selectedActivity.maxCommissionText)
        } else if
            let max = activities.max(by: { $0.maxCommissionPercent < $1.maxCommissionPercent }),
            let min = activities.min(by: { $0.minCommissionPercent < $1.minCommissionPercent }) {
            landingFooterViewModel.comission.value = SoftPosTexts.Offer.First.Section.Footer.Comission
                .value(min.minCommissionText, max.maxCommissionText)
        } else {
            landingFooterViewModel.comission.value = nil
        }

        if softPosViewModel.supportQps {
            if let selectedActivity = selectedActivity {
                landingFooterViewModel.qps.value = selectedActivity.qpcCommissionText + "%"
            } else {
                let limits = softPosData.limits
                landingFooterViewModel.qps.value = SoftPosTexts.Offer.First.Section.Footer.Qps.value(
                    limits.min.stringUserFriendlyValue,
                    limits.max.stringUserFriendlyValue
                )
            }
        } else {
            landingFooterViewModel.qps.value = nil
        }

        if softPosViewModel.supportFrequentTransfer,
           let cost = frequentTransferCost {
            landingFooterViewModel.fastPayments.value = SoftPosTexts.Offer.First.Section.Services.Stf.subtitle(cost)
        } else {
            landingFooterViewModel.fastPayments.value = nil
        }

        if softPosViewModel.supportMobileCashRegister {
            landingFooterViewModel.cashRegister.value = SoftPosTexts.Offer.First.Section.Footer.CashTarif.value
        } else {
            landingFooterViewModel.cashRegister.value = nil
        }

        if softPosViewModel.supportPayLink {
            landingFooterViewModel.payLink.value = SoftPosTexts.Offer.First.Section.Footer.CashTarif.value
        } else {
            landingFooterViewModel.payLink.value = nil
        }
    }
}
