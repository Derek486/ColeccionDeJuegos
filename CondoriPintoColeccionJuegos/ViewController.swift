//
//  ViewController.swift
//  CondoriPintoColeccionJuegos
//
//  Created by Neals Paye Aguilar on 6/05/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var juegos: [Juego] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = "\(juego.titulo!) \(juego.categoria!)"
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let btnel = UITableViewRowAction(style: .normal, title: "Eliminar") {
            (fila, indexPath) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(self.juegos[indexPath.row])
            self.juegos.remove(at: indexPath.row)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            tableView.reloadData()
        }
        let btned = UITableViewRowAction(style: .normal, title: "Editar") {
            (fila, indexPath) in
            let juego = self.juegos[indexPath.row]
            
            self.performSegue(withIdentifier: "juegoSegue", sender: juego)
        }
        btnel.backgroundColor = UIColor.red
        btned.backgroundColor = UIColor.green
        return [btned, btnel]
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let juego = juegos[sourceIndexPath.row]
        juegos.remove(at: sourceIndexPath.row)
        juegos.insert(juego, at: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguiente = segue.destination as! JuegosViewController
        siguiente.juego = sender as? Juego
        
    }


}

