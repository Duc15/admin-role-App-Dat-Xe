import 'package:flutter/material.dart';

class CommonMethods {
  // Updated header method with optional textAlign
  Widget header(int headerFlexValue, String headerTitle,
      {TextAlign textAlign = TextAlign.center}) {
    return Expanded(
      flex: headerFlexValue,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.pink.shade500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            headerTitle,
            textAlign: textAlign, // Apply textAlign to header
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Updated data method with optional textAlign, but now each row will have a border
  Widget data(int dataFlexValue, Widget widget,
      {TextAlign textAlign = TextAlign.center}) {
    return Expanded(
      flex: dataFlexValue,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.center,
            child: widget is Text
                ? Text(
                    widget.data ?? '', // Ensure data is a string
                    textAlign: textAlign, // Apply textAlign to Text widget
                    style: const TextStyle(fontSize: 16),
                  )
                : widget, // If not Text widget, display it as is
          ),
        ),
      ),
    );
  }

  // Method to wrap each row inside a container with a border
  Widget rowWithBorder(List<Widget> rowWidgets) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Single border for each row
      ),
      child: Row(
        children: rowWidgets,
      ),
    );
  }
}
