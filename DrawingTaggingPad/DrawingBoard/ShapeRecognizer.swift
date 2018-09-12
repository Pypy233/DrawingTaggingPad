//
//  ShapeRecognizer.swift
//  DrawingTaggingPad
//
//  Created by py on 2018/9/9.
//  Copyright © 2018年 NJU.py. All rights reserved.
//

import UIKit
import CoreGraphics

class ShapeRecognizer{
    enum Shape {
        case Rectangle, Triangle, Circle, Square;
    }
    fileprivate var loadedTemplates	:[SwiftUnistrokeTemplate] = []
    func loadTemplatesDirectory() {
        do {
            // Load template files
            let templatesFolder = Bundle.main.resourcePath! + "/Templates"
            let list = try FileManager.default.contentsOfDirectory(atPath: templatesFolder)
            
           // var _:CGFloat = 0.0
            for file in list {
                let templateData = try? Data(contentsOf: URL(fileURLWithPath: templatesFolder.appendingFormat("/%@", file)))
                let templateDict = try JSONSerialization.jsonObject(with: templateData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let templateName = templateDict["name"]! as! String
               // _ = templateDict["image"]! as! String
                let templateRawPoints: [AnyObject] = templateDict["points"]! as! [AnyObject]
                var templatePoints: [StrokePoint] = []
                for rawPoint in templateRawPoints {
                    let x = (rawPoint as! [AnyObject]).first! as! Double
                    let y = (rawPoint as! [AnyObject]).last! as! Double
                    templatePoints.append(StrokePoint(x: x, y: y))
                }
                
                let templateObj = SwiftUnistrokeTemplate(name: templateName, points: templatePoints)
                loadedTemplates.append(templateObj)
                print("  - Loaded template '\(templateName)' with \(templateObj.points.count) points inside")
                
            }
            
            print("- \(loadedTemplates.count) templates are now loaded!")
            
        } catch (let error as NSError) {
            print("Something went wrong while loading templates: \(error.localizedDescription)")
        }
    }
}
