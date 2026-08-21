class QrParser {
  static String typeOf(String value) {
    final text = value.trim();
    final lower = text.toLowerCase();

    if (lower.startsWith('wifi:')) return 'Wi-Fi';
    if (lower.startsWith('mailto:')) return 'Email';
    if (lower.startsWith('tel:')) return 'Phone';
    if (lower.startsWith('sms:') || lower.startsWith('smsto:')) return 'SMS';
    if (lower.startsWith('geo:')) return 'Location';
    if (lower.startsWith('vcard:') || lower.startsWith('begin:vcard')) return 'Contact';
    if (Uri.tryParse(text)?.hasScheme == true &&
        (lower.startsWith('http://') || lower.startsWith('https://'))) {
      return 'URL';
    }
    return 'Text';
  }

  static bool isUrl(String value) {
    final lower = value.trim().toLowerCase();
    return lower.startsWith('https://') || lower.startsWith('http://');
  }
}
