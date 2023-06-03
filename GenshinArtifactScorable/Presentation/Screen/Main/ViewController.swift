//
//  ViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/02/01.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var uidTextField: UITextField! {
        didSet {
            uidTextField.delegate = self
        }
    }
    
    @IBAction func uidSendButtonDidTap(_ sender: Any) {
        let uid = uidTextField.text!
        let viewController = SelectCharacterViewController(with: uid)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITextFieldDelegate {
    
}
