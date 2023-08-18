//
//  PhoneScreenViewController.swift
//  ExampleAssignment
//
//  Created by Aaryan jaiswal on 18/08/23.
//

import UIKit

class PhoneScreenViewController: UIViewController {
    @IBOutlet weak var getOTPLabel: UILabel!
    @IBOutlet weak var enterPhoneLabel: UILabel!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var phoneNumberModel: PhoneNumberModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupViews()
    }
    
    func setupViews() {
        setupButton()
        setupTextFields()
        setupLabels()
    }
    
    func setupTextFields() {
        
    }
    
    func setupLabels() {
        enterPhoneLabel.font = .inter(ofSize: 35, weight: .bold)
        getOTPLabel.font = .inter(ofSize: 17, weight: .medium)
    }
    
    func setupButton() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.inter(ofSize: 15, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        let attributedString = NSAttributedString(string: "Continue", attributes: attributes)

        continueButton.setAttributedTitle(attributedString, for: .normal)
        continueButton.backgroundColor = UIColor(red: 0.976, green: 0.796, blue: 0.063, alpha: 1)
        continueButton.layer.cornerRadius = 10
    }
    
    func showFailureAlert() {
        let alertController = UIAlertController(title: "Invalid Number", message: "Please enter a valid number.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func navigateToOTPScreen() {
        let vc = OTPScreenViewController()
        vc.phoneNumberModel = phoneNumberModel
        navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func continueButtonTapped(_ sender: Any) {
        let countryCodeString = countryCodeTextField.text ?? ""
        let phoneNumberString = phoneNumberTextField.text ?? ""
        phoneNumberModel = PhoneNumberModel(countryCode: countryCodeString, phoneNumber: phoneNumberString)

        APICalls().performPhoneNumberLoginRequest(number: phoneNumberModel?.fullPhoneNumber ?? "") { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response)
                    self.navigateToOTPScreen()
                }
                
                
            case.failure(let error):
                DispatchQueue.main.async {
                    self.showFailureAlert()
                }
                print(error)
            }
        }
    }
}
