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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var sellCurrencyDropdown: IQDropDownTextField!
    @IBOutlet weak var sellCurrencyTextField: UITextField!
    @IBOutlet weak var buyCurrencyDropdown: IQDropDownTextField!
    @IBOutlet weak var buyCurrencyLabel: UILabel!
    
    private let currencyItems = ["EUR", "USD", "JPY"]

    private let persistenceManager = PersistenceManager()
    private let viewModel = CurrencyConverterViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFieldEditing()
        configureButtonTap()
        configureDropdowns()
        configureCollectionView()
        
        updateExchangeRates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        titleLabel.text = Strings.App.name
        headerView.setGradientBackground()
        submitButton.setGradientBackground()
        submitButton.roundCorners()
    }
    
    private func configureDropdowns() {
        sellCurrencyDropdown.delegate = self
        sellCurrencyDropdown.isOptionalDropDown = false
        sellCurrencyDropdown.itemList = currencyItems
        sellCurrencyDropdown.selectedItem = currencyItems[0]
        
        buyCurrencyDropdown.delegate = self
        buyCurrencyDropdown.isOptionalDropDown = false
        buyCurrencyDropdown.itemList = currencyItems
        buyCurrencyDropdown.selectedItem = currencyItems[1]
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BalanceCollectionViewCell.nib, forCellWithReuseIdentifier: BalanceCollectionViewCell.reuseIdentifier)
        
    }
    
    // MARK: - Action Events
    
    private func configureTextFieldEditing() {
        sellCurrencyTextField.rx.controlEvent([.editingChanged])
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.convertCurrency()
            }.disposed(by: disposeBag)
        
        sellCurrencyTextField.rx.controlEvent([.editingDidEnd])
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                if let sellDoubleValue = self?.sellCurrencyTextField.text?.doubleValue {
                    self?.sellCurrencyTextField.text = "\(sellDoubleValue)"
                }
            }.disposed(by: disposeBag)
    }
    
    private func configureButtonTap() {
        submitButton.rx.tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.convertCurrency(shouldUpdateBalance: true)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Fetch Data

extension CurrencyConverterViewController {
    func convertCurrency(shouldUpdateBalance: Bool = false) {
        if let sellCurrency = sellCurrencyDropdown.selectedItem,
            let buyCurrency = buyCurrencyDropdown.selectedItem,
            sellCurrency != buyCurrency,
            let sellValue = sellCurrencyTextField.text,
            sellValue.isNumeric && sellValue.doubleValue > 0,
            let buyValue = buyCurrencyLabel.text,
            let comissionFee = viewModel.computeComissionFee(sellValue: sellValue.doubleValue) {
            
            viewModel.convertCurrency(sellCurrency: sellCurrency,
                                      buyCurrency: buyCurrency,
                                      amount: sellValue,
            success: { [weak self] (data) in
                
                DispatchQueue.main.async {
                    /// Display received amount
                    self?.buyCurrencyLabel.text = "+" + data.amount
                    
                    /// Update and save user balance
                    if shouldUpdateBalance {
                        self?.persistenceManager.updateUserBalance(
                            sellValue: sellValue.doubleValue,
                            sellCurrency: sellCurrency,
                            buyValue: buyValue.doubleValue,
                            buyCurrency: buyCurrency,
                            comissionFee: comissionFee,
                            success: {
                                /// Show success alert
                                self?.showAlert(withTitle: Strings.Alert.Title.currencyConverted,
                                                message: Strings.Alert.Message.currencyConverted("\(sellValue.doubleValue) \(sellCurrency)", "\(data.amount) \(data.currency)", "\(comissionFee.round()) \(sellCurrency)"),
                                                actionTitle: Strings.Alert.Action.done)
                                /// Update user balance display
                                self?.collectionView.reloadData()
                            },
                            failure: { error in
                                /// Show error alert
                                self?.showAlert(message: error)
                            }
                        )
                    }
                }
            },
            failure: { [weak self] (error) in
                /// Show error modal
                DispatchQueue.main.async {
                    self?.showAlert(message: error)
                }
            })
        } else {
            /// If sell value is not valid, clear buy value text
            self.buyCurrencyLabel.text = ""
        }
    }
    
    func updateExchangeRates() {
        /// Update exchange rates every 5 seconds
        Timer.scheduledTimer(withTimeInterval: Constants.requestTime, repeats: true) { [weak self] _ in
            self?.convertCurrency()
        }
    }
}
// MARK: - IQDropdownTextFieldDelegate

extension CurrencyConverterViewController: IQDropDownTextFieldDelegate {
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        convertCurrency()
    }
}

// MARK: - UICollectionViewDataSource

extension CurrencyConverterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCollectionViewCell.reuseIdentifier, for: indexPath) as? BalanceCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let currency = Currency(rawValue: currencyItems[indexPath.row].lowercased())
        guard let balance = persistenceManager.getUserBalance() else {
            return UICollectionViewCell()
        }
        
        var currencyValue: Double = 0.0
        switch currency {
        case .eur:
            currencyValue = balance.eur.round()
        case .usd:
            currencyValue = balance.usd.round()
        case .jpy:
            currencyValue = balance.jpy.round()
        default:
            break
        }
        cell.titleLabel.text = "\(currencyValue) \(currency?.description ?? "")"
        
        return cell
   }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CurrencyConverterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.frame.height)
    }
}
