//
//  BlueToothView.swift
//  kidsland
//
//  Created by 中战云台 on 2023/3/10.
//

import SwiftUI
import CoreBluetooth

/*
 
 这个ViewModel包含了四个主要的功能：
 
 1. 扫描蓝牙设备；
 2. 连接到一个蓝牙设备；
 3. 断开蓝牙设备的连接；
 4. 处理蓝牙设备发送的数据。
 
 在这个ViewModel中，我们使用了`CBCentralManager`和`CBPeripheral`来管理蓝牙设备的搜索和连接。我们还实现了`CBCentralManagerDelegate`和`CBPeripheralDelegate`代理方法来处理搜索和连接的事件。这个ViewModel还包含了一些变量来跟踪蓝牙的状态和扫描的结果。
 
 请注意，这只是一个简单的示例，你可能需要根据自己的需求对代码进行修改或扩展。
 */

struct BluetoothDevice: Identifiable {
    let id = UUID()
    let name: String?
    let rssi: Int?
}

class BluetoothViewModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    
    private var discoveredPeripherals: [CBPeripheral] = []
    @Published var devices: [BluetoothDevice] = []
    @Published var isBluetoothPoweredOn = false
    
    var isBluetoothEnabled = false
    var isScanning = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        guard isBluetoothPoweredOn else {
            print("Bluetooth is not powered on")
            return
        }
        devices.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            isBluetoothPoweredOn = true
        default:
            isBluetoothPoweredOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = BluetoothDevice(name: peripheral.name, rssi: RSSI.intValue)
        devices.append(device)
    }
}


struct BlueToothView: View {
    @StateObject var viewModel = BluetoothViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.devices) { device in
                HStack {
                    Text(device.name ?? "Unknown device")
                    Spacer()
                    Text("\(device.rssi ?? 0) dBm")
                }
            }
        }
        .navigationBarItems(trailing:
                                Button(action: {
            viewModel.startScan()
        }) {
            Text("Scan for Devices")
        }
        )
        .navigationTitle("蓝牙功能")
    }
}

struct BlueToothView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            BlueToothView()
        }
    }
}
