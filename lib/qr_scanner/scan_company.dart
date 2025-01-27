import 'package:flutter/material.dart';

class ScanCompany extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Company'),
      ),
      body: Center(
        child: Text('Which Company do you want to scan?'),
      ),
    );
  }
}