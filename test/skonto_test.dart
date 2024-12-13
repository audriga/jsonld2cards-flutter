import 'package:flutter_test/flutter_test.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/skonto.dart';
// import 'dart:developer' as developer;

void main() {
  test('Test Skonto segments', () {
    String threeSegment1 = '#SKONTO#TAGE=14#PROZENT=2.25#';
    String threeSegment2 = '#SKONTO#TAGE=28#PROZENT=1.00#';
    String fourSegment1 = '#SKONTO#TAGE=14#PROZENT=2.25#BASISBETRAG=357.93#';
    String fourSegment2 = '#SKONTO#TAGE=28#PROZENT=1.00#BASISBETRAG=357.93#';
    var ts1 = SkontoSegments.parseSkontoSegments(threeSegment1);
    expect(ts1, isNotNull);
    expect(ts1!.skontoDays, equals(14));
    expect(ts1.percentage, equals(2.25));
    expect(ts1.baseAmount, isNull);
    var ts2 = SkontoSegments.parseSkontoSegments(threeSegment2);
    expect(ts2, isNotNull);
    expect(ts2!.skontoDays, equals(28));
    expect(ts2.percentage, equals(1.00));
    expect(ts2.baseAmount, isNull);
    var fs1 = SkontoSegments.parseSkontoSegments(fourSegment1);
    expect(fs1, isNotNull);
    expect(fs1!.skontoDays, equals(14));
    expect(fs1.percentage, equals(2.25));
    expect(fs1.baseAmount, equals(357.93));
    var fs2 = SkontoSegments.parseSkontoSegments(fourSegment2);
    expect(fs2, isNotNull);
    expect(fs2!.skontoDays, equals(28));
    expect(fs2.percentage, equals(1.00));
    expect(fs2.baseAmount, equals(357.93));
  });
}
