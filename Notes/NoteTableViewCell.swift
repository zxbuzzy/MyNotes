//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Никита Андриянников on 22.03.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(data: Note) {
        self.titleLabel.text = data.title
        self.contentLabel.text = data.description
    }

}
