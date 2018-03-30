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
    
    class SensorData {
        var numSensors : Int
        var data = [[Double]]() //store all numbers/imported set of numbers here
        let colorArray: [UIColor] = [.blue, .red, .magenta, .green, .brown, .orange]
        let labelArray: [String] = ["Line 1", "Line 2", "Line 3", "Line 4", "Line 5", "Line 6"]
        
        init(numSensors: Int) {
            self.numSensors = numSensors
            for _ in 0...self.numSensors{
                self.data.append([])
            }
        }
        
        func getSensorData(sensorValues: [Double]) {
            for i in 0..<self.numSensors {
                self.data[i].append(sensorValues[i])
                if (self.data[i].count > 15) {
                    self.data[i].removeFirst()
                }
            }
        }
        
        func createSensorChartData() -> (LineChartData) {
            var lnChartData = [[ChartDataEntry]]() //array of points that will be displayed on graph
            var line: [IChartDataSet] = []
            
            for _ in 0...self.numSensors {
                lnChartData.append([])
            }
            
            for j in 0..<self.numSensors {
                for i in 0..<self.data[0].count {
                    let value = ChartDataEntry(x: Double(i), y: self.data[j][i])
                    lnChartData[j].append(value)
                }
                line.append(LineChartDataSet(values: lnChartData[j], label: self.labelArray[j]))
                line[j].setColor(self.colorArray[j])
            }
            return LineChartData(dataSets: line) //object will be added to chart
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
    var numbers = SensorData(numSensors: 2)
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
        updateGraph(numbers: numbers)
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
    
    func updateGraph(numbers: SensorData){
        let data = numbers.createSensorChartData()
        lnChart.data = data //adds the chart data to chart and graph updates
        lnChart.chartDescription?.text = "line graph"
        /*
        var lnChartData = [[ChartDataEntry]]() //this is the array of points that will be displayed on graph
        var line: [IChartDataSet] = []
        
        for _ in 0...numbers.numSensors {
            lnChartData.append([])
        }
        
        for i in 0..<numbers.data[0].count{
            let value = ChartDataEntry(x: Double(i), y: numbers.data[0][i])
            lnChartData[0].append(value)
            let value2 = ChartDataEntry(x: Double(i), y: numbers.data[1][i])
            lnChartData[1].append(value2)
        }
        line.append(LineChartDataSet(values: lnChartData[0], label: "Line1"))
        line[0].setColor(.blue)
        
        line.append(LineChartDataSet(values: lnChartData[1], label: "Line2"))
        line[1].setColor(.red)
        
        let data = LineChartData(dataSets: line) //object will be added to chart
    */
        
        //lnChart.data = data //adds the chart data to chart and graph updates
        //lnChart.chartDescription?.text = "line graph"
    }
    


}

