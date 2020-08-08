//
//  ChooseCurrencyViewController.swift
//  Paysera
//
//  Created by Jeric Miana on 8/8/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import UIKit

class ChooseCurrencyViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var selectButton: UIButton!
    private let currencyItems = ["EUR", "USD", "JPY"]
    var selectedCurrency: String?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
        
    // MARK: - Events
    
    @IBAction func dismissButtonPressed(sender: UIButton) {
        dismiss(animated: true) {
            
        }
    }
}

// MARK: - Configure UI

extension ChooseCurrencyViewController {
    private func configureUI() {
        selectButton.roundCorners()
        selectButton.setGradientBackground()
    }
}

// MARK: - TableView Delegate & Data Source

extension ChooseCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyItemCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = currencyItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
}
