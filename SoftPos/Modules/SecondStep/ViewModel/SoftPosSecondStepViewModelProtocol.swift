//
//  SoftPosSecondStepViewModelProtocol.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 08.02.2022.
//
//

import Foundation
import DSKit
import SMBCore
import SOLIDArch
import Confirmation
import Common

/// Протокол VM для второго шага оферты тарифа SoftPos
protocol SoftPosSecondStepViewModelProtocol: AnyObject {
    var successBlock: Closure? { get set }
    var failureBlock: Closure? { get set }
    var loadingBlock: ObjectClosure<Bool>? { get set }
    var invalidItemBlock: ObjectClosure<IndexPath>? { get set }
    var confirmationBlock: ((PSBBaseConfirmationInteractor, ConfirmMessageInfoProtocol) -> Void)? { get set }

    var successTitle: String { get }
    var successDetail: String { get }
    var errorTitle: String { get }
    var errorDetail: String { get }

    var selectedAccountIndex: Int { get set }
    var accounts: [PSBAccount] { get }
    var activitesVM: [BaseTitleAndSubtitleCellVM] { get }
    var navigationViewModel: SubtitlableViewModelProtocol { get }

    func reloadData()
    func sendOfferData()
    func selectFieldActivity(title: String)
    func updateCompanyNameField(text: String?)
    func updateLatinCompanyNameField(text: String?)
}
