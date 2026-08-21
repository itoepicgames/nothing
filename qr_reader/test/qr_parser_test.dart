import 'package:flutter_test/flutter_test.dart';
import 'package:scanova_qr/services/qr_parser.dart';

void main() {
  group('QrParser', () {
    test('detects URL', () {
      expect(QrParser.typeOf('https://example.com'), 'URL');
      expect(QrParser.isUrl('https://example.com'), isTrue);
    });
    test('detects common structured types', () {
      expect(QrParser.typeOf('WIFI:T:WPA;S:Office;P:secret;;'), 'Wi-Fi');
      expect(QrParser.typeOf('mailto:hello@example.com'), 'Email');
      expect(QrParser.typeOf('tel:+966500000000'), 'Phone');
      expect(QrParser.typeOf('sms:+966500000000'), 'SMS');
      expect(QrParser.typeOf('geo:24.7,46.7'), 'Location');
      expect(QrParser.typeOf('BEGIN:VCARD\nFN:Test\nEND:VCARD'), 'Contact');
      expect(QrParser.typeOf('Hello QR'), 'Text');
    });
  });
}
