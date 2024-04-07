import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smartinventory/RFID/device.dart';

class SelectBondedDevicePage extends StatefulWidget {
  /// If true, on page start there is performed discovery upon the bonded devices.
  /// Then, if they are not avaliable, they would be disabled from the selection.
  final bool checkAvailability;
  final Function onCahtPage;

  const SelectBondedDevicePage(
      {super.key, this.checkAvailability = true, required this.onCahtPage});

  @override
  _SelectBondedDevicePage createState() => _SelectBondedDevicePage();
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int? rssi;

  _DeviceWithAvailability(this.device, this.availability): super(address: device.address);
}

class _SelectBondedDevicePage extends State<SelectBondedDevicePage> {
  List<_DeviceWithAvailability> devices = [];

  // Availability
  late StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  late bool _isDiscovering;

  _SelectBondedDevicePage();

  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
                device,
                widget.checkAvailability
                    ? _DeviceAvailability.maybe
                    : _DeviceAvailability.yes,
              ),
            )
            .toList();
      });
    });
  }

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var device = i.current;
          if (device.device == r.device) {
            device.availability = _DeviceAvailability.yes;
            device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _discoveryStreamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        .map(
          (device) => BluetoothDeviceListEntry(
            device: device.device,
            // rssi: _device.rssi,
            // enabled: _device.availability == _DeviceAvailability.yes,
            onTap: () {
              widget.onCahtPage(device.device);
            }, rssi: 0, onLongPress: () {  },
          ),
        )
        .toList();
    return ListView(
      children: list,
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Select device'),
    //     actions: <Widget>[
    //       _isDiscovering
    //           ? FittedBox(
    //               child: Container(
    //                 margin: new EdgeInsets.all(16.0),
    //                 child: CircularProgressIndicator(
    //                   valueColor: AlwaysStoppedAnimation<Color>(
    //                     Colors.white,
    //                   ),
    //                 ),
    //               ),
    //             )
    //           : IconButton(
    //               icon: Icon(Icons.replay),
    //               onPressed: _restartDiscovery,
    //             )
    //     ],
    //   ),
    //   body: ListView(children: list),
    // );
  }
}
