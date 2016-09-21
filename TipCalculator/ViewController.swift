//
//  ViewController.swift
//  TipCalculator
//
//  Created by Brian McDevitt on 7/21/16.
//  Copyright © 2016 Brian McDevitt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var billTotalTextField: UITextField!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var splitTotalLabel: UILabel!
    @IBOutlet var tipPercentLabel: UILabel!
    @IBOutlet var splitSliderLabel: UILabel!
    @IBOutlet var tipPercentSlider: UISlider!
    @IBOutlet var splitSlider: UISlider!
    
    let tipCalculator = TipCalculator()
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        billTotalTextField.delegate = self
    }
    
    @IBAction func tipPercentSliderChanged(sender: UISlider) {
        let tipPecentValue = lroundf(tipPercentSlider.value)
        sender.setValue(Float(tipPecentValue), animated: true)
        tipPercentLabel.text = "\(Int(tipPecentValue))%"
        if tipPecentValue != tipCalculator.tipPercent {
            tipCalculator.tipPercent = tipPecentValue
            updateLabels()
        }
    }

    @IBAction func splitSliderChanged(sender: UISlider) {
        let splitValue = lroundf(splitSlider.value)
        sender.setValue(Float(splitValue), animated: true)
        splitSliderLabel.text = "\(Int(splitValue))"
        if splitValue != tipCalculator.splitAmount {
            tipCalculator.splitAmount = splitValue
            updateLabels()
        }
    }
    
    @IBAction func billTotalTextFieldChanged(sender: UITextField) {
        if let text = sender.text {
            if text == "$" {
                tipCalculator.billTotal = 0.0
                updateLabels()
            } else {
                let subString = (text as NSString).substringFromIndex(1)
                tipCalculator.billTotal = (numberFormatter.numberFromString(subString)?.doubleValue)!
                updateLabels()
            }
        } else {
            tipCalculator.billTotal = 0.0
            updateLabels()
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        billTotalTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //get the decimal separator for the current region of user
        let currentLocale = NSLocale.currentLocale()
        let decimalSeparator = currentLocale.objectForKey(NSLocaleDecimalSeparator) as! String
        
        let existingTextHasDecimalSeparator = textField.text?.rangeOfString(decimalSeparator)
        let replacementTextHasDecimalSeparator = string.rangeOfString(decimalSeparator)
        
        if string.isEmpty {
            if textField.text == "$" {
                return false
            }
            return true
        }
        else if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            if let decimalRange = existingTextHasDecimalSeparator, let text = textField.text {
                if let index = textField.text?.startIndex.distanceTo(decimalRange.startIndex) {
                    if text.characters.count - index == 3 {
                        return false
                    }
                }
            }
            return true
        }
    }

    func updateLabels() {
        tipLabel.text = "$" + numberFormatter.stringFromNumber(tipCalculator.calculateTipAmount())!
        totalLabel.text = "$" + numberFormatter.stringFromNumber(tipCalculator.calculateTotalPlusTip())!
        splitTotalLabel.text = "$" + numberFormatter.stringFromNumber(tipCalculator.calculateSplitTotal())!
    }
}

