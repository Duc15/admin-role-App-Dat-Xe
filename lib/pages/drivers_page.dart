import 'package:admin_uber_web_panel/methods/common_methods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện intl

class DriversPage extends StatefulWidget {
  static const String id = "\webPageDrivers";

  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
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
                  "Quản lý tài xế",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Thanh tìm kiếm
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery =
                        value.toLowerCase(); // Cập nhật từ khóa tìm kiếm
                  });
                },
                decoration: InputDecoration(
                  labelText: "Tìm kiếm",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 18),

              // Tiêu đề cột của bảng
              Table(
                border: const TableBorder.symmetric(
                  inside: BorderSide.none,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3), // Tăng chiều rộng cột tên
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                  6: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                    ),
                    children: [
                      cMethods.header(1, "STT", textAlign: TextAlign.center),
                      cMethods.header(1, "Tên", textAlign: TextAlign.center),
                      cMethods.header(1, "Loại xe",
                          textAlign: TextAlign.center),
                      cMethods.header(1, "Biển số xe",
                          textAlign: TextAlign.center),
                      cMethods.header(1, "Số điện thoại",
                          textAlign: TextAlign.center),
                      cMethods.header(1, "Tổng thu nhập",
                          textAlign: TextAlign.center),
                      cMethods.header(1, "Hành động",
                          textAlign: TextAlign.center),
                      cMethods.header(1, "Chi tiết",
                          textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),

              // Hiển thị dữ liệu
              const SizedBox(height: 8),
              DriversDataList(
                  searchQuery: searchQuery), // Truyền từ khóa tìm kiếm
            ],
          ),
        ),
      ),
    );
  }
}

class DriversDataList extends StatefulWidget {
  final String searchQuery;

  const DriversDataList({super.key, required this.searchQuery});

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

  // Hàm hiển thị thông tin chi tiết tài xế
  void showDriverDetails(String driverId) async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(driverId)
        .child('infoPersonal');

    DataSnapshot snapshot = await userRef.get();

    if (!snapshot.exists) {
      // Không có dữ liệu
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thông tin tài xế'),
            content: const Text('Không có thông tin chi tiết cho tài xế này.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Dữ liệu tồn tại, hiển thị thông tin
    Map? infoPersonal = snapshot.value as Map?;
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông tin chi tiết tài xế'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Họ và Tên: ${infoPersonal?['name'] ?? 'Không có'}"),
              Text("Địa chỉ: ${infoPersonal?['address'] ?? 'Không có'}"),
              Text("Ngày sinh: ${infoPersonal?['dob'] ?? 'Không có'}"),
              Text("Giới tính: ${infoPersonal?['sex'] ?? 'Không có'}"),
              Text("Quốc gia: ${infoPersonal?['nationality'] ?? 'Không có'}"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Đóng"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: driversRecordsFromDatabase.onValue,
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

        // Lọc danh sách dựa trên từ khóa tìm kiếm
        List filteredList = itemsList.where((driver) {
          final name = driver["name"].toString().toLowerCase();
          return name.contains(widget.searchQuery);
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: filteredList.length,
          itemBuilder: ((context, index) {
            return Table(
              border: const TableBorder.symmetric(
                inside: BorderSide.none,
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3), // Tăng chiều rộng cột tên
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
                6: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? Colors.white
                        : Colors.blueGrey.withOpacity(0.05),
                  ),
                  children: [
                    cMethods.data(
                        1,
                        Text((index + 1).toString(),
                            textAlign: TextAlign.center)), // STT
                    cMethods.data(
                        3,
                        Text(filteredList[index]["name"].toString(),
                            textAlign: TextAlign.center)), // Tên
                    cMethods.data(
                        2,
                        Text(
                            filteredList[index]["car_details"]["carModel"]
                                .toString(),
                            textAlign: TextAlign.center)), // Loại xe
                    cMethods.data(
                        2,
                        Text(
                            filteredList[index]["car_details"]["carNumber"]
                                .toString(),
                            textAlign: TextAlign.center)), // Biển số
                    cMethods.data(
                        2,
                        Text(filteredList[index]["phone"].toString(),
                            textAlign: TextAlign.center)), // SĐT
                    cMethods.data(
                        2,
                        filteredList[index]["earnings"] != null
                            ? Text(
                                convertToVND(double.tryParse(filteredList[index]
                                            ["earnings"]
                                        .toString()) ??
                                    0.0),
                                textAlign: TextAlign.center)
                            : const Text("0 đ", textAlign: TextAlign.center)),
                    cMethods.data(
                        2,
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseDatabase.instance
                                .ref()
                                .child("drivers")
                                .child(filteredList[index]["id"]!)
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
                        )),
                    cMethods.data(
                        2,
                        filteredList[index]['infoPersonal'] !=
                                null // Kiểm tra dữ liệu
                            ? IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                                  showDriverDetails(filteredList[index]
                                      ['key']); // Gọi hàm chi tiết
                                },
                              )
                            : const Icon(Icons.info_outline,
                                color: Colors.grey)), // Nút không hoạt động
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
