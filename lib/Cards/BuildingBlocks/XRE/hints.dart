library hints;

import 'package:flutter/material.dart';

enum HintType {
  info(Icons.info), warn(Icons.warning), err(Icons.error);

  const HintType(this.icon);
  final IconData icon;
}

enum HintProblemType {
  failedParseXml, // Had an xml file but did not successfully parse it into XRE.
  failedParsePdf, // Had a PDF file, that contained attachments, but was not XRE
  pdfContainsNoAttachments, // Had a PDF file, but contained no attachments
  nonXREAttachment, // Contains an attachment that is not XRE
  noStructuredData, // Message had attachments but was not XRE
  multipleStructuredData, // There are multiple XREs, but only first one is shown
}

class HintData {
  HintType type;
  String? message;
  // For type = err this should be an error. Otherwise dunno
  Object? error;
  HintProblemType? hintProblemType;

  HintData({required this.type, this.message, this.error, this.hintProblemType});
  HintData.fromError(this.error, {this.message, this.hintProblemType}) : type = HintType.err;
}

class HintsHeader extends StatelessWidget {
  const HintsHeader({super.key, required this.hints});

  final List<HintData> hints;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var textStyle = theme.textTheme.bodySmall;
    double fontSize = textStyle?.fontSize ?? 12;
    const insets = EdgeInsets.symmetric(horizontal: 4.0, vertical: 0);
    var headerRows = <Widget>[];
    if (hints.isNotEmpty) {
      var hintRows = hints.map<Widget>((h) => Row(
        children: [
          Padding(padding: insets, child: Icon(h.type.icon, size: fontSize + 2,),),
          Padding(padding: insets, child: Text(hintMessage(h, context)??'')),
        ],
      ),);
      headerRows.addAll(hintRows);
    }
    return Padding(padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: headerRows,
    ),);

  }

  String? hintMessage(HintData hint, BuildContext context) => switch(hint.hintProblemType) {
    null => hint.message,
    HintProblemType.failedParseXml => 'XML datei keien Gültige XRechung',
    HintProblemType.failedParsePdf => 'PDF enthält xml anhang, aber keine gültige XRechnung',
    HintProblemType.pdfContainsNoAttachments => 'PDF enthält keine Anhänge',
    HintProblemType.nonXREAttachment => 'Mail enthielt keine xml Anhänge',
    HintProblemType.noStructuredData => 'Mail enthielt keine Anhänge',
    HintProblemType.multipleStructuredData => 'Mail enthält mehre XRechnungen, nur eine davon wird angezeigt',
  };
}
