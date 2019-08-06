//
//  Protocols.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/1/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol HomeControllerDelegete {
    func handleMenuToggle(menuOption: MenuOptions?, newsData: ([JSON], Int)?)
}
