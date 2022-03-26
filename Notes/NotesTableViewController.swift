//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Никита Андриянников on 22.03.2022.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {

    let dataStoreManager = DataStoreManager()
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notes = dataStoreManager.getNotes()
        self.tableView.reloadData()
    }

    @IBAction func unwindToNotesVC(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "saveSegue" else { return }
        guard let sourceViewController = unwindSegue.source as? CreateNotesViewController
        else {
            return
        }
        guard let updateNote = sourceViewController.note else { return }
        
        notes = dataStoreManager.getNotes()
        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "updateNote" else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let note = notes[indexPath.row]
        guard let newCreateNoteVC = segue.destination as? CreateNotesViewController else { return }
        newCreateNoteVC.note = note
        newCreateNoteVC.title = "Update"
        newCreateNoteVC.hasBeenChanged = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell",
                                                       for: indexPath) as? NoteTableViewCell else {
            fatalError("Can't cast cell")
        }

        let note = notes[indexPath.row]
        cell.setUpCell(data: note)

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            dataStoreManager.viewContext.delete(note)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            dataStoreManager.saveContext()
        }
    }

}
