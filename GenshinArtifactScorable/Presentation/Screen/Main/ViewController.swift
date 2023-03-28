//
//  ViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/02/01.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var uidTextField: UITextField!
    
    @IBAction func uidSendButtonDidTap(_ sender: Any) {
        let viewController = SelectCharacterViewController(with: uidTextField.text!)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

