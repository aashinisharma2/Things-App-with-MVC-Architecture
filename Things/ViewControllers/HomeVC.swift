//
//  HomeVC.swift
//  Things
//
//  Created by Aashini Sharma on 2022-07-29.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    // ===================
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addThingsBtn: UIButton!
    
    // MARK: - Properties
    // ===================
    var thingsList: [ThingsData] = []
    
    // MARK: - View life Cycle
    // ===================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpApperingView()
        setUpColor()
        setUpText()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nextButton.layer.cornerRadius = AppConstants.cornerRadius
    }
    
    // MARK: - IBAction
    // ===================
    @IBAction func nextTapped(_ sender: Any) {
        
        var selectedThings: [ThingsData] = []
        for thing in thingsList {
            if thing.isSelected {
                selectedThings.append(thing)
            }
        }
        let validation = HomeVCValidation()
        let validationResult = validation.validate(selectedData: selectedThings)
        if validationResult.success {
            let selectedThingsVC = SelectedThingsVC.instantiate(fromAppStoryboard: .main)
            selectedThingsVC.thingsList = selectedThings
            navigationController?.pushViewController(selectedThingsVC, animated: true)
        } else {
            CommonFunctions.displayAlert(onVC: self, alertMessage: validationResult.errorMessage!)
        }
    }
    
    @IBAction func addThingsTapped(_ sender: UIButton) {
        CommonFunctions.showInputDialog(onVC: self,
                                        title: StringConstants.addThing.localize,
                                        subtitle: StringConstants.youCanAddThingsByName.localize,
                                        actionTitle: StringConstants.add.localize,
                                        cancelTitle: StringConstants.cancel.localize,
                                        inputPlaceholder: StringConstants.name.localize,
                                        inputKeyboardType: .default) { cancleAction in
            //do nothing
        } actionHandler: { [weak self]text in
            let newThing = ThingsData(name: text ?? "", isSelected: false)
            self?.thingsList.append(newThing)
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: (self?.thingsList.count ?? 1) - 1, section: 0),
                                        at: .bottom, animated: true)
        }
    }
}

// MARK: - Private Extention
// ===========================
private extension HomeVC {
    func initialSetUp() {
        setUpTableView()
        setUpHeader()
        setUpFooter()
        tableView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        WebServices.getThingsList(parameters: [:]) { [weak self] list in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.tableView.isHidden = false
                self.thingsList = list
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.tableView.reloadData()
            }
        } failure: { error in
            debugPrint(error)
        }
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        let itemNib = UINib(nibName: AppConstants.thingsCellIdentifier, bundle: nil)
        tableView.register(itemNib, forCellReuseIdentifier: AppConstants.thingsCellIdentifier)
    }
    
    func setUpColor() {
        headingLbl.textColor = AppColors.textColor
        descriptionLbl.textColor = AppColors.textColor
        nextButton.tintColor = AppColors.buttonsTintColor
        nextButton.backgroundColor = AppColors.textColor
        addThingsBtn.tintColor = AppColors.themeColor
    }
    
    func setUpText() {
        headingLbl.text = StringConstants.homeHeaderHeading.localize
        descriptionLbl.text = StringConstants.homeHeaderDescription.localize
        nextButton.setTitle(StringConstants.next.localize, for: .normal)
    }
    
    func setUpApperingView() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUpHeader() {
        headerView.layer.insertSublayer(CommonFunctions.getCuredAnimatedLayer(for: headerView.bounds,
                                                                      forView: .homeHeader), at: 0)
    }
    
    func setUpFooter() {
        footerView.layer.insertSublayer(CommonFunctions.getCuredAnimatedLayer(for: footerView.bounds,
                                                                      forView: .homeFooter), at: 0)
    }
}

// MARK: - TableViwe DataSource
// ================================
extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thingsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.thingsCellIdentifier,
                                                       for: indexPath) as? ThingsCell else { return UITableViewCell() }
        cell.configureCell(with: thingsList[indexPath.row])
        return cell
    }
}

// MARK: - Tableview Delegate
// ============================
extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ThingsCell else { return }
        //Updating cell
        cell.changeState()
        thingsList[indexPath.row].isSelected.toggle()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            thingsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: StringConstants.delete.localize) { [weak self] _, _, complete in
            self?.thingsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
