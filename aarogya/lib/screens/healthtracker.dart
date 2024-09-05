import 'package:aarogya/widgets/customButton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:aarogya/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart'; // Ensure this file exists and contains custom colors

class HealthTracker extends StatefulWidget {
  const HealthTracker({super.key});

  @override
  State<HealthTracker> createState() => _HealthTrackerState();
}

class _HealthTrackerState extends State<HealthTracker> {
  List<FlSpot> bpData = [];
  List<FlSpot> sugarData = [];

  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();

  String selectedGraph = "";

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(11, 143, 172, 1),
      statusBarIconBrightness: Brightness.light,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setStatusBarColor();
    });
  }

  Future<void> _setStatusBarColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(
      Color.fromRGBO(11, 143, 172, 1),
    );
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HealthTracker",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: buttonColor, // Your custom color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Track Your Health",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 20),

            // BP and Sugar Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Track BP",
                    onPressed: () {
                      setState(() {
                        selectedGraph = "bp";
                      });
                      _showBPDialog(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: "Track Sugar",
                    onPressed: () {
                      setState(() {
                        selectedGraph = "sugar";
                      });
                      _showSugarDialog(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Display Graphs
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: selectedGraph.isNotEmpty
                    ? (selectedGraph == "bp"
                        ? _buildBPGraph()
                        : _buildSugarGraph())
                    : Center(
                        child: Text(
                          "Select an option to visualize your data",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BP Input Dialog
  Future<void> _showBPDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter BP Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: systolicController,
                decoration:
                    const InputDecoration(labelText: 'Systolic Pressure'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: diastolicController,
                decoration:
                    const InputDecoration(labelText: 'Diastolic Pressure'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (systolicController.text.isNotEmpty &&
                    diastolicController.text.isNotEmpty) {
                  setState(() {
                    double systolic = double.parse(systolicController.text);
                    double diastolic = double.parse(diastolicController.text);
                    bpData.add(FlSpot(bpData.length.toDouble(), systolic));
                    bpData.add(FlSpot(bpData.length.toDouble(), diastolic));
                  });
                  systolicController.clear();
                  diastolicController.clear();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Sugar Input Dialog
  Future<void> _showSugarDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Sugar Level'),
          content: TextField(
            controller: sugarController,
            decoration: const InputDecoration(labelText: 'Sugar Level'),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (sugarController.text.isNotEmpty) {
                  setState(() {
                    double sugar = double.parse(sugarController.text);
                    sugarData.add(FlSpot(sugarData.length.toDouble(), sugar));
                  });
                  sugarController.clear();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // BP Graph Widget
  Widget _buildBPGraph() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: bpData,
            isCurved: true,
            barWidth: 3,
            color: Colors.blue.shade400,
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,

              // sideTitles: SideTitles(
              //   showTitles: true,
              //   reservedSize: 40,
              //   getTitlesWidget: (value, meta) {
              //     return SideTitleWidget(
              //       axisSide: meta.axisSide,
              //       child: Text(
              //         value.toString(),
              //         style: TextStyle(fontSize: 14, color: Colors.black),
              //       ),
              //     );
              //   },
              // ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
    );
  }

  // Sugar Graph Widget
  Widget _buildSugarGraph() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: sugarData,
            isCurved: true,
            barWidth: 3,
            color: Colors.red.shade400,
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
    );
  }
}
