import 'package:admin_uber_web_panel/methods/common_methods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện intl

class DriversDataList extends StatefulWidget {
  const DriversDataList({super.key});

  @override
  State<DriversDataList> createState() => _DriversDataListState();
}

class _DriversDataListState extends State<DriversDataList> {
  final driversRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child("drivers");
  CommonMethods cMethods = CommonMethods();

  // Hàm chuyển đổi từ USD sang VND và định dạng
  String convertToVND(double usd) {
    const double exchangeRate = 24000;
    double vnd = usd * exchangeRate;
    return NumberFormat.currency(locale: 'vi', symbol: '₫').format(vnd);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: driversRecordsFromDatabase.onValue,
      builder: (BuildContext context, snapshotData) {
        if (snapshotData.hasError) {
          return const Center(
            child: Text(
              "Error Occurred. Try Later.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.pink,
              ),
            ),
          );
        }

        if (snapshotData.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Map dataMap = snapshotData.data!.snapshot.value as Map;
        List itemsList = [];
        dataMap.forEach((key, value) {
          itemsList.add({"key": key, ...value});
        });

        return ListView.builder(
          shrinkWrap: true,
          itemCount: itemsList.length,
          itemBuilder: ((context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cMethods.data(
                  1,
                  Text(itemsList[index]["id"].toString()),
                ),
                cMethods.data(
                  1,
                  Image.network(
                    itemsList[index]["photo"].toString(),
                    width: 50,
                    height: 50,
                  ),
                ),
                cMethods.data(
                  1,
                  Text(itemsList[index]["name"].toString()),
                ),
                cMethods.data(
                  2,
                  Text(
                      "${itemsList[index]["car_details"]["carModel"]} - ${itemsList[index]["car_details"]["carNumber"]} - ${itemsList[index]["car_details"]["carColor"]}"),
                ),
                cMethods.data(
                  1,
                  Text(itemsList[index]["phone"].toString()),
                ),
                cMethods.data(
                  1,
                  itemsList[index]["earnings"] != null
                      ? Text(convertToVND(double.tryParse(
                              itemsList[index]["earnings"].toString()) ??
                          0.0))
                      : const Text("0 đ"),
                ),
                cMethods.data(
                  1,
                  itemsList[index]["blockStatus"] == "no"
                      ? ElevatedButton(
                          onPressed: () async {
                            await FirebaseDatabase.instance
                                .ref()
                                .child("drivers")
                                .child(itemsList[index]["id"])
                                .update({
                              "blockStatus": "yes",
                            });
                          },
                          child: const Text(
                            "Chặn",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            await FirebaseDatabase.instance
                                .ref()
                                .child("drivers")
                                .child(itemsList[index]["id"])
                                .update({
                              "blockStatus": "no",
                            });
                          },
                          child: const Text(
                            "Mở chặn",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
