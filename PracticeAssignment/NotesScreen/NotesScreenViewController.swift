//
//  NotesScreenViewController.swift
//  PracticeAssignment
//
//  Created by Aaryan jaiswal on 19/08/23.
//

import UIKit

class NotesScreenViewController: UIViewController {
    var phoneNumberModel: PhoneNumberModel?
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var apiResponseDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let authToken = KeychainManager().getTokenForPhoneNumber(phoneNumberModel?.fullPhoneNumber ?? "")
        notesLabel.text = "Auth Token: \(String(describing: authToken))"
        
        APICalls().performAuthorizedGetRequest(phoneNumber: phoneNumberModel?.fullPhoneNumber ?? "") { result in
            switch result {
            case .success(let res):
                print(res)
                DispatchQueue.main.async {
                    self.apiResponseDataLabel.text = "RESPONSE RECEIVED FORM API \(res)"
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
