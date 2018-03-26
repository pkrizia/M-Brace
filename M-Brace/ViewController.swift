//
//  ViewController.swift
//  M-Brace
//
//  Created by Princess Macanlalay on 2/27/18.
//  Copyright © 2018 Princess Macanlalay. All rights reserved.
// Trying to commit to branch

import UIKit
//import SwiftSocket
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var lnChart: LineChartView!
    @IBOutlet weak var txtBox2: UITextField!
    
    var numbers : [Double] = [] //store all numbers/imported set of numbers here
    var numbers2: [Double] = [] //added another array for 2nd sensor
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
        let input2 = Double(txtBox2.text!)
        numbers2.append(input2!)
        updateGraph()
    }
    //make 2 diff lines or multiple (one for each sensor)
//
//    @IBAction func graphBtn(_ sender: Any) {
//        let input = Double(txtBox.text!) //input from user
//        numbers.append(input!)
//        updateGraph()
//    }
    
    func updateGraph(){
        var lnChartData = [ChartDataEntry]() //this is the array of points that will be displayed on graph
        var lnChartData2 = [ChartDataEntry]()
        
        for i in 0..<numbers.count{
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lnChartData.append(value)
            let value2 = ChartDataEntry(x: Double(i), y: numbers2[i])
            lnChartData2.append(value2)
            //lnChartData2 = lnChartData + lnChartData2
        }
//        let line1 = LineChartDataSet(values: lnChartData, label: "Numbers") //convert data points into a dataset
//        line1.colors = [NSUIColor.white]
//        let data = LineChartData() //object will be added to chart
//        data.addDataSet(line1)
//
        let line1 = LineChartDataSet(values: lnChartData, label: "Line1") //convert data points into a dataset
        line1.setColor(.blue)
        
        let line2 = LineChartDataSet(values: lnChartData2, label: "Line2")
        line2.setColor(.red)
        
        let data = LineChartData(dataSets: [line1,line2]) //object will be added to chart
        //data.addDataSet(line1, line2)
        
        lnChart.data = data //adds the chart data to chart and graph updates
        lnChart.chartDescription?.text = "line graph"
    }
    


}

