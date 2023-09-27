import 'package:console/console.dart';
import 'package:test/test.dart';

void main() {
  test('factorial', () {
    expect(factorial(5), 120);
  });

  test('calcBinomial', () {
    expect(calcBinomial(2,2), 1);
  });
}
