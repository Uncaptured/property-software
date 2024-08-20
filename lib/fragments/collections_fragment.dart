import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';

class CollectionFragment extends StatelessWidget {
  CollectionFragment({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 30.0
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
                        "Collections",
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

                  MyNewPinkButton(width: 200, title: "+ New Collection", onPressFunction: (){}),
                ],
              ),
            ),



            // Divider line
            Container( // Make it take the full width
              height: 1,
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
              ),
            ),


            const SizedBox(height: 20,),


            // Search Box
            Container(
              width: 500,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30)
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


            const SizedBox(height: 20,),

            //  tables
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
                      DataColumn(label: Text("#", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Property Name", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Type", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Created_at", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('1')),
                        const DataCell(Text('Samora Tower', overflow: TextOverflow.ellipsis,)),
                        const DataCell(Text('Lease (U-105)')),
                        const DataCell(Text('Paid')),
                        const DataCell(Text('15:56 15-05-2024', overflow: TextOverflow.ellipsis,)),
                        DataCell(Row(
                          children: [
                            // view btn
                            IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.remove_red_eye),
                              color: CupertinoColors.systemBlue,
                            ),

                            // update btn
                            IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.mode_edit_outline),
                              color: CupertinoColors.systemGreen,
                            ),

                            // delete btn
                            IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.delete),
                              color: Colors.redAccent,
                            ),
                          ],
                        )),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('2')),
                        const DataCell(Text('Uncaptured Tower', overflow: TextOverflow.ellipsis,)),
                        const DataCell(Text('Maintenance (Water pipe)')),
                        const DataCell(Text('Paid')),
                        const DataCell(Text('15:56 15-05-2024', overflow: TextOverflow.ellipsis,)),
                        DataCell(Row(
                          children: [
                            // view btn
                            IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.remove_red_eye),
                              color: CupertinoColors.systemBlue,
                            ),

                            // update btn
                            IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.mode_edit_outline),
                              color: CupertinoColors.systemGreen,
                            ),

                            // delete btn
                            IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.delete),
                              color: Colors.redAccent,
                            ),
                          ],
                        )),
                      ]),
                    ]
                ),
              ),
            ),



          ],
        ),
      ),
    );;
  }
}
