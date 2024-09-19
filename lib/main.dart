/*
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shopnochura/remove_null_value.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<dynamic>> tableData = []; // To store the Excel data

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Excel Read/Write for Web')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => readExcelFromPicker(),
                child: const Text('Pick and Read Excel File'),
              ),
              const SizedBox(height: 20),
              tableData.isNotEmpty
                  ? Expanded(child: buildResponsiveDataTable())
                  : const Text('No Data Loaded'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> readExcelFromPicker() async {
    // Use file_picker to let the user pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'], // Only allow Excel files
    );

    if (result != null) {
      // Get the file bytes
      Uint8List? fileBytes = result.files.first.bytes;

      if (fileBytes != null) {
        // Decode the Excel file
        var excel = Excel.decodeBytes(fileBytes);

        List<List<dynamic>> tempTableData = [];

        // Iterate through the sheets and rows
        for (var table in excel.tables.keys) {
          print(object)('Sheet: $table');
          var sheet = excel.tables[table];
        if (sheet != null) {
          for (var row in sheet.rows) {
            // Filter out empty or null rows
            var rowData = row.map((cell) => cell?.value).toList();
            if (rowData.any((element) => element != null)) {
              tempTableData.add(NullChecker().replaceNullWithSpace(rowData)); // Add row data to tempTableData
            }
          }
        }
      }
        // Update the tableData and refresh the UI
        setState(() {
          tableData = tempTableData;
        });
      } else {
        print(object)("File picking failed: No file bytes available.");
      }
    } else {
      print(object)("File picking cancelled by the user.");
    }
  }

  // Function to build the responsive DataTable from Excel data
  Widget buildResponsiveDataTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust the column width based on available screen width
        double columnWidth = constraints.maxWidth / tableData.first.length;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Scroll horizontally if necessary
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              child: DataTable(
                columns: tableData.isNotEmpty
                    ? tableData.first
                    .map(
                      (col) => DataColumn(
                    label: SizedBox(
                      width: columnWidth,
                      child: Text(
                        col.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
                    .toList()
                    : [], // Create columns from the first row (header row)
                rows: tableData.length > 1
                    ? tableData
                    .sublist(1) // Skip the header row
                    .map(
                      (row) => DataRow(
                    cells: row
                        .map(
                          (cell) => DataCell(
                        SizedBox(
                          width: columnWidth,
                          child: Text(cell.toString()),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                )
                    .toList()
                    : [], // Create rows for the rest of the data
              ),
            ),
          ),
        );
      },
    );
  }
}*/


/*import 'dart:developer';
import 'dart:typed_data';
import 'dart:math'; // For the `max` function
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel; // Prefix for the Excel package
import 'package:file_picker/file_picker.dart';
import 'package:shopnochura/remove_null_value.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<dynamic>> tableData = []; // To store the Excel data

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Excel Read/Write for Web')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => readExcelFromPicker(),
                child: const Text('Pick and Read Excel File'),
              ),
              const SizedBox(height: 20),
              tableData.isNotEmpty
                  ? Expanded(child: buildResponsiveDataTable())
                  : const Text('No Data Loaded'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> readExcelFromPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;

      if (fileBytes != null) {
        var excelFile = excel.Excel.decodeBytes(fileBytes);

        List<List<dynamic>> tempTableData = [];

        for (var table in excelFile.tables.keys) {
          print('Sheet: $table');
          var sheet = excelFile.tables[table];
          if (sheet != null) {
            for (var row in sheet.rows) {
              var rowData = row.map((cell) => cell?.value).toList();
              if (rowData.any((element) => element != null)) {
                tempTableData.add(NullChecker().removeNullValues(rowData));
              }
            }
          }
        }

        setState(() {
          tableData = tempTableData;
        });
      } else {
        print("File picking failed: No file bytes available.");
      }
    } else {
      print("File picking cancelled by the user.");
    }
  }

  double _calculateTextWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(), // Customize if needed
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }

  Widget buildResponsiveDataTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;

        double columnWidth = 0.0;
        if (tableData.isNotEmpty) {
          int columnCount = tableData.first.length;

          List<double> columnWidths = List.generate(columnCount, (index) => 0.0);
          for (var row in tableData) {
            for (int i = 0; i < columnCount; i++) {
              double cellWidth = _calculateTextWidth(row[i].toString());
              columnWidths[i] = max(columnWidths[i], cellWidth);
            }
          }

          columnWidth = maxWidth / columnCount;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: tableData.isNotEmpty
                    ? tableData.first.map(
                      (col) => DataColumn(
                    label: SizedBox(
                      width: columnWidth,
                      child: Text(
                        col.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ).toList()
                    : [],
                rows: tableData.length > 1
                    ? tableData.sublist(1).map(
                      (row) => DataRow(
                    cells: row.map(
                          (cell) => DataCell(
                        SizedBox(
                          width: columnWidth,
                          child: Text(
                            cell.toString(),
                            overflow: TextOverflow.visible, // Ensure text is fully visible
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ).toList()
                    : [],
              ),
            ),
          ),
        );
      },
    );
  }
}*/


import 'dart:developer';
import 'dart:typed_data';
import 'dart:math'; // For the `max` function
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel; // Prefix for the Excel package
import 'package:file_picker/file_picker.dart';
import 'package:retcore/retcore.dart';
import 'package:shopnochura/remove_null_value.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<dynamic>> tableData = []; // To store the Excel data
  double totalSum = 0.0; // To store the sum of the column values

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Excel Read/Write for Web')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => readExcelFromPicker(),
                child: const Text('Pick and Read Excel File'),
              ),
              const SizedBox(height: 20),
              tableData.isNotEmpty
                  ? Expanded(child: buildResponsiveDataTable())
                  : const Text('No Data Loaded'),
              const SizedBox(height: 20),
              Text(
                'Total Sum: $totalSum',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> readExcelFromPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;

      if (fileBytes != null) {
        var excelFile = excel.Excel.decodeBytes(fileBytes);

        List<List<dynamic>> tempTableData = [];
        int targetColumnIndex = -1; // Column index of the target column

        for (var table in excelFile.tables.keys) {
          print('Sheet: $table');
          var sheet = excelFile.tables[table];
          if (sheet != null) {
            for (var i = 0; i < sheet.rows.length; i++) {
              var row = sheet.rows[i];
              var rowData = row.map((cell) => cell?.value).toList();

              // Find the index of the target column
              if (i == 0) { // Assuming the first row is the header row
                targetColumnIndex = rowData.indexWhere((value) =>
                value.toString() == 'জানুয়ারী ২০১৮ইং হইতে ডিসেম্বর ২০২২ইং পর্যন্ত মোট মাসিক জামানত, ভর্তি ফি ও বিশেষ চাঁদা জমা'
                );
              } else {
                // Process the data rows
                if (targetColumnIndex != -1 && targetColumnIndex < rowData.length) {
                  var value = rowData[targetColumnIndex];
                  if (value != null) {
                    try {
                      print(value);
                      double numericValue = double.parse(convertBanglaToEnglishDigits(value.toString()));
                      totalSum += numericValue; // Accumulate the sum
                    } catch (e) {
                      print('Error parsing value: $value');
                    }
                  }
                }
              }
              print(totalSum);
              tempTableData.add(NullChecker().removeNullValues(rowData));
            }
          }
        }

        setState(() {
          tableData = tempTableData;
        });
      } else {
        print("File picking failed: No file bytes available.");
      }
    } else {
      print("File picking cancelled by the user.");
    }
  }

  String convertBanglaToEnglishDigits(String banglaNumber) {
    // Map Bengali digits to English digits
    final Map<String, String> banglaToEnglishMap = {
      '০': '0',
      '১': '1',
      '২': '2',
      '৩': '3',
      '৪': '4',
      '৫': '5',
      '৬': '6',
      '৭': '7',
      '৮': '8',
      '৯': '9'
    };
    // Convert each Bengali digit to English
    String englishNumber = banglaNumber.split('').map((char) {
      return banglaToEnglishMap[char] ?? char; // Replace Bengali digit or keep the character if not found
    }).join('');

    return englishNumber;
  }

  double _calculateTextWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(), // Customize if needed
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }

  Widget buildResponsiveDataTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;

        double columnWidth = 0.0;
        if (tableData.isNotEmpty) {
          int columnCount = tableData.first.length;

          List<double> columnWidths = List.generate(columnCount, (index) => 0.0);
          for (var row in tableData) {
            for (int i = 0; i < columnCount; i++) {
              double cellWidth = _calculateTextWidth(row[i].toString());
              columnWidths[i] = max(columnWidths[i], cellWidth);
            }
          }

          columnWidth = maxWidth / columnCount;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: tableData.isNotEmpty
                    ? tableData.first.map(
                      (col) => DataColumn(
                    label: SizedBox(
                      width: columnWidth,
                      child: Text(
                        col.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ).toList()
                    : [],
                rows: tableData.length > 1
                    ? tableData.sublist(1).map(
                      (row) => DataRow(
                    cells: row.map(
                          (cell) => DataCell(
                        SizedBox(
                          width: columnWidth,
                          child: Text(
                            cell.toString(),
                            overflow: TextOverflow.visible, // Ensure text is fully visible
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ).toList()
                    : [],
              ),
            ),
          ),
        );
      },
    );
  }
}
