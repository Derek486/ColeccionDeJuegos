//
//  JuegosViewController.swift
//  CondoriPintoColeccionJuegos
//
//  Created by Neals Paye Aguilar on 6/05/24.
//

import UIKit
import CoreData

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let categorias = ["RPG", "Mundo Abierto", "FPS", "Shooter"]
    @IBOutlet weak var pickerView: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Aquí puedes manejar la selección de categoría si es necesario
    }
    
    
    var imagePicker = UIImagePickerController()
    var juego: Juego? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        if juego != nil {
            imageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego?.titulo
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        }
    }
    @IBAction func camaraTapped(_ sender: Any) {
    }
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil {
            juego!.titulo! = tituloTextField.text!
            juego!.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            if selectedRow != -1 {
                juego!.categoria = categorias[selectedRow]
            }
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextField.text
            juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            if selectedRow != -1 {
                juego.categoria = categorias[selectedRow]
            }
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagen = info[.originalImage] as? UIImage
        imageView.image = imagen
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
