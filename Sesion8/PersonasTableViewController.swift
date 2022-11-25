//
//  PersonasTableViewController.swift
//  Sesion8
//
//  Created by Ángel González on 02/04/22.
//

import UIKit

class PersonasTableViewController: UITableViewController, UISearchResultsUpdating {
    var datos = [Persona]()
    // El componente UISearchController es el que permite agregar una barra de busqueda a un tableview
    // se inicializa con "nil" para indicar que no se utilizará un controller distinto o sea que la búsqueda se realizará sobre la misma tabla
    let buscador = UISearchController(searchResultsController: nil)
    // necesitamos un nuevo arreglo, para los resultados de la busqueda
    var registrosFiltrados = [Persona]()
    // esta variable calculada, se va a actualizar en el momento que se consulte según el estado de la barra de búsqueda
    var barraVacia:Bool {
        return buscador.searchBar.text?.isEmpty ?? true
    }
    // esta variable calculada, nos servirá para determinar si se está realizando una búsqueda
    var buscando: Bool {
      return buscador.isActive && !barraVacia
    }
    var dataManager: DataManager?
    
    // configuración inicial de la barra de búsqueda
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager()
        // define el objeto que se va a encargar de los eventos de la barra de búsqueda, debe implementar el protocolo UISearchResultsUpdating
        buscador.searchResultsUpdater = self
        // si se setea a true, el tableview se deshabilita cuando se está usando el buscador
        buscador.obscuresBackgroundDuringPresentation = false
        // el hint que va a aparecer en la barra de búsqueda
        buscador.searchBar.placeholder = "Buscar por nombre"
        // se necesita un objeto navigationcontroller para que se pueda agregar la barra de busqueda sobre el tableview
        navigationItem.searchController = buscador
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datos = dataManager!.todasLasPersonas()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Si se está realizando una búsqueda, se debe tomar como datasource el arreglo con los objetos filtrados, no el arreglo completo
        if buscando {
            return registrosFiltrados.count
        }
        return datos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        var persona = datos[indexPath.row]
        // Si se está realizando una búsqueda, se debe tomar como datasource el arreglo con los objetos filtrados, no el arreglo completo
        if buscando {
            persona = registrosFiltrados[indexPath.row]
        }
        guard let nom = persona.nombre,
              let app = persona.apellido_paterno
        else {
            return cell
        }
        let cuantasMascotas = persona.mascotas?.count ?? 0
        cell.textLabel?.text = "\(nom) \(app) - tiene \(cuantasMascotas) mascotas"
        return cell
    }
    
    // MARK: - UISearchResultsUpdating
    // este método es del protocolo para controlar el evento de búsqueda
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        // obtenemos el texto que está escrito en el buscador y lo usamos para filtrar el arreglo
        filtrarContenidos(searchBar.text!)
    }
    
    // este método filtra el arreglo original y asigna los resultados al nuevo arreglo
    func filtrarContenidos(_ texto: String) {
        // el método filter del objeto array permite filtrar los elementos del arreglo usando un closure
        registrosFiltrados = datos.filter { (persona: Persona) -> Bool in
            // indicamos la condición que deben cumplir los objetos para considerarse dentro del arreglo filtrado
            // hacemos la comparación en minúsculasa para que sea case insensitive
            return (persona.nombre!.lowercased().contains(texto.lowercased()) ||
                  persona.apellido_paterno!.lowercased().contains(texto.lowercased()) )
        }
        // volvemos a cargar la tabla con los datos filtrados
        tableView.reloadData()
    }
}
