import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(0xFA, 0xFF, 0xD8, 1),
          borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc['note_title'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            doc['creation_date'],
            style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 83, 83, 83)),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            doc['note_content'],
            style: const TextStyle(fontWeight: FontWeight.normal),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
