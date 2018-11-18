//
//  PersonViewController.swift
//  S4NTest
//
//  Created by José Valderrama on 17/11/2018.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit
import RealmSwift

class PersonViewController: UIViewController {
    
    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var agePicker: UIPickerView!
    @IBOutlet fileprivate weak var genreSwitch: UISwitch!
    @IBOutlet fileprivate weak var genreLabel: UILabel!
    @IBOutlet fileprivate weak var suffersHeadachesSwitch: UISwitch!
    @IBOutlet fileprivate weak var consumesAlcoholSwitch: UISwitch!
    @IBOutlet fileprivate weak var probabilityOfSindromeKannLabel: UILabel!
    @IBOutlet fileprivate weak var continueButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var deleteButton: UIButton!
    
    var personViewModel: PersonViewModel!
    private var person: Person!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configure()
    }
    
    private func enableDisableUI(with person: Person) {
        nameTextField.isUserInteractionEnabled = person.isEditing
        deleteButton.isHidden = !person.isEditing
        agePicker.isUserInteractionEnabled = person.isEditing
        genreSwitch.isUserInteractionEnabled = person.isEditing
        suffersHeadachesSwitch.isUserInteractionEnabled = person.isEditing
        consumesAlcoholSwitch.isUserInteractionEnabled = person.isEditing
    }
    
    private func configure() {
        guard let personViewModel = personViewModel else {
            return
        }
        
        var flagCreatingNew = false
        if let person = personViewModel.currentPerson {
            self.person = person.copy() as? Person
        } else {
            flagCreatingNew = true
            personViewModel.createPerson()
            self.person = personViewModel.currentPerson!.copy() as? Person
        }
        
        configureContinueButton()
        nameTextField.text = person.name
        agePicker.selectRow(person.age, inComponent: 0, animated: true)
        genreSwitch.setOn(person.genre.boolValue(), animated: true)
        suffersHeadachesSwitch.setOn(person.suffersFromHeadaches, animated: true)
        consumesAlcoholSwitch.setOn(person.consumesAlcoholRegularly, animated: true)
        genreLabel.text = person.genre.rawValue
        adjustProbabilityOfSindromeKannLabel(with: person)
        enableDisableUI(with: person)
        deleteButton.isHidden = flagCreatingNew ? flagCreatingNew : !person.isEditing
    }
    
    /// Sets Continue propertly text for editing state
    private func configureContinueButton() {
        continueButton.title = self.person?.isEditing ?? true ?
            "Guardar"
            :
        "Editar"
    }    
    
    private func continueAction() {
        guard var person = self.person else {
            return
        }
        
        if person.isEditing {
            personViewModel.updatePerson(name: nameTextField.text,
                                         age: agePicker.selectedRow(inComponent: 0),
                                         genreValue: genreSwitch.isOn,
                                         suffersFromHeadaches: suffersHeadachesSwitch.isOn,
                                         consumesAlcoholRegularly: consumesAlcoholSwitch.isOn,
                                         to: &person)
            self.person = person
        } else {
            personViewModel.updateIsEditing(to: person)
        }
        
        enableDisableUI(with: person)
        configureContinueButton()
    }
    
    private func adjustProbabilityOfSindromeKannLabel(with person: Person) {
        let probabilityKannSyndrome = person.probabilityKannSyndrome
        probabilityOfSindromeKannLabel.text = "\(probabilityKannSyndrome)%"
        setColorProbabilityOfSindromeKannLabel(with: probabilityKannSyndrome)
    }
    
    private func setColorProbabilityOfSindromeKannLabel(with probability: Int) {
        var textColor = probabilityOfSindromeKannLabel.textColor
        switch probability {
        case 0..<Person.lowProbabilityInterval:
            textColor = .green
            break
        case Person.lowProbabilityInterval..<Person.mediumProbabilityInterval:
            textColor = .yellow
            break
        case Person.mediumProbabilityInterval...Person.highProbabilityInterval:
            textColor = .red
            break
        default:
            break
        }
        
        probabilityOfSindromeKannLabel.textColor = textColor
    }
    
    // MARK: - Actions
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        continueAction()
    }
    
    @IBAction func genreSwitchValueChange(_ sender: Any) {
        genreLabel.text = Genre(by: genreSwitch.isOn).rawValue
        personViewModel.updateGenre(genreSwitch.isOn, to: person)
        adjustProbabilityOfSindromeKannLabel(with: person)
    }
    
    @IBAction func suffersFromHeadachesSwitchValueChanged(_ sender: Any) {
        personViewModel.updateSuffersFromHeadaches(suffersHeadachesSwitch.isOn, to: person)
        adjustProbabilityOfSindromeKannLabel(with: person)
    }
    
    @IBAction func consumesAlcoholRegularlySwitchValueChanged(_ sender: Any) {
        personViewModel.updateConsumesAlcoholRegularly(consumesAlcoholSwitch.isOn, to: person)
        adjustProbabilityOfSindromeKannLabel(with: person)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        personViewModel.deletePerson(person)
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension PersonViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 180
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        personViewModel.updateAge(row, to: person)
        adjustProbabilityOfSindromeKannLabel(with: person)
    }
}
