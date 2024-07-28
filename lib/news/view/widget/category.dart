// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../utils/static.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  String? category;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: StaticData.category.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          if (index != 0) {
            category = StaticData.category[index];
          } else {
            category = null;
          }
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: StaticData.category[index] == category
                ? Colors.green[800]
                : null,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            StaticData.category[index].toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
