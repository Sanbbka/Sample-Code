//
//  SoftPosLandingViewController.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 29.11.2021.
//
//

import UIKit
import SOLIDArch
import DSKit
import PSBCore

/// Лэндинг тарифа `SoftPos`
///
/// [Тесты](x-source-tag://DigitalSales.SoftPosLandingViewControllerTests)
/// - Tag: DigitalSales.SoftPosLandingViewController
final class SoftPosLandingViewController: UIViewController {

    // MARK: Dependencies
    var viewModel: SoftPosViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }

    private var diffableObserver: DiffableObserver?

    // MARK: UI
    private let landingTableVC: UITableViewController

    private let tableViewContainer = UIView()
    private let bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = DSColors.Background.colorBackground.color

        return view
    }()

    private let bottomButton: PrimaryButton = {
        let button = PrimaryButton(type: .custom)
        button.setTitle(
            SoftPosTexts.Landing.BottomButton.title,
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(didTapBottomButton),
            for: .touchUpInside
        )

        return button
    }()

    private let titleView = NavigationTitleView()

    // MARK: - Init
    init(
        landingTableVC: UITableViewController,
        diffableObserver: DiffableObserver?
    ) {
        self.landingTableVC = landingTableVC
        self.diffableObserver = diffableObserver

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.landingTableVC = NATableViewController()

        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setPSBBackArrowButton()
        setupUI()
        reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        showNavigationBar()
    }

    @IBAction func sliderValueDidChanged(_ sender: DSSlider) {
        if let value = viewModel?.sliderCellDidChangeValue(value: Int(sender.value)) {
            sender.value = Float(value)
        }

        reloadData()
    }

    private func bindViewModel() {
        reloadData()
    }

    private func reloadData() {
        viewModel?.buildSections()
    }
}

// MARK: - Setup
private extension SoftPosLandingViewController {
    func setupUI() {
        setupNavigation()
        setupTable()
        setupBottom()
        setupConstraints()
    }

    func setupNavigation() {
        hideNavigationBar()
    }

    func setupTable() {
        landingTableVC.tableView.hideKeyboardOnTap()
        landingTableVC.tableView.backgroundColor = DSColors.Background.colorOnBackgroundThird.color
        view.addSubview(tableViewContainer)
        add(landingTableVC, to: tableViewContainer)
        landingTableVC.tableView.separatorStyle = .none
    }

    func setupBottom() {
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomButton)
    }

    func setupConstraints() {
        tableViewContainer.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }

        landingTableVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        bottomContainer.snp.makeConstraints { (make) in
            make.top.equalTo(tableViewContainer.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        bottomButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(.level6)
        }
    }
}

// MARK: - Action
@objc
extension SoftPosLandingViewController: SoftPosRouter {
    func didTapBottomButton() {
        guard let dataController = viewModel?.softPosDataController else {
            return
        }

        showSoftPosFirstStep(dataController: dataController)
    }
}

extension SoftPosLandingViewController: ProductLandingQuestionExpandedListener {
    func expandedChanging(_ sender: ProductLandingQuestionTableViewCell) {
        viewModel?.buildSections()
    }
}

extension SoftPosLandingViewController: ChipsTagResponder {
    func chipsViewDidTapTag(_ sender: ChipsView) {
        reloadData()
    }
}
