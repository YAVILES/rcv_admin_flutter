import 'package:flutter/material.dart';

class DocumentUploadDownload extends StatefulWidget {
  final String title;
  final String? imageUrl;
  Function? onUpload;
  Function? onDownload;
  DocumentUploadDownload({
    Key? key,
    required this.title,
    this.imageUrl,
    this.onUpload,
    this.onDownload,
  }) : super(key: key);

  @override
  _DocumentUploadDownloadState createState() => _DocumentUploadDownloadState();
}

class _DocumentUploadDownloadState extends State<DocumentUploadDownload> {
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
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.warning,
                          color: Colors.red,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.check_circle,
                        ),
                      ),
                if (widget.onDownload != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      onPressed: () {
                        if (widget.onDownload != null) {
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
