import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';

class PropertyFragment extends StatelessWidget {
  PropertyFragment({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Head
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text
                      const Text(
                        "Property",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      // Color mark
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: kbuttonNewColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                  MyNewPinkButton(
                    width: 200,
                    title: "+ New Property",
                    onPressFunction: () {},
                  ),
                ],
              ),
            ),
            // Divider line
            Container(
              height: 1,
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20),
            // Search Box
            Container(
              width: 500,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Search",
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        "#",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Property Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Property Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Property Address",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Total Unity",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Created_at",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Actions",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('1')),
                      const DataCell(Text('Samora Tower')),
                      const DataCell(Text('Business')),
                      const DataCell(Text('Posta, Dar-es-salaam')),
                      const DataCell(Text('20')),
                      const DataCell(Text('14:56 15-08-2024')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_red_eye),
                              color: CupertinoColors.systemBlue,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.mode_edit_outline),
                              color: CupertinoColors.systemGreen,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                              color: Colors.redAccent,
                            ),
                          ],
                        ),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('2')),
                      const DataCell(Text('Mwanga Tower')),
                      const DataCell(Text('Business')),
                      const DataCell(Text('Makumbusho, Dar-es-salaam')),
                      const DataCell(Text('32')),
                      const DataCell(Text('15:56 15-05-2024')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_red_eye),
                              color: CupertinoColors.systemBlue,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.mode_edit_outline),
                              color: CupertinoColors.systemGreen,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                              color: Colors.redAccent,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
