//
//  ViewController.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/4.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var shapes = [Pencil()]
    @IBOutlet var board: Board!
    @IBAction func drawGraphBase(_ sender: UISegmentedControl) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
          self.board.shape = shapes[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

