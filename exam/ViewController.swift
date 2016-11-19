//
//  ViewController.swift
//  exam
//
//  Created by Techmaster on 11/19/16.
//  Copyright © 2016 Techmaster. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nationTextField: UITextField!
    @IBOutlet weak var capitalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayNationAndCapitalCityNames()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Get Path
    func getPath() -> String {
        let plistFileName = "data.plist"
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let paths = "/Users/techmaster/Desktop/exam/exam"
        let documentPath = paths as NSString
        let plistPath = documentPath.stringByAppendingPathComponent(plistFileName)
        
        return plistPath
    }
    
    //Display Nation and Capital
    func displayNationAndCapitalCityNames() {
        let plistPath = self.getPath()
        print("plistPath display = \(plistPath)")
        if NSFileManager.defaultManager().fileExistsAtPath(plistPath) {
            if let nationAndCapitalCitys = NSMutableDictionary(contentsOfFile: plistPath) {
                for (_, element) in nationAndCapitalCitys.enumerate() {
                    print("zzz: \(element.key) --> \(element.value) \n")
                }
            }
        }
    }
    
    @IBAction func exportData(sender: UIButton) {
        let plistPath = self.getPath()
        print("plistPath exportData = \(plistPath)")
        if NSFileManager.defaultManager().fileExistsAtPath(plistPath) {
            print("Income")
            let nationAndCapitalCitys = NSMutableDictionary(contentsOfFile: plistPath)!
            nationAndCapitalCitys.setValue(capitalTextField.text!, forKey: nationTextField.text!)
            nationAndCapitalCitys.writeToFile(plistPath, atomically: true)
        }
        nationTextField.text = ""
        capitalTextField.text = ""
        displayNationAndCapitalCityNames()
    }
}



