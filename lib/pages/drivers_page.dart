import 'package:admin_uber_web_panel/methods/common_methods.dart';
import 'package:admin_uber_web_panel/widgets/drivers_data_list.dart';
import 'package:flutter/material.dart';

class DriversPage extends StatefulWidget {
  static const String id = "\webPageDrivers";

  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
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
                  "Manage Drivers",
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
                  cMethods.header(1, "ID tài xế"),
                  cMethods.header(1, "Ảnh"),
                  cMethods.header(1, "Tên"),
                  cMethods.header(2, "Thông tin xe"),
                  cMethods.header(1, "Số điện thoại"),
                  cMethods.header(1, "Tổng thu nhập"),
                  cMethods.header(1, "Hành động"),
                ],
              ),

              //display data
              DriversDataList(),
            ],
          ),
        ),
      ),
    );
  }
}
