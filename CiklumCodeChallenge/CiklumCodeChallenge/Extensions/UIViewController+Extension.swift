//
//  UIViewController+Extension.swift
//  CiklumCodeChallenge
//
//  Created by Jalal Khan on 23/11/2019.
//  Copyright © 2019 Jalal Khan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showAlertController(_ title:String, message:String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        controller.addAction(alertAction)
        self.present(controller, animated: true, completion: nil)
    }
}
