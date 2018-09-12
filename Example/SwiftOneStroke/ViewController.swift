//
//  ViewController.swift
//  SwiftOneStroke
//
//  Created by py on 2018/9/8.
//  Copyright © 2018年 Yu Pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	fileprivate var loadedTemplates			:[SwiftUnistrokeTemplate] = []
	fileprivate var templateViews			:[StrokeView] = []
	@IBOutlet var drawView				:StrokeView!
	@IBOutlet var templatesScrollView	:UIScrollView!
	@IBOutlet var labelTemplates		:UILabel!
	
    @IBAction func saveToAlbum(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
            let image = renderer.image { ctx in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
               
            }
             UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
            
        } else {
            // Fallback on earlier versions
        }
       
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            
            let ac = UIAlertController(title: "Saved!", message: "The screenshot has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		loadTemplatesDirectory()
		
		drawView.backgroundColor = UIColor.cyan
		// we set a completion handler called on touchesCancelled/End which
		// grab drawn points and pass them to the one stroke recognizer class
		drawView.onDidFinishDrawing = { drawnPoints in
			if drawnPoints == nil {
				return
			}
			
			if drawnPoints!.count < 5 {
				return
			}
            print(drawnPoints!)
            
            let strokeRecognizer = SwiftUnistroke(points: drawnPoints!)
            
            
        
			do {
				let (template,distance) = try strokeRecognizer.recognizeIn(self.loadedTemplates, useProtractor:  false)
				
				var title: String = ""
				var message: String = ""
				if template != nil {
					title = "Gesture Recognized!"
					message = "Let me try...is it a \(template!.name.uppercased())?"
					print("[FOUND] Template found is \(template!.name) with distance: \(distance!)")
                    let myView = ShapeView(frame: CGRect(x: 25, y: 200, width: 280, height: 250), shape: self.transferTemplateNameStringToShapeType(templateName: template!.name))
                    myView.backgroundColor = UIColor.yellow
                    self.view.addSubview(myView)
				} else {
					print("[FAILED] Template not found")
					title = "Ops...!"
					message = "I cannot recognize this gesture. So sad my dear..."
				}
				
				let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
				let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
				alert.addAction(okButton)
				self.present(alert, animated: true, completion: nil)

			} catch (let error as NSError) {
				print("[FAILED] Error: \(error.localizedDescription)")
				
				let alert = UIAlertController(title: "Ops, something wrong happened!", message: "\(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
				let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
				alert.addAction(okButton)
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	fileprivate func loadTemplatesDirectory() {
		do {
			// Load template files
			let templatesFolder = Bundle.main.resourcePath! + "/Templates"
			let list = try FileManager.default.contentsOfDirectory(atPath: templatesFolder)
			
			var x:CGFloat = 0.0
			let size = templatesScrollView.frame.height
			for file in list {
				let templateData = try? Data(contentsOf: URL(fileURLWithPath: templatesFolder.appendingFormat("/%@", file)))
				let templateDict = try JSONSerialization.jsonObject(with: templateData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
				let templateName = templateDict["name"]! as! String
				let templateImage = templateDict["image"]! as! String
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
				
				// For each template get its preview and show them inside the bottom screen scroll view
				let templateView = UIImageView(frame: CGRect(x: x,y: 0,width: size,height: size))
				templateView.image = UIImage(named: templateImage)
				templateView.contentMode = UIViewContentMode.scaleAspectFit
				templateView.layer.borderColor = UIColor.lightGray.cgColor
				templateView.layer.borderWidth = 2
				templatesScrollView.addSubview(templateView)
				x = templateView.frame.maxX+2
			}
			
			print("- \(loadedTemplates.count) templates are now loaded!")
			
			// setup scroll view size
			templatesScrollView.contentSize = CGSize(width: x+CGFloat(2*loadedTemplates.count), height: size)
			templatesScrollView.backgroundColor = UIColor.white
			labelTemplates.text = "\(loadedTemplates.count) TEMPLATES LOADED:"
		} catch (let error as NSError) {
			print("Something went wrong while loading templates: \(error.localizedDescription)")
		}
	}
    
    func transferTemplateNameStringToShapeType(templateName: String) -> ShapeView.ShapeType{
        switch templateName {
        case "circle":
            return ShapeView.ShapeType.Circle
        case "rectangle":
            return ShapeView.ShapeType.Rectangle
        default:
            return ShapeView.ShapeType.Triangle
        }
    }
    
    override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}


}

