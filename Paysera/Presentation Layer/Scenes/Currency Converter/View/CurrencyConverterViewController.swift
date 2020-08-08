//
//  ViewController.swift
//  Paysera
//
//  Created by Jeric Miana on 8/8/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import UIKit

class CurrencyConverterViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var balanceCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var sellCurrencyButton: UIButton!
    @IBOutlet weak var sellCurrencyTextField: UITextField!
    @IBOutlet weak var buyCurrencyButton: UIButton!
    @IBOutlet weak var buyCurrencyLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        headerView.setGradientBackground()
        submitButton.setGradientBackground()
        submitButton.roundCorners()
    }
    
    

}

