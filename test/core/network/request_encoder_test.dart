import 'package:flutter_test/flutter_test.dart';
import 'package:web_learner/core/network/request_encoder.dart';

void main() {
  group('AppRequestEncoder', () {
    test('encodes Esdt payload like the documented frontend algorithm', () {
      const encoder = AppRequestEncoder();

      expect(encoder.esdt('A1'), '6549%5E2%2C2');
    });

    test('supports plain and url encoded modes', () {
      const encoder = AppRequestEncoder();

      expect(
        encoder.encode('abc', type: RequestEncoding.plain),
        'abc',
      );
      expect(
        encoder.encode('a b', type: RequestEncoding.urlEncoded),
        'a+b',
      );
    });
  });
}
