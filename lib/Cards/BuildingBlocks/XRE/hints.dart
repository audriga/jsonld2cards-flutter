library;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/l10n/app_localizations.dart';

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
  noStructuredData, // Message had no attachments or structured data
  multipleStructuredData, // There are multiple XREs, but only first one is shown
  bt3Not380, // Not a commercial invoice
  bt24Unknown, // BT 24 unknown or unsupported type
  ubl, // We know this is UBL and we still need to do some work with ubl
  sMimeInvalid, // Mail had SMime Header but was invalid
  noDKIM, // DKIM Missing
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
    AppLocalizations l = AppLocalizations.of(context);
    ThemeData theme = Theme.of(context);
    var textStyle = theme.textTheme.bodySmall;
    double fontSize = textStyle?.fontSize ?? 12;
    const insets = EdgeInsets.symmetric(horizontal: 4.0, vertical: 0);
    var headerRows = <Widget>[];
    if (hints.isNotEmpty) {
      var hintsToDisplay = <HintData>[];
      for (var hint in hints) {
        if (hintsToDisplay.where((dh) => dh.hintProblemType == hint.hintProblemType).firstOrNull case HintData displayHint) {
          var messages =  [displayHint.message, hint.message].nonNulls;
          if (messages.isNotEmpty) {
            displayHint.message = messages.join('\n');
          }
        } else {
          hintsToDisplay.add(hint);
        }
      }
      var hintRows = hintsToDisplay.map<Widget>((h) => Row(
        children: [
          Padding(padding: insets, child: Icon(h.type.icon, size: fontSize + 2,),),
          Expanded(
            child: Padding(padding: insets, child: TextButton(onPressed: () {

              showDialog(
                context: context,
                builder: (context) {
                  var message = h.message;
                  var errorString = h.error?.toString();
                  bool hasExtraInfo = (message?.isNotEmpty ?? false) || (errorString?.isNotEmpty ?? false);
                  return AlertDialog(
                  title: Text(hintMessage(h, context, l)??'', softWrap: true,),
                  content:  hasExtraInfo ? Text(
                      '${l.additionalInformation}\n${message ?? ''}\n${errorString ?? ''}',
                  softWrap: true,): null,
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, l.ok),
                        child:  Text(l.ok)),
                  ],
                );
                },
              );
            },
            child: Text(hintMessage(h, context, l)??'', overflow: TextOverflow.ellipsis))),
          ),
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

  String? hintMessage(HintData hint, BuildContext context, AppLocalizations l) => switch(hint.hintProblemType) {
    null => hint.message,
    HintProblemType.failedParseXml => l.theXMLFileNotValidXRechnung,
    HintProblemType.failedParsePdf => l.thePDFContainsAnXMLButNotValidXRechnung,
    HintProblemType.pdfContainsNoAttachments => l.thePDFContainsNoAttachments,
    HintProblemType.nonXREAttachment => l.theEmailContainsNonXRechnungAttachments,
    HintProblemType.noStructuredData => l.theEmailContainsNoXRechnung,
    HintProblemType.multipleStructuredData => l.theEmailContainsMultipleXRechnungOnlyOneDisplayed,
    HintProblemType.bt3Not380 => l.xRechnungTypeBT3Not380,
    HintProblemType.bt24Unknown => l.xRechnungSpecificationBT24UnknownUnsupported,
    HintProblemType.ubl => l.xRechnungInUBLFormatNotSupported,
    HintProblemType.sMimeInvalid => l.sMimeInvalid,
    HintProblemType.noDKIM => l.noDKIM,
  };
}
