// import 'package:admin_uber_web_panel/methods/common_methods.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class UsersDataList extends StatefulWidget {
//   const UsersDataList({super.key});

//   @override
//   State<UsersDataList> createState() => _UsersDataListState();
// }

// class _UsersDataListState extends State<UsersDataList> {
//   final usersRecordsFromDatabase =
//       FirebaseDatabase.instance.ref().child("users");
//   CommonMethods cMethods = CommonMethods();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: usersRecordsFromDatabase.onValue,
//       builder: (BuildContext context, snapshotData) {
//         if (snapshotData.hasError) {
//           return const Center(
//             child: Text(
//               "Có lỗi xảy ra vui lòng thử lại sau !",
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
//                   2,
//                   Text(itemsList[index]["id"].toString()),
//                 ),
//                 cMethods.data(
//                   1,
//                   Text(itemsList[index]["name"].toString()),
//                 ),
//                 cMethods.data(
//                   1,
//                   Text(itemsList[index]["email"].toString()),
//                 ),
//                 cMethods.data(
//                   1,
//                   Text(itemsList[index]["phone"].toString()),
//                 ),
//                 cMethods.data(
//                   1,
//                   ElevatedButton(
//                     onPressed: () async {
//                       String currentStatus = itemsList[index]["blockStatus"];
//                       await FirebaseDatabase.instance
//                           .ref()
//                           .child("users")
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
//               ],
//             );
//           }),
//         );
//       },
//     );
//   }
// }
