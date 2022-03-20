//
//  SoftPosFirstStepViewController.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 21.01.2022.
//
//

import UIKit
import SOLIDArch
import DSKit

/// Экран первого шага офферты SoftPos тарифа
///
/// [Тесты](x-source-tag://DigitalSales.SoftPosFirstStepViewControllerTests)
/// - Tag: DigitalSales.SoftPosFirstStepViewController
final class SoftPosFirstStepViewController: UIViewController, LandingViewSetupProtocol, SoftPosRouter {

    // MARK: Dependencies
    var viewModel: SoftPosFirstStepViewModelProtocol?
    var diffableObserver: DiffableObserver?

    // MARK: UI
    private let landingTableVC: NATableViewController

    private let tableViewContainer = UIView()
    private let titleView = NavigationTitleView()

    private var titleVM: SubtitlableViewModelProtocol? {
        viewModel?.navigationViewModel
    }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.reloadData()
    }

    @objc
    func didTapBottomButton() {
        guard let vm = viewModel else {
            return
        }

        showSoftPosSecondStep(dataController: vm.softPosDataController)
    }
}

// MARK: - SwitchValueListening
extension SoftPosFirstStepViewController: SwitchValueListening {
    func switchValueDidChange(_ sender: Switch) {
        viewModel?.reloadData()
    }
}

// MARK: - StepperResponder
extension SoftPosFirstStepViewController: StepperResponder {
    func stepperViewDidTapDecrease(_ sender: StepperView) {
        stepperDidEnter(value: sender.viewModel?.value.advanced(by: -1))
    }

    func stepperViewDidTapIncrease(_ sender: StepperView) {
        stepperDidEnter(value: sender.viewModel?.value.advanced(by: 1))
    }

    func stepperViewDidEnterText(_ sender: StepperView) {
        let value = Int(sender.textFieldValue ?? "")
        stepperDidEnter(value: value)
    }

    private func stepperDidEnter(value: Int?) {
        guard let value = value else {
            return
        }

        viewModel?.updateTerminal(count: value)
        landingTableVC.tableView.reloadData()
    }
}
