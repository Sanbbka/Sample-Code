//
//  SoftPosSecondStepViewController.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 08.02.2022.
//
//

import UIKit
import SOLIDArch
import DSKit
import Signing
import Common
import Confirmation

/// Экран второго шага офферты SoftPos тарифа
///
/// [Тесты](x-source-tag://DigitalSales.SoftPosSecondStepViewControllerTests)
/// - Tag: DigitalSales.SoftPosSecondStepViewController
final class SoftPosSecondStepViewController: UIViewController, LandingViewSetupProtocol {

    private var fieldActivitySearchDelegate: SearchDelegate?

    // MARK: Dependencies
    var viewModel: SoftPosSecondStepViewModelProtocol? {
        didSet {
            viewModel?.successBlock = { [weak self] in
                self?.successAlert()
            }

            viewModel?.failureBlock = { [weak self] in
                self?.errorAlert()
            }

            viewModel?.invalidItemBlock = { [weak self] indexPath in
                self?.scrollToIndex(indexPath: indexPath)
            }

            viewModel?.loadingBlock = { [weak self] loading in
                self?.globalSpinner.set(isLoading: loading)
            }

            viewModel?.confirmationBlock = { [weak self] interactor, messageInfo in
                self?.confirmationRouter?.presentConfirmationController(
                    interactor: interactor,
                    messageInfo: messageInfo,
                    completion: nil
                )
            }

            if isViewLoaded {
                viewModel?.reloadData()
            }
        }
    }
    var confirmationRouter: PSBConfirmationConfiguratorRouterProtocol?
    var diffableObserver: DiffableObserver?

    // MARK: UI
    private let landingTableVC: NATableViewController
    private let tableViewContainer = UIView()
    private let titleView = NavigationTitleView()
    private var titleVM: SubtitlableViewModelProtocol? {
        viewModel?.navigationViewModel
    }
    private let globalSpinner = GlobalSpinner()
    private let transition = PopAnimator()

    // MARK: - Init
    init(landingTableVC: NATableViewController) {
        self.landingTableVC = landingTableVC

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.landingTableVC = NATableViewController()

        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setPSBBackArrowButton()

        setupUI(
            landingTableVC: landingTableVC,
            titleVM: titleVM,
            titleView: titleView,
            tableViewContainer: tableViewContainer
        )

        viewModel?.reloadData()
    }

    @objc
    func didTapBottomButton() {
        viewModel?.sendOfferData()
    }
}

// MARK: - Private alerts
private extension SoftPosSecondStepViewController {
    func openFieldOfActivites() {
        let delegate = SearchDelegate(completion: { [weak self] _, title in
            guard let title = title else {
                return
            }

            self?.viewModel?.selectFieldActivity(title: title)
            self?.fieldActivitySearchDelegate = nil
        })

        openSearchScreen(
            title: SoftPosTexts.Offer.Search.title,
            items: viewModel?.activitesVM ?? [],
            delegate: delegate
        )

        fieldActivitySearchDelegate = delegate
    }

    @objc
    func successAlert() {
        presentAlertScreen(
            title: viewModel?.successTitle,
            detail: viewModel?.successDetail,
            buttonText: SoftPosTexts.Offer.Second.Alert.Success.buttonText,
            success: true
        ) { [weak self] in
            self?.popBackToMainScreen()
        }
    }

    func errorAlert() {
        presentAlertScreen(
            title: viewModel?.errorTitle,
            detail: viewModel?.errorDetail,
            buttonText: SoftPosTexts.Offer.Second.Alert.Error.buttonText,
            success: false,
            action: nil
        )
    }
}

// MARK: - Action
@objc
extension SoftPosSecondStepViewController {
    func didTapFieldOfActivity() {
        openFieldOfActivites()
    }

    func didTapSelectAccount() {
        guard let viewModel = viewModel else {
            return
        }

        showAccountSelect(
            accounts: viewModel.accounts,
            selectedAccountIndex: viewModel.selectedAccountIndex,
            delegate: self,
            transitionDelegate: self
        )
    }
}

// MARK: - AccountSelectViewControllerDelegate
extension SoftPosSecondStepViewController: AccountSelectViewControllerDelegate {
    func updateSelectedAccountIndex(index: Int) {
        viewModel?.selectedAccountIndex = index
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension SoftPosSecondStepViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

// MARK: - MultilineFieldEditingEvents
extension SoftPosSecondStepViewController: MultilineFieldEditingEvents {
    func textDidChanged(_ sender: MultilineField) {
        updateMultilineField(sender)
    }

    func didBeginEditing(_ sender: MultilineField) {}

    func didEndEditing(_ sender: MultilineField) {
        updateMultilineField(sender)
    }

    private func updateMultilineField(_ sender: MultilineField) {
        if let identifier = sender.viewModel?.identifier,
           identifier == SoftPosSecondStep.Cell.LatinFieldName.id {
            viewModel?.updateLatinCompanyNameField(text: sender.text)
        } else {
            viewModel?.updateCompanyNameField(text: sender.text)
        }
    }
}

// MARK: - CheckboxClickListening
extension SoftPosSecondStepViewController: CheckboxClickListening {
    func checkboxDidClick(_ sender: BaseCheckboxView) {
        view.endEditing(true)
        viewModel?.reloadData()
    }
}

// MARK: - Private
private extension SoftPosSecondStepViewController {
    func scrollToIndex(indexPath: IndexPath) {
        landingTableVC.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
