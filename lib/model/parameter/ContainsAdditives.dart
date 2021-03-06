import 'package:openfoodfacts/interface/Parameter.dart';

/// "Contains additives?" search API parameter
class ContainsAdditives extends Parameter {
  @override
  String getName() => 'additives';

  @override
  String getValue() => filter ? 'without' : '';

  final bool filter;

  const ContainsAdditives({required this.filter});
}
