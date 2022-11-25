//
//  Persona+CoreDataProperties.swift
//  Sesion8
//
//  Created by Ángel González on 02/04/22.
//
//

import Foundation
import CoreData


extension Persona {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Persona> {
        return NSFetchRequest<Persona>(entityName: "Persona")
    }

    @NSManaged public var nombre: String?
    @NSManaged public var apellido_paterno: String?
    @NSManaged public var apellido_materno: String?
    @NSManaged public var estado: String?
    @NSManaged public var ciudad: String?
    @NSManaged public var email: String?
    @NSManaged public var tel: String?
    @NSManaged public var mascotas: NSSet?

}

// MARK: Generated accessors for mascotas
extension Persona {

    @objc(addMascotasObject:)
    @NSManaged public func addToMascotas(_ value: Mascota)

    @objc(removeMascotasObject:)
    @NSManaged public func removeFromMascotas(_ value: Mascota)

    @objc(addMascotas:)
    @NSManaged public func addToMascotas(_ values: NSSet)

    @objc(removeMascotas:)
    @NSManaged public func removeFromMascotas(_ values: NSSet)

}

extension Persona : Identifiable {

}
