//
//  Person.swift
//  S4NTest
//
//  Created by José Valderrama on 17/11/2018.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objc public enum Genre: Int, RawRepresentable {
    case male
    case female
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .male:
            return "Hombre"
        case .female:
            return "Mujer"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "Hombre":
            self = .male
        case "Mujer":
            self = .female
        default:
            self = .male
        }
    }
    
    func boolValue() -> Bool {
        return self == .male ? true : false
    }
    
    init(by genreValue: Bool) {
        self = genreValue ? Genre.male : Genre.female
    }
}

@objcMembers class Person: Object, NSCopying {
    
    // MARK: - Configurations
    
    /// Minumun age
    private static let minimunAge: Int = 1
    /// Low Probability Interval
    static let lowProbabilityInterval: Int = 25
    /// Medium Probability Interval
    static let mediumProbabilityInterval: Int = 75
    /// High Probability Interval
    static let highProbabilityInterval: Int = 100
    
    // MARK: - Basic info
    
    @objc dynamic var id: String = Date().description
    
    /// Public name
    @objc dynamic var name: String = ""
    
    /// Private age
    @objc dynamic private var _age: Int = minimunAge
    
    /// Public age
    var age: Int {
        get {
            return _age
        }
        set {
            if newValue < Person.minimunAge {
                _age = Person.minimunAge
            }
            
            _age = newValue
        }
    }
    
    /// Public genre
    @objc dynamic var genre: Genre = .male
    
    /// Public flag for 'suffers from headaches'
    @objc dynamic var suffersFromHeadaches: Bool = false
    
    /// Public flag for 'consumes alcohol regularly'
    @objc dynamic var consumesAlcoholRegularly: Bool = false
    
    /// Public probability for 'Kann Syndrome'
    var probabilityKannSyndrome: Int {
        var probability = 0
        
        // suffers from headaches
        if suffersFromHeadaches {
            probability += 25
        }
        
        // age between 20 and 30
        if age >= 20 && age <= 30 {
            probability += 25
        }
        
        // consumes alcohol regularly
        if consumesAlcoholRegularly {
            probability += 25
        }
        
        // is a female
        if genre == .female {
            probability += 25
        }
        
        return probability
    }
    
    /// Flag 'if editing'
    var isEditing = false
    
    // MARK: - Life cycle
    
    class func getPersons() -> [Person] {
        let realm = try! Realm()
        return Array(realm.objects(Person.self).sorted(byKeyPath: primaryKey(),ascending:true))
    }
    
    convenience init(id: String, name: String, age: Int, genre: Genre, suffersFromHeadaches: Bool, consumesAlcoholRegularly: Bool, isEditing: Bool) {
        self.init()
        configureWith(name: name, age: age, genre: genre, suffersFromHeadaches: suffersFromHeadaches, consumesAlcoholRegularly: consumesAlcoholRegularly, isEditing: isEditing)
    }
    
    /// Configures itself with given data
    func configureWith(name: String, age: Int, genre: Genre, suffersFromHeadaches: Bool, consumesAlcoholRegularly: Bool, isEditing: Bool) {
        let realm = try! Realm()
        try? realm.write {
            self.name = name
            self.genre = genre
            self.suffersFromHeadaches = suffersFromHeadaches
            self.consumesAlcoholRegularly = consumesAlcoholRegularly
            self.age = age
        }
        self.isEditing = isEditing
    }
    
    // MARK: - Realm
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }    
    
    // MARK: - NSCopying
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Person(id: id, name: name, age: age, genre: genre, suffersFromHeadaches: suffersFromHeadaches, consumesAlcoholRegularly: consumesAlcoholRegularly, isEditing: isEditing)
        
        return copy
    }
}
