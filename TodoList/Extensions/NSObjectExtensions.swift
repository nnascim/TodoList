//
//  NSObjectExtensions.swift
//  TodoList
//
//  Created by Erick Barbosa on 9/8/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import Foundation

// Extension: To Avoid typing string as it is prone to error. EX: TodoListViewController.className
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
