//
//  PersonViewModel.swift
//  S4NTest
//
//  Created by José Valderrama on 17/11/2018.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import Foundation
import RealmSwift

class PersonViewModel {
    
    let realm = try! Realm()
    var persons: [Person] = []
    var currentPerson: Person? = nil
    
    init() {
        updatePersons()
    }
    
    /// Updates Person list
    func updatePersons() {
        self.persons = Person.getPersons()
    }
    
    /// Use this for when creating new Person
    func createPerson() {
        currentPerson = Person()
        currentPerson?.isEditing = true
    }
    
    /// Deletes a person
    func deletePerson(_ person: Person) {
        guard person.isEditing else {
            return
        }
        
        let currentPerson = self.currentPerson ?? person
        try! realm.write {
            realm.delete(currentPerson)
        }
    }
    
    /// Updates or create a Person
    func updatePerson(name: String?, age: Int, genreValue: Bool, suffersFromHeadaches: Bool, consumesAlcoholRegularly: Bool, to  person: inout Person) {
        guard person.isEditing else {
            return
        }
        
        let currentPerson = self.currentPerson ?? person
        currentPerson.configureWith(name: name ?? "",
                             age: age,
                             genre: Genre(by: genreValue),
                             suffersFromHeadaches: suffersFromHeadaches,
                             consumesAlcoholRegularly: consumesAlcoholRegularly,
                             isEditing: false)
        
        person = currentPerson
        try? realm.write {
            realm.add(currentPerson, update: true)
        }
    }
    
    /// Updates 'is editing' allowing editing
    func updateIsEditing(to person: Person) {
        try? realm.write {
            person.isEditing = true
        }
    }
    
    /// Updates age if possible
    func updateAge(_ age: Int,to person: Person) {
        guard person.isEditing else {
            return
        }
        
        try? realm.write {
            person.age = age
        }
    }
    
    /// Updates age if possible
    func updateGenre(_ genre: Bool, to person: Person) {
        guard person.isEditing else {
            return
        }
        
        try? realm.write {
            person.genre = Genre(by: genre)
        }
    }
    
    /// Updates 'suffers from headaches' if possible
    func updateSuffersFromHeadaches(_ suffersFromHeadaches: Bool, to person: Person) {
        guard person.isEditing else {
            return
        }
        
        try? realm.write {
            person.suffersFromHeadaches = suffersFromHeadaches
        }
    }
    
    /// Updates 'consumes alcohol regularly' if possible
    func updateConsumesAlcoholRegularly(_ consumesAlcoholRegularly: Bool, to person: Person) {
        guard person.isEditing else {
            return
        }
        
        try? realm.write {
            person.consumesAlcoholRegularly = consumesAlcoholRegularly
        }
    }
}
