import 'package:flutter/material.dart';
import '../../models/goodtoknow.dart';

class DocumentDetails extends StatefulWidget {
  final GoodToKnow document;

  const DocumentDetails({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  _DocumentDetailsState createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
