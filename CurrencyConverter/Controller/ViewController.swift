//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by emircan.uzel on 7.09.2022.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var viewEURBalance: UIView!
    @IBOutlet weak var viewUSDBalance: UIView!
    @IBOutlet weak var viewJPYBalance: UIView!
    @IBOutlet weak var labelEURBalance: UILabel!
    @IBOutlet weak var labelUSDBalance: UILabel!
    @IBOutlet weak var labelJPYBalance: UILabel!
    @IBOutlet weak var viewCurrencyBalance: UIView!
    @IBOutlet weak var viewConvertedBalance: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var iconConverter: UIView!
    @IBOutlet weak var textfieldCurrencyType: UITextField!
    @IBOutlet weak var textfieldConvertedType: UITextField!
    @IBOutlet weak var textfieldCurrencyValue: UITextField!
    @IBOutlet weak var labelConvertedValue: UILabel!
    @IBOutlet weak var bottomViewContainer: UIView!
    
    var currencyPickerView = UIPickerView()
    var convertedPickerView = UIPickerView()
    let currencyType = ["EUR", "USD", "JPY"]
    var balanceModel = Balance(balanceEUR: 1000, balanceUSD: 0, balanceJPR: 0)
    var fromCurrency: String?
    var toCurrency: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setupPickerView()
        self.renderUI()
        self.updateBalanceData()
        self.fromCurrency = self.currencyType.first
        self.toCurrency = self.currencyType.first
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillDisappear() {
        self.convertServiceCall()
        self.labelConvertedValue.text = ""
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func renderUI()
    {
        self.viewEURBalance.setCornerRadius(radius: 8)
        self.viewUSDBalance.setCornerRadius(radius: 8)
        self.viewJPYBalance.setCornerRadius(radius: 8)
        self.viewCurrencyBalance.setCornerRadius(radius: 8)
        self.viewConvertedBalance.setCornerRadius(radius: 8)
        self.buttonSubmit.setCornerRadius(radius: 6)
        self.iconConverter.setCornerRadius(radius: 32)
    }
    
    func updateBalanceData()
    {
        self.labelEURBalance.text = (self.balanceModel.balanceEUR.formatWithTwoDecimal() + " EUR")
        self.labelUSDBalance.text = (self.balanceModel.balanceUSD.formatWithTwoDecimal() + " USD")
        self.labelJPYBalance.text = (self.balanceModel.balanceJPR.formatWithTwoDecimal() + " JPR")
        self.labelConvertedValue.text = "--.--"
        self.textfieldCurrencyValue.text = nil
        self.textfieldCurrencyValue.placeholder = "00.00"
    }
    
    func setupPickerView()
    {
        self.textfieldCurrencyValue.delegate = self
        self.currencyPickerView.delegate = self
        self.currencyPickerView.dataSource = self
        self.currencyPickerView.tag = 0
        self.convertedPickerView.delegate = self
        self.convertedPickerView.dataSource = self
        self.convertedPickerView.tag = 1
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .red
        toolBar.sizeToFit()
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissKeyboard))
        
        toolBar.setItems([fixedSpace,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.textfieldCurrencyType.inputView = currencyPickerView
        self.textfieldCurrencyType.inputAccessoryView = toolBar
        self.textfieldConvertedType.inputView = convertedPickerView
        self.textfieldConvertedType.inputAccessoryView = toolBar
        self.textfieldCurrencyValue.keyboardType = .decimalPad
        self.textfieldCurrencyValue.inputAccessoryView = toolBar
    }
    
    func showAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionSubmit(_ sender: Any)
    {
        guard let currencyValue = self.textfieldCurrencyValue.text?.toDouble(), currencyValue != 0 else {
            self.showAlert(title: "Currency not Converted", message: "Currency Value is not be zero.")
            return
        }
        guard let fromCurrency = self.fromCurrency, let toCurrency = self.toCurrency, fromCurrency != toCurrency else {
            self.showAlert(title: "Currency not Converted", message: "You should choose different currency.")
            return
        }
        guard self.checkEnoughBalance(type: fromCurrency, amount: currencyValue) else {
            self.showAlert(title: "Not Enough Balance", message: "Should not be more than amount from your balance.")
            return
        }
        let convertedCurrencyAmount = self.labelConvertedValue.text?.toDouble() ?? 0
        let commissionFee = (currencyValue / 100) * 0.7
        guard self.isComissionFeeEnough(totalFee: (currencyValue + commissionFee), type: fromCurrency) else {
            self.showAlert(title: "Not Enough Balance", message: "The commission fee should be deducted from the currency balance.")
            return
        }

        let commissionMessage = self.balanceModel.convertCount > 4 ? "Commission Fee - \(commissionFee) \(fromCurrency)." : ""
        let message = "You have converted \(currencyValue.formatWithTwoDecimal()) \(fromCurrency) to \(convertedCurrencyAmount.formatWithTwoDecimal()) \(toCurrency)." + commissionMessage
        self.showAlert(title: "Currency Converted", message: message)
        
        self.balanceModel.increaseConvertCount()
        self.balanceModel.addValueToBalance(currencyType: fromCurrency, value: (currencyValue * -1))
        self.balanceModel.addValueToBalance(currencyType: toCurrency, value: convertedCurrencyAmount)
        self.updateBalanceData()
    }
    
    func isComissionFeeEnough(totalFee: Double, type: String) -> Bool
    {
        let finalBalance = self.balanceModel.getBalanceFromType(currencyType: type) - totalFee
        return !(self.balanceModel.convertCount > 4 && finalBalance < 0)
    }
    
    func checkEnoughBalance(type: String, amount: Double) -> Bool
    {
        let balance = self.balanceModel.getBalanceFromType(currencyType: type)
        return balance >= amount
    }
    
// MARK: - Service Call
    func convertServiceCall()
    {
        guard let currencyValue = self.textfieldCurrencyValue.text?.toDouble(), currencyValue != 0 else { return }
        guard let fromCurrency = self.fromCurrency, let toCurrency = self.toCurrency, fromCurrency != toCurrency else { return }
        
        ApiManager.shared.getExchange(fromAmount: currencyValue.toString(), fromCurrency: fromCurrency, toCurrency: toCurrency)
        { [weak self] (response) in
            guard let self = self else {return}
            switch response{
            case let .success(model):
                self.labelConvertedValue.text = model.amount
            case let .error(error):
                print(error)
            case .failure:
                break
            }
        }
    }
}

// MARK: - Textfield
extension ViewController: UITextFieldDelegate
{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textfieldCurrencyValue.text = textField.text?.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
        self.convertServiceCall()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textfieldCurrencyValue.resignFirstResponder()
        return true
    }
}

// MARK: - PickerView
extension ViewController:  UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.currencyType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.currencyType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 0
        {
            self.textfieldCurrencyType.text = self.currencyType[row] + "▼"
            self.fromCurrency = self.currencyType[row]
        }
        else if pickerView.tag == 1
        {
            self.textfieldConvertedType.text = self.currencyType[row] + "▼"
            self.toCurrency = self.currencyType[row]
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(tapGesture: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
}


