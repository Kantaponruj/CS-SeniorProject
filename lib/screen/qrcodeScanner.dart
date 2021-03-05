import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

class qrcodeScanner extends StatefulWidget {
  @override
  _qrcodeScannerState createState() => _qrcodeScannerState();
}

class _qrcodeScannerState extends State<qrcodeScanner> {
  GlobalKey qrKey = GlobalKey();
  var qrText = "";
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: QRView(
                  key: qrKey,
                  overlay: QrScannerOverlayShape(
                    borderRadius: 10,
                    borderColor: Colors.red,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                  onQRViewCreated: _onQRViewCreate)),
          Expanded(
            flex: 1,
            child: Center(child: Text('Scan Result: $qrText')),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }
}
