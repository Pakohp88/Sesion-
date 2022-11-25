//
//  DataManager.swift
//  Sesion8
//
//  Created by Francisco Hernandez on 24/11/22.
//

import Foundation
import CoreData
import EncryptedCoreData

public class DataManager{
    
    public init(){
        let ud = UserDefaults.standard
        let bandera = (ud.value(forKey: "infoOK") as? Bool) ?? false
        if !bandera {
            obtenerMascotas()
        }
    }
    
    func obtenerPersonas() {
        if let url = URL(string:"https://my.api.mockaroo.com/responsables.json?key=ee082920") {
            do {
                let bytes = try Data(contentsOf: url)
                let tmp = try JSONSerialization.jsonObject(with: bytes) as! [[String : Any]]
                llenaBD(tmp, entidad:"Persona")
            }
            catch {
                print ("no se pudo obtener la info desde el feed de personas \(error.localizedDescription)")
            }
        }
    }
    
    func obtenerMascotas() {
        // TODO: Verificar que se tenga conexión a Internet ....
        // TODO: Cambiar el http-method a POST para que el apiKey no vaya visible
        if let url = URL(string:"https://my.api.mockaroo.com/mascotas.json?key=ee082920") {
            do {
                // TODO: Descarga de contenidos en background ....
                let bytes = try Data(contentsOf: url)
                let tmp = try JSONSerialization.jsonObject(with: bytes) as! [[String : Any]]
                llenaBD(tmp, entidad:"Mascota")
                obtenerPersonas()
                let ud = UserDefaults.standard
                ud.set(true, forKey: "infoOK")
                ud.synchronize()
            }
            catch {
                print ("no se pudo obtener la info desde el feed de mascotas \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Core Data stack
    func llenaBD(_ arreglo:[[String:Any]], entidad:String) {
        // 0. requerimos la descripción de la entidad para poder crear objetos CD
        guard let entidadDesc = NSEntityDescription.entity(forEntityName:entidad, in:persistentContainer.viewContext)
        else {
            return
        }
        for dict in arreglo {
            // 1. crear un objeto Mascota
            if entidad == "Mascota" {
                let m = NSManagedObject(entity: entidadDesc, insertInto: persistentContainer.viewContext) as! Mascota
                // 2. setear las properties del objeto, con los datos del dict
                m.inicializaCon(dict)
            }
            else {
                let p = NSManagedObject(entity: entidadDesc, insertInto: persistentContainer.viewContext) as! Persona
                p.inicializaCon(dict)
            }
            // 3. salvar el objeto
            saveContext()
        }
    }
    
    func todasLasPersonas() -> [Persona] {
        var resultset = [Persona]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Persona")
        do {
            let tmp = try persistentContainer.viewContext.fetch(request)
                resultset = tmp as! [Persona]
        }
        catch {
            print ("fallo el request \(error.localizedDescription)")
        }
        return resultset
    }
    
    func todasLasMascotasTipo(_ tipo:String) -> [Mascota] {
        var resultset = [Mascota]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mascota")
        do {
            if tipo == "Otros" {
                // El objeto NSPredicate es un "where" en el query
                let filtro1 = NSPredicate(format: "tipo <> %@", "Gato")
                // let filtro1 = NSPredicate(format: "tipo <> %@ AND tipo <> %@", "Gato", "Perro")
                let filtro2 = NSPredicate(format: "tipo <> %@", "Perro")
                // compoundPredicates une dos o mas predicados, con operadores logicos
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [filtro1, filtro2])
                let tmp = try persistentContainer.viewContext.fetch(request)
                resultset = tmp as! [Mascota]
            }
            else {
                let filtro = NSPredicate(format: "tipo = %@", tipo)
                request.predicate = filtro
                let tmp = try persistentContainer.viewContext.fetch(request)
                resultset = tmp as! [Mascota]
            }
        }
        catch {
            print ("fallo el request \(error.localizedDescription)")
        }
        return resultset
    }
    
    func todasLasMascotas() -> [Mascota] {
        var resultset = [Mascota]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mascota")
        do {
            let tmp = try persistentContainer.viewContext.fetch(request)
            resultset = tmp as! [Mascota]
        }
        catch {
            print ("fallo el request \(error.localizedDescription)")
        }
        return resultset
    }
    
    func nuevaPersona() -> Persona {
        let entidadDesc = NSEntityDescription.entity(forEntityName:"Persona", in:persistentContainer.viewContext)
        let p = NSManagedObject(entity: entidadDesc!, insertInto: persistentContainer.viewContext) as! Persona
        p.nombre = "Marge"
        p.apellido_paterno = "Simpson"
        return p
    }
        
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Sesion8")
            let options: NSDictionary = [EncryptedStore.optionPassphraseKey(): "123", EncryptedStore.optionFileManager(): EncryptedStoreFileManager.default()]
            let desc = try! EncryptedStore.makeDescription(options: options as! [AnyHashable: Any], configuration: nil)
            container.persistentStoreDescriptions = [desc]
            do {
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
            }
            catch {
                print ("error " + error.localizedDescription)
            }
            return container
        }()
    
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
