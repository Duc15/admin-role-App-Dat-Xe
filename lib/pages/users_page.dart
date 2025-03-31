import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../methods/common_methods.dart';

class UsersPage extends StatefulWidget {
  static const String id = "\webPageUsers";

  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  CommonMethods cMethods = CommonMethods();
  String searchQuery = ""; // Biến lưu trữ từ khóa tìm kiếm

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
                  "Quản lý khách",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Thanh tìm kiếm
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery =
                        value.toLowerCase(); // Cập nhật từ khóa tìm kiếm
                  });
                },
                decoration: InputDecoration(
                  labelText: "Tìm kiếm tên người dùng",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  cMethods.header(1, "STT", textAlign: TextAlign.center),
                  cMethods.header(2, "Tên", textAlign: TextAlign.center),
                  cMethods.header(2, "Email", textAlign: TextAlign.center),
                  cMethods.header(2, "Số điện thoại",
                      textAlign: TextAlign.center),
                  cMethods.header(2, "Hành động", textAlign: TextAlign.center),
                ],
              ),
              const UserDataList(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDataList extends StatefulWidget {
  const UserDataList({super.key});

  @override
  State<UserDataList> createState() => _UserDataListState();
}

class _UserDataListState extends State<UserDataList> {
  final usersRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child("users");
  CommonMethods cMethods = CommonMethods();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersRecordsFromDatabase.onValue,
      builder: (BuildContext context, snapshotData) {
        if (snapshotData.hasError) {
          return const Center(
            child: Text(
              "Lỗi xảy ra. Thử lại sau.",
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

        // Lọc danh sách người dùng dựa trên từ khóa tìm kiếm
        List filteredList = itemsList.where((user) {
          final name = user["name"].toString().toLowerCase();
          return name.contains(searchQuery); // Tìm kiếm theo tên
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            return Table(
              border: TableBorder.symmetric(
                inside: BorderSide.none,
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? Colors.white
                        : Colors.blueGrey.withOpacity(0.05),
                  ),
                  children: [
                    Center(
                        child: Text((index + 1).toString(),
                            textAlign: TextAlign.center)), // STT
                    Center(
                        child: Text(filteredList[index]["name"].toString(),
                            textAlign: TextAlign.center)), // Tên
                    Center(
                        child: Text(filteredList[index]["email"].toString(),
                            textAlign: TextAlign.center)), // Email
                    Center(
                        child: Text(filteredList[index]["phone"].toString(),
                            textAlign: TextAlign.center)), // Số điện thoại
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseDatabase.instance
                              .ref()
                              .child("users")
                              .child(filteredList[index]["key"])
                              .update({
                            "blockStatus":
                                filteredList[index]["blockStatus"] == "no"
                                    ? "yes"
                                    : "no",
                          });
                        },
                        child: Text(
                          filteredList[index]["blockStatus"] == "no"
                              ? "Chặn"
                              : "Mở chặn",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
