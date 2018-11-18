//
//  PersonTableViewCell.swift
//  S4NTest
//
//  Created by José Valderrama on 17/11/2018.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var ageLabel: UILabel!
    @IBOutlet fileprivate weak var genreLabel: UILabel!
    @IBOutlet fileprivate weak var sufersHeadachesSwitch: UISwitch!
    @IBOutlet fileprivate weak var consumesAlcoholSwitch: UISwitch!
    @IBOutlet fileprivate weak var probabilityOfSindromeKannLabel: UILabel!

    // MARK: - Life cycle
    
    func configureCell(with person: Person) {
        nameLabel.text = person.name
        ageLabel.text = "\(person.age)"
        genreLabel.text = person.genre.rawValue
        sufersHeadachesSwitch.setOn(person.suffersFromHeadaches, animated: true)
        consumesAlcoholSwitch.setOn(person.consumesAlcoholRegularly, animated: true)
        probabilityOfSindromeKannLabel.text = "\(person.probabilityKannSyndrome)%"
    }
}
