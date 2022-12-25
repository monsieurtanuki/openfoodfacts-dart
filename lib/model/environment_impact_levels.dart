import 'package:openfoodfacts/model/nutrient_levels.dart';

class EnvironmentImpactLevels {
  List<Level> levels;

  EnvironmentImpactLevels(this.levels);

  static EnvironmentImpactLevels? fromJson(List<dynamic>? json) {
    if (json == null) {
      return null;
    }
    List<Level> result = <Level>[];

    for (String s in json) {
      result.add(LevelExtension.getLevel(s.substring(3)));
    }

    return EnvironmentImpactLevels(result);
  }

  static List<String>? toJson(
      EnvironmentImpactLevels? environmentImpactLevels) {
    if (environmentImpactLevels == null) {
      return null;
    }

    List<String> result = [];

    for (Level level in environmentImpactLevels.levels) {
      result.add('en:${level.value}');
    }

    return result;
  }
}
