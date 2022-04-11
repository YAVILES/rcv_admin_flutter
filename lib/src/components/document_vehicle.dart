import 'package:flutter/material.dart';

class DocumentVehicle extends StatefulWidget {
  final String title;
  final String? imageUrl;
  Function? onUpload;
  Function? onDownload;
  DocumentVehicle({
    Key? key,
    required this.title,
    this.imageUrl,
    this.onUpload,
    this.onDownload,
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
        width: 220,
        child: Column(
          children: [
            Center(child: Text(widget.title)),
            // if (widget.imageUrl != null) Image.network(widget.imageUrl!),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    onPressed: () =>
                        widget.onUpload != null ? widget.onUpload!() : {},
                    icon: const Icon(Icons.upload_file_outlined),
                  ),
                ),
                (widget.imageUrl == null)
                    ? const Icon(
                        Icons.warning,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.check_circle,
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    onPressed: () {
                      if (widget.imageUrl != null &&
                          widget.onDownload != null) {
                        widget.onDownload!();
                      }
                    },
                    icon: const Icon(Icons.download_for_offline_outlined),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
