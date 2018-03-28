//
//  ViewController.swift
//  M-Brace
//
//  Created by Princess Macanlalay on 2/27/18.
//  Copyright © 2018 Princess Macanlalay. All rights reserved.
// Trying to commit to branch

import UIKit
import SwiftSocket
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var dataOutput: UILabel!
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var lnChart: LineChartView!
    @IBOutlet weak var txtBox2: UITextField!
    
    struct GraphData {
        var numDataSets : Int
        var data = [[Double]]() //store all numbers/imported set of numbers here
        //var numbers2: [Double] = [] //added another array for 2nd sensor
        
        init(numVal: Int) {
            self.numDataSets = numVal
            for _ in 0...self.numDataSets{
                self.data.append([0])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Trigger button to plot data
    var numbers = GraphData(numVal: 2)
    @IBAction func graphBtn(_ sender: Any) {
        let input = Double(txtBox.text!)
        numbers.data[0].append(input!)
        if (numbers.data[0].count > 15) {
            numbers.data[0].removeFirst()
        }
        let input2 = Double(txtBox2.text!)
        numbers.data[1].append(input2!)
        if (numbers.data[1].count > 15) {
            numbers.data[1].removeFirst()
        }
        updateGraph(value: numbers.data)
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        var response = ""
        let client = TCPClient(address: "127.0.0.1", port: 12000)
        switch client.connect(timeout: 10){
        case .success:
            switch client.send(string: "hello world\n"){
            case .success:
                // timeout is necessary
                guard let data = client.read(1024*10, timeout: 2) else {
                    print("here")
                    return
                }
                if let response = String(bytes: data, encoding: .utf8){
                    dataOutput.text = response
                    print(response)
                }
            case .failure(_):
                response = "Error: failed to obtain response."
                dataOutput.text = response
                print(response)
            }
        case .failure(_):
            response = "Error: failed to connect."
            dataOutput.text = response
            print(response)
        }
        client.close()
    }
    
    func updateGraph(value: [[Double]]){
        var lnChartData = [ChartDataEntry]() //this is the array of points that will be displayed on graph
        var lnChartData2 = [ChartDataEntry]()
        
        for i in 0..<numbers.data[0].count{
            let value = ChartDataEntry(x: Double(i), y: numbers.data[0][i])
            lnChartData.append(value)
            let value2 = ChartDataEntry(x: Double(i), y: numbers.data[1][i])
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

