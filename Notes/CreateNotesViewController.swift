//
//  CreateNotesViewController.swift
//  Notes
//
//  Created by Никита Андриянников on 25.03.2022.
//

import UIKit

class CreateNotesViewController: UIViewController, UITextViewDelegate {
    let dataStoreManager = DataStoreManager()
    var note: Note?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(param:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(param:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        updateSaveButton()
    }

    // MARK: - Work with UITextView

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentTextView.resignFirstResponder()
    }

    // Метод, который отслеживает ввод и скроллит UITextView по нажатию на return
    @objc
    func updateTextView(param: Notification) {
        let userInfo = param.userInfo

        if let getKeyboardRect = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) {
            let rectValue = getKeyboardRect.cgRectValue
            let keyboardFrame = self.view.convert(rectValue, to: view.window)

            if param.name == UIResponder.keyboardWillHideNotification {
                contentTextView.contentInset = UIEdgeInsets.zero
            } else {
                contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
                contentTextView.scrollIndicatorInsets = contentTextView.contentInset
            }
        }

        contentTextView.scrollRangeToVisible(contentTextView.selectedRange)
    }

    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButton()
    }

    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case contentTextView:
            updateSaveButton()
        default:
            break
        }
    }

    private func updateSaveButton() {
        let title = titleTextField.text ?? ""
        let description = contentTextView.text ?? ""

        saveButton.isEnabled = !title.isEmpty && !description.isEmpty
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }

        let title = titleTextField.text ?? ""
        let content = contentTextView.text ?? ""

        note = dataStoreManager.createNote(title: title, content: content)
    }
}
