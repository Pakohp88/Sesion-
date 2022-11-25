//
//  MascotasViewController.swift
//  Sesion8
//
//  Created by Ángel González on 02/04/22.
//

import UIKit

class MascotasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var datos = [Mascota]()
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var dataManager: DataManager?
    
    @IBAction func filtro () {        
        let index = segmented.selectedSegmentIndex
        if index == 3 {
            datos = dataManager!.todasLasMascotas()
        }
        else {
            if let tipo = segmented.titleForSegment(at: index) {
                datos = dataManager!.todasLasMascotasTipo(tipo)
            }
        }
        // siempre que se cambie el data source de la tabla...
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        segmented.selectedSegmentIndex = 3
        dataManager = DataManager()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -100).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDel = UIApplication.shared.delegate as! AppDelegate
        datos = dataManager!.todasLasMascotas()
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let mascota = datos[indexPath.row]
        cell.textLabel?.text = mascota.nombre
        if let duenio = mascota.persona {
            cell.detailTextLabel?.text = duenio.nombre! + " " + duenio.apellido_paterno!
        }
        else {
            cell.detailTextLabel?.text = ""
        }
        return cell
    }

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if editingStyle == .delete {
            // BORRAR UN OBJETO
            /*
            // obtenemos el objeto que se va a borrar
            let mascota = datos[indexPath.row]
            // lo borramos del datasource
            datos.remove(at: indexPath.row)
            // lo borramos de la base de datos para que la información coincida
            appDel.persistentContainer.viewContext.delete(mascota)
            appDel.saveContext()
            */
            /// ACTUALIZA UN OBJETO
            /// obtenemos el objeto que queremos actualizar
            let mascota2 = datos[indexPath.row]
            mascota2.nombre! += " eliminado"
            
            
            // Actualizar la relación del objeto con otro objeto:
            let mascota3 = datos[indexPath.row]
            mascota3.persona = dataManager!.nuevaPersona()
            
            // después de cualquier modificacion a la BD hay que salvar el context
            dataManager!.saveContext()
            // volvemos a dibujar la tabla
            tableView.reloadData()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
