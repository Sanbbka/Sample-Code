//
//  SoftPosSecondStepViewModel.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 08.02.2022.
//
//

import SOLIDArch
import SMBCore
import UIKit
import DSKit
import Confirmation
import Common
import Signing
import PSBCore

/// VM для второго шага оферты тарифа SoftPos
///
/// [Тесты](x-source-tag://DigitalSales.SoftPosSecondStepViewModelTests)
/// - Tag: DigitalSales.SoftPosSecondStepViewModel
final class SoftPosSecondStepViewModel: SoftPosSecondStepViewModelProtocol {

    var confirmationDidCancel = false

    var successTitle: String {
        if hasSignAndExecutePermission && !confirmationDidCancel {
            return SoftPosTexts.Offer.Second.Alert.Success.title
        } else {
            return SoftPosTexts.Offer.Second.Alert.Save.Success.title
        }
    }

    var successDetail: String {
        if hasSignAndExecutePermission && !confirmationDidCancel {
            return SoftPosTexts.Offer.Second.Alert.Success.detail(
                softPosDataController.softPosViewModel.tradePointContactPhone
            )
        } else {
            return SoftPosTexts.Offer.Second.Alert.Save.Success.detail
        }
    }

    var errorTitle: String {
        if hasSignAndExecutePermission {
            return SoftPosTexts.Offer.Second.Alert.Error.title
        } else {
            return SoftPosTexts.Offer.Second.Alert.Save.Error.title
        }
    }

    var errorDetail: String {
        SoftPosTexts.Offer.Second.Alert.Error.detail
    }

    var successBlock: Closure?
    var failureBlock: Closure?
    var loadingBlock: ObjectClosure<Bool>?
    var invalidItemBlock: ObjectClosure<IndexPath>?
    var confirmationBlock: ((PSBBaseConfirmationInteractor, ConfirmMessageInfoProtocol) -> Void)?

    var navigationViewModel: SubtitlableViewModelProtocol {
        TitleAndSubtitleVM(
            title: SoftPosTexts.Offer.Second.Navigation.title,
            subtitle: SoftPosTexts.Offer.Second.Navigation.subtitle
        )
    }

    var activitesVM: [BaseTitleAndSubtitleCellVM] {
        smartCommissionMCC.compactMap {
            let title: String

            if softPosDataController.isOnePercentTarification {
                title = $0.descriptionWithOnePercent(qpsEnable: softPosDataController.softPosViewModel.supportQps)
            } else {
                title = $0.descritption(qpsEnable: softPosDataController.softPosViewModel.supportQps)
            }

            return BaseTitleAndSubtitleCellVM(
                title: title,
                subtitle: $0.name
            )
        }
    }

    var selectedAccountIndex: Int {
        get {
            softPosDataController.selectedAccountIndex
        }

        set {
            softPosDataController.selectedAccountIndex = newValue
            buildSections()
        }
    }

    var accounts: [PSBAccount] {
        softPosDataController.accounts
    }

    let builderFactory: SmartBetLandingBuildingFactoryProtocol
    var result: SecondStepResult {
        softPosDataController.secondStep
    }
    var smartCommissionMCC: [SmartCommissionMCC] {
        softPosDataController.softPosData.softPosCommission.mcc
    }
    let permission: Permission?
    var bottomAction: SelectorEvent?
    let softPosDataController: SoftPosDataControllerProtocol

    private let tableViewModel: LandingTableViewModelProtocol
    private let documentProvider: DocumentSigningProviderProtocol
    private var provider: AcquiringProviderProtocol
    private let cyrillicCompanyNameValidator: RegexValidatorProtocol

    var hasSignAndExecutePermission: Bool {
        guard let permission = permission else {
            return false
        }

        return permission.firstSign &&
            permission.secondSign &&
            permission.executor
    }

    init(
        tableViewModel: LandingTableViewModelProtocol,
        builderFactory: SmartBetLandingBuildingFactoryProtocol,
        softPosDataController: SoftPosDataControllerProtocol,
        documentProvider: DocumentSigningProviderProtocol,
        provider: AcquiringProviderProtocol,
        permission: Permission?,
        cyrillicCompanyNameValidator: RegexValidatorProtocol
    ) {
        self.tableViewModel = tableViewModel
        self.builderFactory = builderFactory
        self.softPosDataController = softPosDataController
        self.documentProvider = documentProvider
        self.provider = provider
        self.permission = permission
        self.cyrillicCompanyNameValidator = cyrillicCompanyNameValidator

        result.companyName.bottomText = nil
        result.companyName.errorText = SoftPosTexts.Offer.Second.FieldName.Rus.error
        result.phoneNumber.bottomText = nil
    }

    func reloadData() {
        buildSections()
    }

    func selectFieldActivity(title: String) {
        guard let mcc = smartCommissionMCC.first(where: { $0.name == title }) else {
            return
        }

        result.fieldOfActivity.text = title
        softPosDataController.selectFieldOfActivity(mcc: mcc)

        reloadData()
    }

    func updateCompanyNameField(text: String?) {
        result.companyName.text = text
        let isValidText = cyrillicCompanyNameValidator.isValid(text)
        result.companyName.isError = !isValidText
        result.companyName.fieldWasFirstResponder = true
        buildSections()
    }

    func updateLatinCompanyNameField(text: String?) {
        result.multilineCompanyNameEn.text = text
        let isValidText = result.companyNameEn.validator?.isValid(text) ?? false
        result.multilineCompanyNameEn.isError = !isValidText
        result.multilineCompanyNameEn.fieldWasFirstResponder = true
        buildSections()
    }

    func sendOfferData() {
        let errorBlock: ObjectClosure<String> = { [weak self] _ in
            self?.stopLoading()
            self?.failureBlock?()
        }

        let successWithoutPermissionBlock = { [weak self] in
            self?.stopLoading()
            self?.successBlock?()
        }

        let successWithPermissionBlock: ObjectClosure<ConfirmMessageInfoProtocol> = { [weak self] confirmMessage in
            guard let self = self else {
                return
            }

            self.stopLoading()
            let interactor: PSBBaseConfirmationInteractor

            if self.hasSignAndExecutePermission {
                interactor = PSBBaseConfirmationInteractor(paramsToResend: [:])
            } else {
                interactor = PSBSignConfirmationInteractor(paramsToResend: [:])
            }

            interactor.delegate = self
            self.confirmationBlock?(interactor, confirmMessage)
        }

        let invalidItems = findInvalidFieldsVM()
        guard
            invalidItems.isEmpty
        else {
            findInvalidIndex(invalidItems: invalidItems)
            return
        }

        softPosDataController.fillViewModel()

        startLoading()
        provider.createSoftPosOffer(
            data: softPosDataController.softPosViewModel) { [weak self] (result) in
            guard let self = self else {
                return
            }

            switch result {
            case .failure(let error):
                errorBlock(error.localizedDescription)

            case .success(let response):
                if let permission = self.permission,
                   !permission.firstSign && !permission.secondSign {
                    successWithoutPermissionBlock()
                    return
                }

                self.sign(
                    document: response.document,
                    successCompletion: successWithPermissionBlock,
                    errorCompletion: errorBlock
                )
            }
        }
    }
}

// MARK: - PSBBaseConfirmationInteractorDelegate
extension SoftPosSecondStepViewModel: PSBBaseConfirmationInteractorDelegate {
    func confirmationInteractorDidFinishProcess(
        withSuccess success: Bool,
        message: String?,
        docHeader: [AnyHashable: Any]?
    ) {
        if success {
            successBlock?()
        } else {
            failureBlock?()
        }
    }

    func confirmationInteractorDidPressCancel() {
        confirmationDidCancel = true
        successBlock?()
    }
}

// MARK: - Private
private extension SoftPosSecondStepViewModel {
    func buildSections() {
        tableViewModel.update(sections: sections)
    }

    func sign(
        document: DocumentHeader,
        successCompletion: @escaping ObjectClosure<ConfirmMessageInfoProtocol>,
        errorCompletion: @escaping ObjectClosure<String>
    ) {
        self.documentProvider.signRequest(
            docHeader: document.makePSBDocumentHeaderDict(),
            onSuccess: successCompletion,
            onError: errorCompletion
        )
    }

    func startLoading() {
        loadingBlock?(true)
    }

    func stopLoading() {
        loadingBlock?(false)
    }

    func findInvalidFieldsVM() -> [NAItemViewModel] {
        updateCompanyNameField(text: result.companyName.text)
        updateLatinCompanyNameField(text: result.multilineCompanyNameEn.text)

        let rows = sections.flatMap { $0.objects }
        return rows.compactMap { row -> NAItemViewModel? in
            if let textField = row as? TextFieldCellVM {
                textField.text = textField.text
                textField.fieldWasFirstResponder = true

                return textField.isError ? textField : nil
            }

            if let multilineTextField = row as? MultilineFieldVM {
                return multilineTextField.isError ? multilineTextField : nil
            }

            return nil
        }
    }

    func findInvalidIndex(invalidItems: [NAItemViewModel]) {
        guard let item = invalidItems.first else {
            return
        }

        let sectionViewModels = sections
        for sectionIndex in 0..<sectionViewModels.count {
            let section = sectionViewModels[sectionIndex]
            if let rowIndex = section.objects.firstIndex(where: { $0.identifier == item.identifier }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                invalidItemBlock?(indexPath)
                return
            }
        }
    }
}
