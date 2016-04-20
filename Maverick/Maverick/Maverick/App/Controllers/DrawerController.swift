//
//  DrawerController.swift
//  Maverick
//
//  Created by Huy Pham on 4/18/16.
//  Copyright © 2016 Maverick. All rights reserved.
//

class DrawerController: BaseController {
    private let drawerView = DrawerView()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.drawerView)
    }
}