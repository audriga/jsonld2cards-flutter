library attachment_header;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AttachmentHeader extends StatelessWidget {
  const AttachmentHeader({super.key, required this.sourceFile, required this.otherAttachments});

  final Attachment? sourceFile;
  final List<Attachment>? otherAttachments;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var textStyle = theme.textTheme.bodySmall;
    // var textStyle = _expanded ? theme.textTheme.titleLarge : theme.textTheme.bodySmall;

    double fontSize = textStyle?.fontSize ?? 12;
    const insets = EdgeInsets.symmetric(horizontal: 4.0, vertical: 0);
    var headerRows = <Widget>[];
    if (sourceFile != null) {
      var isPDF = sourceFile!.filename?.endsWith('.pdf') ?? false;
      var isXML = sourceFile!.filename?.endsWith('.xml') ?? false;
      var icon = isPDF? Icons.picture_as_pdf : isXML? Icons.code: Icons.attachment;
      var explainer = Padding(padding: insets, child: Text('Diese Rechnung wurde aus einen Anhang extrahiert:', style: textStyle,),);
      var sourceRow = Row(
        children: [
          Padding(padding: insets, child: Icon(icon, size: fontSize + 2,),),
          Padding(padding: insets, child: TextButton(onPressed: () => openAttachment(sourceFile!), child: Text(sourceFile!.filename ?? 'Anhang', style: textStyle,),),)
        ],
      );
      headerRows.addAll([explainer, sourceRow]);
    }
    if (otherAttachments?.isNotEmpty ?? false) {
      var mainAttachmentExists = sourceFile != null;
      headerRows.add(Padding(padding: insets, child: Text(mainAttachmentExists ? 'Andere Anhänge:' : 'Anhänge', style: textStyle,),),);
      var otherAttachmentRows = otherAttachments!.map<Widget>((a) => Row(
        children: [
          Padding(padding: insets, child: Icon(Icons.attachment, size: fontSize + 2,),), //todo: Differentiate source (Mail vs pdf)
          Padding(padding: insets, child: TextButton(onPressed: () => openAttachment(a), child: Text(a.filename?? 'Anhang', style: textStyle,)),),
        ],
      ),);
      headerRows.addAll(otherAttachmentRows);
    }
    return Padding(padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: headerRows,
    ),);
  }

  static openAttachment(Attachment attachment) async {
    var data = attachment.data;
    if (data == null) {
      // todo? log or display error?
      return null;
    }
    var tempRoot = (await getTemporaryDirectory()).path;

    final tempSubfolderPath = "$tempRoot/${const Uuid().v4()}";
    await Directory(tempSubfolderPath).create(recursive: true);

    final path = "$tempSubfolderPath/${attachment.filename ?? 'attachment'}";

    //Write the file to FS
    await File(path).writeAsBytes(data);

    OpenFilex.open(
    path,
    type: attachment.mimeType,
    );
  }
}
