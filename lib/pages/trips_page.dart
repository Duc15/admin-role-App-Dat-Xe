import 'package:admin_uber_web_panel/widgets/trips_data_list.dart';
import 'package:flutter/material.dart';

import '../methods/common_methods.dart';

class TripsPage extends StatefulWidget {
  static const String id = "\webPageTrips";

  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Quản lý chuyến đi",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              Row(
                children: [
                  cMethods.header(1, "ID chuyến đi"),
                  cMethods.header(1, "Tên khách hàng"),
                  cMethods.header(1, "Tên tài xế"),
                  cMethods.header(2, "Thông tin xe"),
                  cMethods.header(1, "Thời gian"),
                  cMethods.header(1, "Tiền trả"),
                  cMethods.header(1, "Xem thông tin"),
                ],
              ),

              //display data
              TripsDataList(),
            ],
          ),
        ),
      ),
    );
  }
}
