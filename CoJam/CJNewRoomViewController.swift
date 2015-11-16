//
//  CJNewRoomViewController.swift
//  CoJam
//
//  Created by Stephen Greco on 8/26/15.
//  Copyright © 2015 Stephen Greco. All rights reserved.
//

import UIKit

protocol CJNewRoomViewDelegate {
    func newRoomCreated(room: CJRoom)
}

class CJNewRoomViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleField: UITextField!
    var delegate : CJNewRoomViewDelegate?
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard", name: Notifications.hideKeyboardNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func hideKeyboard() {
        self.titleField.text = ""
        titleField.resignFirstResponder()
    }
    
    @IBAction func createButtonPressed(sender: AnyObject) {
        let newRoom = CJRoom.object()
        newRoom.creator = CJUser.currentUser()
        newRoom.displayName = titleField.text
        newRoom.isActive = true
        newRoom.queue = []
        newRoom.members.addObject(CJUser.currentUser()!)
        newRoom.saveInBackgroundWithBlock() { (success, error) in
            guard success else {
                print(error?.localizedDescription)
                return
            }
            self.delegate?.newRoomCreated(newRoom)
        }
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
