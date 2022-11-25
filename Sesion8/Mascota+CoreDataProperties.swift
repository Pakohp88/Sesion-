//
//  Mascota+CoreDataProperties.swift
//  Sesion8
//
//  Created by Ángel González on 02/04/22.
//
//

import Foundation
import CoreData


extension Mascota {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mascota> {
        return NSFetchRequest<Mascota>(entityName: "Mascota")
    }

    @NSManaged public var tipo: String?
    @NSManaged public var genero: String?
    @NSManaged public var edad: Double
    @NSManaged public var nombre: String?
    @NSManaged public var persona: Persona?

}

extension Mascota : Identifiable {

}
