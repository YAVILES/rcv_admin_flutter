import 'package:flutter/material.dart';

class DocumentVehicle extends StatefulWidget {
  final String title;
  const DocumentVehicle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _DocumentVehicleState createState() => _DocumentVehicleState();
}

class _DocumentVehicleState extends State<DocumentVehicle> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: 180,
        child: Column(
          children: [
            Center(child: Text(widget.title)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file_outlined),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.download_for_offline_outlined),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
