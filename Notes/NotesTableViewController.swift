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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")

        do {
            notes = try dataStoreManager.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func unwindToNotesVC(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "saveSegue" else { return }
        guard let sourceViewController = unwindSegue.source as? CreateNotesViewController
        else {
            return
        }
        guard let note = sourceViewController.note else { return }

        let newIndexPath = IndexPath(row: notes.count, section: 0)
        notes.append(note)
        tableView.insertRows(at: [newIndexPath], with: .fade)
        self.tableView.reloadData()
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
