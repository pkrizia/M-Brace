//
//  ViewController.swift
//  M-Brace
//
//  Created by Princess Macanlalay on 2/27/18.
//  Copyright © 2018 Princess Macanlalay. All rights reserved.
//

import UIKit
//import SwiftSocket
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var lnChart: LineChartView!
    
    var numbers : [Double] = [] //store all numbers/imported set of numbers here
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Trigger button to plot data
    
    @IBAction func graphBtn(_ sender: Any) {
        let input = Double(txtBox.text!)
        numbers.append(input!)
        updateGraph()
    }
    
//
//    @IBAction func graphBtn(_ sender: Any) {
//        let input = Double(txtBox.text!) //input from user
//        numbers.append(input!)
//        updateGraph()
//    }
    
    func updateGraph(){
        var lnChartData = [ChartDataEntry]() //this is the array of points that will be displayed on graph
        
        for i in 0..<numbers.count{
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lnChartData.append(value)
        }
        let line1 = LineChartDataSet(values: lnChartData, label: "Numbers") //convert data points into a dataset
        
        line1.colors = [NSUIColor.white]
        
        let data = LineChartData() //object will be added to chart
        
        data.addDataSet(line1)
        
        lnChart.data = data //adds the chart data to chart and graph updates
        lnChart.chartDescription?.text = "line graph"
    }
    


}

