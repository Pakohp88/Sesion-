//
//  Mascota+CoreDataClass.swift
//  Sesion8
//
//  Created by Ángel González on 02/04/22.
//
//

import Foundation
import CoreData

@objc(Mascota)
public class Mascota: NSManagedObject {
    func inicializaCon(_ dict: [String:Any]) {
        let nombre = (dict["nombre"] as? String) ?? ""
        let genero = (dict["genero"] as? String) ?? ""
        let tipo = (dict["tipo"] as? String) ?? ""
        let edad = (dict["edad"] as? Double) ?? 0.0
        self.nombre = nombre
        self.genero = genero
        self.tipo = tipo
        self.edad = edad
    }
}
