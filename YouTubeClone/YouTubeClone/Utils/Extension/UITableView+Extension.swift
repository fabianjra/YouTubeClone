//
//  UITableView+Extension.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 18/10/22.
//

import Foundation
import UIKit

extension UITableView {
    //In order to register a cell, its identifier must be the same as className.
    //T: Generic type
    public func register<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: "\(T.self)", bundle: nil), forCellReuseIdentifier: "\(T.self)")
    }
    
    //In order to register a headerFooterView, its identifier must be the same as className
    public func register<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) {
        register(UINib(nibName: "\(T.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(T.self)")
    }
    
    public func registerFromClass<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: "\(T.self)")
        
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(for type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else {
            fatalError("Failed to dequeue cell.")
            //return nil //Podria manejarse con return nil y la respuesta T como un opcional. 
        }
        return cell
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(for type: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: "\(T.self)") as? T else {
            fatalError("Failed to dequeue footer view.")
        }
        return view
    }
}
