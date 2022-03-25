//
//  CreateNotesViewController.swift
//  Notes
//
//  Created by Никита Андриянников on 25.03.2022.
//

import UIKit

class CreateNotesViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(param:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(param:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    // MARK: - Work with UITextView

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.descriptionTextField.resignFirstResponder()
    }

    // Метод, который отслеживает ввод и скроллит UITextView по нажатию на return
    @objc
    func updateTextView(param: Notification) {
        let userInfo = param.userInfo

        if let getKeyboardRect = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) {
            let rectValue = getKeyboardRect.cgRectValue
            let keyboardFrame = self.view.convert(rectValue, to: view.window)

            if param.name == UIResponder.keyboardWillHideNotification {
                descriptionTextField.contentInset = UIEdgeInsets.zero
            } else {
                descriptionTextField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
                descriptionTextField.scrollIndicatorInsets = descriptionTextField.contentInset
            }
        }

        descriptionTextField.scrollRangeToVisible(descriptionTextField.selectedRange)
    }
}
