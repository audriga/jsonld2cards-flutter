library epc_qr;

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jsonld2cards/sml_app_context.dart';
import 'package:qr_flutter/qr_flutter.dart';

enum EpcQrIdentification {
  sct('SCT'),
  inst('INST');

  const EpcQrIdentification(this.name);

  final String name;
}

enum EpcQrPurpose {
  bene('BENE'), // = Arbeitslosengeld
  dept('DEPT'), // = Einzahlung
  gdds('GDDS'), // = Einkauf/Verkauf von Ware
  mtup('MTUP'), // = Handy aufladen
  pens('PENS'), // = Renten
  sala('SALA'), // = Gehalt
  trad('TRAD'); // = Handelsgeschäft

  //todo there are more. Does it even make sense to use an actual enum?
  // see https://wiki.windata.de/index.php?title=Purpose-SEPA-Codes
  const EpcQrPurpose(this.name);

  final String name;
}

class EpcQr extends StatelessWidget {
  const EpcQr(
      {super.key,
      required this.version,
      required this.identification,
      this.bic,
      required this.name,
      required this.iban,
      this.amount,
      this.purpose,
      this.remittanceReference,
      this.remittanceText,
      this.information});

  static const serviceTag = 'BCD'; // line1
  // line2
  // 001 = EWR mit Nicht-EWR-Ländern
  // 002 = nur EWR
  // XRE: BT-81 == 58/30
  final String version;

  // line3
  // 1 = UTF-8
  static const characterSet = 1;

  // line4
  // SCT = SEPA Credit Transfer
  // INST = SEPA Instant Credit Transfer
  final EpcQrIdentification identification;

  // line5
  // (BT-86)
  // Optional if [version] is 001
  // CHECK
  final String? bic;

  //line6
  // Zahlungsempfänger 	String 	70 chars
  // Vera Verkäuferin
  // BT-85 (if empty BT-59 or BT-28/27
  // CHECK
  final String name;

  // line7
  // example DE12345678901234567890
  // BT-84
  final String iban;

  // line8
  // 	Zahlung
  // Optional
  // 'EUR#.##
  // Example EUR123.45
  // BT-115; ggf. Skonto
  //
  // For the implementation I could also make this a double and create  the string here
  final String? amount;

  // 9
  // optional
  //CHECK
  final EpcQrPurpose? purpose;

  // line10
  // (Reference)
  // Verwendungszweck (Id)
  // ISO 11649 RF Creditor Reference
  // 25 chars
  // Optional (and don’t set if 11 set)
  // Example RF18 5390 0754 7034
  // (CHECK)
  final String? remittanceReference;

  // line11
  // Verwendungszweck (Freitext)
  // String 	140 chars 	yes (and don’t set if 10 set) 	Spende fuer Wikipedia 	BT-83
  final String? remittanceText;

  // line12
  // “Informationen zwischen Zahlungsempfänger und Urheber der Zahlung”
  // String 	70 chars
  // Optional
  // (CHECK)
  // No empty line if empty
  final String? information;

  @override
  Widget build(BuildContext context) {
    var dataBuffer = StringBuffer();
    dataBuffer.writeAll(<String>[
      serviceTag,
      version,
      characterSet.toString(),
      identification.name,
      bic ?? '',
      name,
      iban,
      amount ?? '',
      purpose?.name ?? '',
      remittanceReference ?? '',
      remittanceText ?? '', //todo only one reference allowed
    ], '\n');
    if (information?.isNotEmpty ?? false) {
      dataBuffer.write('\n$information');
    }
    var data = dataBuffer.toString();
    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        child: QrImageView(
          data: data,
          version: QrVersions.auto,
          size: 200.0,
          backgroundColor: Colors.white,
        ),
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            children: [
              SizedBox(
                height: min(constraints.maxHeight, constraints.maxWidth) * .8,
                width: min(constraints.maxHeight, constraints.maxWidth) * .8,
                child: Center(
                  child: QrImageView(
                    data: data,
                    version: QrVersions.auto,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              SimpleDialogOption(
                child: const Text('Speichern'),
                onPressed: () async {
                  // QrCode qrImageData = QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.L);
                  // QrImage(qrImageData);
                  Uint8List? qrBytes =
                      (await QrPainter(data: data, version: QrVersions.auto)
                              .toImageData(2048))
                          ?.buffer
                          .asUint8List();
                  var fileName = 'epcQR_${name.replaceAll(' ', '-')}_$iban.png';
                  if (globalSMLAppContext?.saveFileCallback != null) {
                    globalSMLAppContext!.saveFileCallback!(
                        qrBytes, 'image/png', fileName);
                  }
                },
              ),
              SimpleDialogOption(
                child: const Text('Teilen'),
                onPressed: () async {
                  Uint8List? qrBytes =
                      (await QrPainter(data: data, version: QrVersions.auto)
                              .toImageData(2048))
                          ?.buffer
                          .asUint8List();
                  var fileName = 'epcQR_${name.replaceAll(' ', '-')}_$iban.png';
                  if (globalSMLAppContext?.shareFileCallback != null) {
                    globalSMLAppContext!.shareFileCallback!(
                        qrBytes, 'image/png', fileName);
                  }
                },
              ),
              SimpleDialogOption(
                child: const Text('Schließen'),
                onPressed: ()  => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CreditTransferInfo {
  String iban;
  String? name;
  String? bic;

  CreditTransferInfo({required this.iban, this.name, this.bic});
}
