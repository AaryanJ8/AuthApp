//
//  OTPScreenViewController.swift
//  ExampleAssignment
//
//  Created by Aaryan jaiswal on 19/08/23.
//

import UIKit

class OTPScreenViewController: UIViewController {
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var enterOTPLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var editIconImage: UIImageView!
    @IBOutlet weak var countDownLabel: UILabel!
    var phoneNumberModel: PhoneNumberModel?
    
    var countdownSeconds = 60
    var countdownTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        enterOTPLabel.font = .inter(ofSize: 35, weight: .bold)
        phoneNumberLabel.font = .inter(ofSize: 19, weight: .regular)
        phoneNumberLabel.text = "\(phoneNumberModel?.countryCode ?? "+00") \(phoneNumberModel?.phoneNumber ?? "0000000000")"
        
        countDownLabel.font = .inter(ofSize: 15, weight: .medium)
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        editIconImage.addGestureRecognizer(tapGesture)
        editIconImage.isUserInteractionEnabled = true
    }
    
    @objc func updateCountdown() {
        countdownSeconds -= 1
        
        if countdownSeconds > 0 {
            let minutes = countdownSeconds / 60
            let seconds = countdownSeconds % 60
            
            countDownLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            countDownLabel.text = "00:00"
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    }
    
    @objc func imageViewTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToNotesScreen() {
        let vc = NotesScreenViewController()
        vc.phoneNumberModel = phoneNumberModel
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showFailureAlert() {
        let alertController = UIAlertController(title: "Invalid OTP", message: "Given OTP does not match, recheck and edit your number if required.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let otpString = otpTextField.text ?? "0"
        APICalls().performVerifyOTPRequest(phoneNumber: phoneNumberModel?.fullPhoneNumber ?? "", otp: otpString) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response)
                    self.navigateToNotesScreen()
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
