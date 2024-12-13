library xre_format_utils;

String? renderDate(dynamic inDate) {
  if (inDate is String) {
    var parsed = DateTime.tryParse(inDate);
    if (parsed != null) {
      return '${parsed.day}.${parsed.month}.${parsed.year}';
    }
    return inDate;
  } else {
    var parsed = DateTime.tryParse(inDate.toString());
    if (parsed != null) {
      return '${parsed.day}.${parsed.month}.${parsed.year}';
    }
    return null;
  }
}

String? renderNote(dynamic json) {
  String? noteText;
  if (json case Map<String, dynamic> map) {
    if (map['bg_1_invoice_note'] case List bg1InvoiceNote) {
      noteText = bg1InvoiceNote
          .whereType<Map<String, dynamic>>()
          .map(
            (e) => e['bt_22_content'],
          )
          .whereType<String>()
          .join('\n');
    }
  }
  return noteText;
}

String? priceInCurrency(String? price, String? currency) =>
    (currency != null && price != null)
        ? switch (currency) {
            'EUR' => '$price $currency',
            'USD' => '$currency $price',
            _ => '$price $currency',
          }
        : price;

String? priceInCurrencyFromJson(String price, Map<String, dynamic> json) {
  String? currencyCode;
  if (json['bt_6_vat_accounting_currency_code']
      case String bt6VatAccountingCurrencyCode) {
    currencyCode = bt6VatAccountingCurrencyCode;
  }
  if (json['bt_5_invoice_currency_code'] case String bt5InvoiceCurrencyCode) {
    currencyCode = bt5InvoiceCurrencyCode;
  }
  return priceInCurrency(price, currencyCode);
}
