//
//  BottomSheetViewController.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 17/10/22.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    //IBOulets
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var optionContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Se crea un TapGesture.
        //Esto hace que cuando se toque el Overlay, se ejecute esta accion.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay(_:)))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        optionContainer.animateBottomSheet(show: true){ } //Le aplica la animacion solamente al container de las opciones.
    }
    
    @objc func didTapOverlay(_ sender: UITapGestureRecognizer) {
        optionContainer.animateBottomSheet(show: false){ } //Le aplica la animacion solamente al container de las opciones.
        dismiss(animated: false)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
