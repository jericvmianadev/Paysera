//
//  ViewController.swift
//  Paysera
//
//  Created by Jeric Miana on 8/8/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import UIKit
import IQDropDownTextField
import RxSwift
import RxCocoa

class CurrencyConverterViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var balanceCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var sellCurrencyDropdown: IQDropDownTextField!
    @IBOutlet weak var sellCurrencyTextField: UITextField!
    @IBOutlet weak var buyCurrencyDropdown: IQDropDownTextField!
    @IBOutlet weak var buyCurrencyLabel: UILabel!
    
    private let viewModel = CurrencyConverterViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTextFieldEditing()
        configureButtonTap()
        configureDropdowns()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        headerView.setGradientBackground()
        submitButton.setGradientBackground()
        submitButton.roundCorners()
    }
    
    // MARK: - Action Events
    
    private func configureTextFieldEditing() {
        sellCurrencyTextField.rx.controlEvent([.editingChanged])
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                /// Call convert currency API
                self?.convertCurrency()
            }.disposed(by: disposeBag)
    }
    
    private func configureButtonTap() {
        submitButton.rx.tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                /// TODO: Update/save user balance 
            }.disposed(by: disposeBag)
    }
    
    private func configureDropdowns() {
        let currencyItems = ["EUR", "USD", "JPY"]
        
        sellCurrencyDropdown.delegate = self
        sellCurrencyDropdown.isOptionalDropDown = false
        sellCurrencyDropdown.itemList = currencyItems
        sellCurrencyDropdown.selectedItem = currencyItems[0]
        
        buyCurrencyDropdown.delegate = self
        buyCurrencyDropdown.isOptionalDropDown = false
        buyCurrencyDropdown.itemList = currencyItems
        buyCurrencyDropdown.selectedItem = currencyItems[1]
    }
    
    // MARK: - Fetch Data
    
    private func convertCurrency() {
        if let sellCurrency = sellCurrencyDropdown.selectedItem,
            let buyCurrency = buyCurrencyDropdown.selectedItem,
            let amount = sellCurrencyTextField.text {
            
            viewModel.convertCurrency(sellCurrency: sellCurrency,
                                      buyCurrency: buyCurrency,
                                      amount: amount,
            success: { [weak self] (data) in
                DispatchQueue.main.async {
                    /// Display received amount
                    self?.buyCurrencyLabel.text = "+" + data.amount
                }
            },
            failure: { (error) in
                /// Show error message alert
                print(error)
            })
        }
    }
}

extension CurrencyConverterViewController: IQDropDownTextFieldDelegate {
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        convertCurrency()
    }
}
