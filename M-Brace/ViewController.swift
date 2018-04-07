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
        
        // Mutator function:
        //  - updates/appends new sensor values
        //  - pops old sensor values off the array if array size is >15
        func getSensorData(sensorValues: [Double]) {
            for i in 0..<self.numSensors {
                self.data[i].append(sensorValues[i])
                if (self.data[i].count > 15) {
                    self.data[i].removeFirst()
                }
            }
        }
        
        // Sets up chart sensor data from the class sensor data
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
    
    // replace with clientRequestData to test chart input values
    // delete this function when txtBox from the storyboard is removed!!!
    var testnumbers = SensorData(numSensors: 2)
    func sampleTestData() {
        let input = Double(txtBox.text!)
        testnumbers.data[0].append(input!)
        if (testnumbers.data[0].count > 15) {
            testnumbers.data[0].removeFirst()
        }
        let input2 = Double(txtBox2.text!)
        testnumbers.data[1].append(input2!)
        if (testnumbers.data[1].count > 15) {
            testnumbers.data[1].removeFirst()
        }
    }
    
    func clientRequestData() -> ([Double]) {
        var output = ""
        let client = TCPClient(address: "127.0.0.1", port: 12000)
        switch client.connect(timeout: 10){
        case .success:
            switch client.send(string: "hello world\n"){
            case .success:
                // timeout is necessary
                guard let data = client.read(1024*10, timeout: 2) else {
                    output = "Error: Failed to read data"
                    dataOutput.text = output
                    print(output)
                    return []
                }
                if let response = String(bytes: data, encoding: .utf8){
                    output = response
                    dataOutput.text = output
                    print(output)
                    return response.components(separatedBy: " ").flatMap { Double($0) }
                }
            case .failure(_):
                output = "Error: failed to obtain response."
                dataOutput.text = output
                print(output)
                break
            }
        case .failure(_):
            output = "Error: failed to connect."
            dataOutput.text = output
            print(output)
        }
        client.close()
        return []
    }
    
    //Trigger button to plot data
    var numbers = SensorData(numSensors: 3)
    var buttonflag = false // flag is false if button has not been pressed once
    @IBAction func didTapButton(_ sender: UIButton) {
        let output = clientRequestData()
        // if output array is empty, failed to setup TCPServer properly
        if (output.count != 0) {
            updateGraph(sensorDataSet: output)
        }
    }
    
    func updateGraph(sensorDataSet: [Double]){
        numbers.getSensorData(sensorValues: sensorDataSet)
        let data = numbers.createSensorChartData()
        lnChart.data = data //adds the chart data to chart and graph updates
        lnChart.chartDescription?.text = "line graph"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

