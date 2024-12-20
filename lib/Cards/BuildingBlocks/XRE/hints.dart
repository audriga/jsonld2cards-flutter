library hints;

enum HintType {
  info, warn, err;
}

enum HintProblemType {
  failedParseXml, // Had an xml file but did not successfully parse it into XRE.
  failedParsePdf, // Had a PDF file, that contained attachments, but was not XRE
  pdfContainsNoAttachments, // Had a PDF file, but contained no attachments
  nonXREAttachment, // Contains an attachment that is not XRE
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