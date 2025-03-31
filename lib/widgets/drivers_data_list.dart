// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Thêm thư viện intl
// import 'package:firebase_database/firebase_database.dart';
// import 'package:admin_uber_web_panel/methods/common_methods.dart';

// class DriversDataList extends StatefulWidget {
//   const DriversDataList({super.key});

//   @override
//   State<DriversDataList> createState() => _DriversDataListState();
// }

// class _DriversDataListState extends State<DriversDataList> {
//   final driversRecordsFromDatabase =
//       FirebaseDatabase.instance.ref().child("drivers");
//   CommonMethods cMethods = CommonMethods();

//   // Hàm chuyển đổi từ USD sang VND và định dạng
//   String convertToVND(double usd) {
//     const double exchangeRate = 24000;
//     double vnd = usd * exchangeRate;
//     return NumberFormat.currency(locale: 'vi', symbol: '₫').format(vnd);
//   }

//   // Hàm hiển thị thông tin chi tiết tài xế
//   void showDriverDetails(Map driverData) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Thông tin chi tiết tài xế'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Ảnh CMND
//               driverData["idCardImage"] != null
//                   ? Image.network(
//                       driverData["idCardImage"].toString(),
//                       width: 150,
//                       height: 150,
//                     )
//                   : const Text("Chưa có ảnh CMND"),

//               const SizedBox(height: 10),
//               // Tên
//               Text("Tên: ${driverData['name']}"),
//               // Địa chỉ
//               Text("Địa chỉ: ${driverData['address']}"),
//               // Ngày sinh
//               Text("Ngày sinh: ${driverData['dob']}"),
//               // Giới tính
//               Text("Giới tính: ${driverData['gender']}"),
//               // ID
//               Text("ID: ${driverData['id']}"),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("Đóng"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: driversRecordsFromDatabase.onValue,
//       builder: (BuildContext context, snapshotData) {
//         if (snapshotData.hasError) {
//           return const Center(
//             child: Text(
//               "Error Occurred. Try Later.",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//                 color: Colors.pink,
//               ),
//             ),
//           );
//         }

//         if (snapshotData.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         Map dataMap = snapshotData.data!.snapshot.value as Map;
//         List itemsList = [];
//         dataMap.forEach((key, value) {
//           itemsList.add({"key": key, ...value});
//         });

//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: itemsList.length,
//           itemBuilder: ((context, index) {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 cMethods.data(
//                   1,
//                   Text(itemsList[index]["id"].toString()),
//                 ),
//                 cMethods.data(
//                   1,
//                   Image.network(
//                     itemsList[index]["photo"].toString(),
//                     width: 50,
//                     height: 50,
//                   ),
//                 ),
//                 cMethods.data(
//                   1,
//                   Text(itemsList[index]["name"].toString()),
//                 ),
//                 cMethods.data(
//                   2,
//                   Text(
//                       "${itemsList[index]["car_details"]["carModel"]} - ${itemsList[index]["car_details"]["carNumber"]} - ${itemsList[index]["car_details"]["carColor"]}"),
//                 ),
//                 cMethods.data(
//                   1,
//                   Text(itemsList[index]["phone"].toString()),
//                 ),
//                 cMethods.data(
//                   1,
//                   itemsList[index]["earnings"] != null
//                       ? Text(convertToVND(double.tryParse(
//                               itemsList[index]["earnings"].toString()) ??
//                           0.0))
//                       : const Text("0 đ"),
//                 ),
//                 // Button with color change based on blockStatus
//                 cMethods.data(
//                   1,
//                   ElevatedButton(
//                     onPressed: () async {
//                       String currentStatus = itemsList[index]["blockStatus"];
//                       await FirebaseDatabase.instance
//                           .ref()
//                           .child("drivers")
//                           .child(itemsList[index]["id"])
//                           .update({
//                         "blockStatus": currentStatus == "no" ? "yes" : "no",
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: itemsList[index]["blockStatus"] == "no"
//                           ? Colors.white
//                           : Colors.red, // White for unblocked, Red for blocked
//                       side: BorderSide(
//                           color: itemsList[index]["blockStatus"] == "no"
//                               ? Colors.grey
//                               : Colors.red), // Border color change
//                     ),
//                     child: Text(
//                       itemsList[index]["blockStatus"] == "no"
//                           ? "Chặn"
//                           : "Mở chặn",
//                       style: TextStyle(
//                         color: itemsList[index]["blockStatus"] == "no"
//                             ? Colors.black
//                             : Colors.white, // Text color change
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Nút Xem Chi Tiết
//                 IconButton(
//                   icon: const Icon(Icons.info_outline),
//                   onPressed: () {
//                     // Gọi hàm để hiển thị chi tiết tài xế
//                     showDriverDetails(itemsList[index]);
//                   },
//                 ),
//               ],
//             );
//           }),
//         );
//       },
//     );
//   }
// }
