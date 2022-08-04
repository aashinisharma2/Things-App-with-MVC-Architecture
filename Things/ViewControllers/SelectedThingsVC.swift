//
//  SelectedThingsVC.swift
//  Things
//
//  Created by Aashini Sharma on 2022-08-01.
//

import UIKit

class SelectedThingsVC: UIViewController {
    
    // MARK: - Outlets
    // ===================
    @IBOutlet weak var selectedThingsTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var choosenThingsTableView: UITableView!
    @IBOutlet weak var chosenThingsLbl: UILabel!
    
    // MARK: - Properties
    // ===================
    var thingsList: [ThingsData] = []
    private var selectedData: [ThingsData] = []
    
    // MARK: - View life Cycle
    // ===================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        chosenThingsLbl.isHidden  = true
        setUpColor()
        setUpText()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        chosenThingsLbl.layer.cornerRadius = AppConstants.cornerRadius
        backButton.layer.cornerRadius = AppConstants.cornerRadius
    }
    
    // MARK: - IBActions
    // ===========================
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private Extention
// ===========================
private extension SelectedThingsVC {
    func initialSetUp() {
        chosenThingsLbl.layer.maskedCorners = [.layerMinXMinYCorner,
                                               .layerMaxXMinYCorner]
        chosenThingsLbl.clipsToBounds = true
        setUpTableView()
        setUpHeader()
        setUpFooter()
    }
    
    func setUpColor() {
        headingLbl.textColor = AppColors.textColor
        descriptionLbl.textColor = AppColors.textColor
        backButton.tintColor = AppColors.buttonsTintColor
        backButton.backgroundColor = AppColors.textColor
        chosenThingsLbl.textColor = AppColors.textColor
        chosenThingsLbl.backgroundColor = AppColors.themeColor
    }
    
    func setUpText() {
        headingLbl.text = StringConstants.homeHeaderHeading.localize
        descriptionLbl.text = StringConstants.homeHeaderDescription.localize
        backButton.setTitle(StringConstants.back.localize, for: .normal)
        chosenThingsLbl.text = StringConstants.chosenThings.localize
    }
    
    func setUpTableView() {
        selectedThingsTableView.delegate = self
        selectedThingsTableView.dataSource = self
        choosenThingsTableView.delegate = self
        choosenThingsTableView.dataSource = self
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        let itemNib = UINib(nibName: AppConstants.thingsCellIdentifier, bundle: nil)
        selectedThingsTableView.register(itemNib, forCellReuseIdentifier: AppConstants.thingsCellIdentifier)
        let selectedThingsNib = UINib(nibName: AppConstants.selectedThingsCellIdentifier, bundle: nil)
        choosenThingsTableView.register(selectedThingsNib, forCellReuseIdentifier: AppConstants.selectedThingsCellIdentifier)
    }
    
    func setUpHeader() {
        headerView.layer.insertSublayer(CommonFunctions.getCuredAnimatedLayer(for: headerView.bounds, forView: .selectedThingsVCHeader), at: 0)
    }
    
    func setUpFooter() {
        footerView.layer.insertSublayer(CommonFunctions.getCuredAnimatedLayer(for: footerView.bounds, forView: .selectedThingsVCFooter), at: 0)
    }
}

// MARK: - TableViwe DataSource
// ================================
extension SelectedThingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case choosenThingsTableView:
            return selectedData.count
        default:
            return thingsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case choosenThingsTableView:
            return 34
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case choosenThingsTableView:
            guard let cell = choosenThingsTableView.dequeueReusableCell(withIdentifier: AppConstants.selectedThingsCellIdentifier,
                                                                        for: indexPath) as? SelectedThingsCell else { return UITableViewCell() }
            cell.configureCell(with: selectedData[indexPath.row])
            if indexPath.row == selectedData.count-1 {
                cell.curveBottom()
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.thingsCellIdentifier,
                                                           for: indexPath) as? ThingsCell else { return UITableViewCell() }
            cell.configureCell(with: thingsList[indexPath.row], withoutCheckmark: true)
            return cell
        }
    }
}

// MARK: - Tableview Delegate
// ============================
extension SelectedThingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == choosenThingsTableView{
            return
        }
        selectedData.append(thingsList[indexPath.row])
        thingsList.remove(at: indexPath.row)
        selectedThingsTableView.deleteRows(at: [indexPath], with: .right)
        choosenThingsTableView.reloadData()
        chosenThingsLbl.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == selectedThingsTableView {
                return
            }
            let deletedData = selectedData[indexPath.row]
            self.thingsList.append(deletedData)
            selectedData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            selectedThingsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == selectedThingsTableView {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: StringConstants.delete.localize) { [weak self] _, _, complete in
            
            if let deletedData = self?.selectedData[indexPath.row]{
                self?.thingsList.append(deletedData )
                self?.selectedData.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.selectedThingsTableView.reloadData()
            complete(true)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
