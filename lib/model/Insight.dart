import 'package:json_annotation/json_annotation.dart';
import 'package:openfoodfacts/interface/JsonObject.dart';

part 'Insight.g.dart';

enum InsightAnnotation { YES, NO, MAYBE }

extension InsightAnnotationExtension on InsightAnnotation {
  int get value {
    switch (this) {
      case InsightAnnotation.YES:
        return 1;
      case InsightAnnotation.NO:
        return 0;
      case InsightAnnotation.MAYBE:
        return -1;
      default:
        return -1;
    }
  }
}

enum InsightType {
  INGREDIENT_SPELLCHECK,
  PACKAGER_CODE,
  LABEL,
  CATEGORY,
  PRODUCT_WEIGHT,
  EXPIRATION_DATE,
  BRAND,
  STORE,
  NUTRIENT,
  UNDEFINED
}

extension InsightTypesExtension on InsightType? {
  String? get value {
    switch (this) {
      case InsightType.INGREDIENT_SPELLCHECK:
        return 'ingredient_spellcheck';
      case InsightType.PACKAGER_CODE:
        return 'packager_code';
      case InsightType.LABEL:
        return 'label';
      case InsightType.CATEGORY:
        return 'category';
      case InsightType.PRODUCT_WEIGHT:
        return 'product_weight';
      case InsightType.EXPIRATION_DATE:
        return 'expiration_date';
      case InsightType.BRAND:
        return 'brand';
      case InsightType.STORE:
        return 'store';
      case InsightType.NUTRIENT:
        return 'nutrient';
      case InsightType.UNDEFINED:
        return 'undefined';
      default:
        return null;
    }
  }

  static InsightType getType(String? s) {
    switch (s) {
      case 'ingredient_spellcheck':
        return InsightType.INGREDIENT_SPELLCHECK;
      case 'packager_code':
        return InsightType.PACKAGER_CODE;
      case 'label':
        return InsightType.LABEL;
      case 'category':
        return InsightType.CATEGORY;
      case 'product_weight':
        return InsightType.PRODUCT_WEIGHT;
      case 'expiration_date':
        return InsightType.EXPIRATION_DATE;
      case 'brand':
        return InsightType.BRAND;
      case 'store':
        return InsightType.STORE;
      case 'nutrient':
        return InsightType.NUTRIENT;
      default:
        return InsightType.UNDEFINED;
    }
  }
}

@JsonSerializable()
class InsightsResult extends JsonObject {
  final String? status;
  @JsonKey(
      name: 'insights',
      includeIfNull: false,
      fromJson: Insight.fromJson,
      toJson: Insight.toJson)
  final List<Insight>? insights;

  const InsightsResult({this.status, this.insights});

  factory InsightsResult.fromJson(Map<String, dynamic> json) =>
      _$InsightsResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InsightsResultToJson(this);
}

class Insight {
  final String? id;
  final InsightType? type;
  final String? barcode;
  final List<dynamic>? countries;
  final String? lang;
  final String? model;
  final double? confidence;

  const Insight(
      {this.id,
      this.type,
      this.barcode,
      this.countries,
      this.lang,
      this.model,
      this.confidence});

  static List<Insight> fromJson(List<dynamic> json) {
    List<Insight> result = [];
    for (Map<String, dynamic> jsonInsight
        in json as Iterable<Map<String, dynamic>>) {
      InsightType insightType =
          InsightTypesExtension.getType(jsonInsight['type']);

      result.add(Insight(
          id: jsonInsight['id'],
          type: insightType,
          barcode: jsonInsight['barcode'],
          countries: jsonInsight['countries'],
          lang: jsonInsight['lang'],
          model: jsonInsight['model'],
          confidence: jsonInsight['confidence']));
    }
    return result;
  }

  static List<Map<String, dynamic>> toJson(List<Insight>? insights) {
    if (insights == null) {
      return [];
    }
    List<Map<String, dynamic>> result = [];
    for (Insight insight in insights) {
      Map<String, dynamic> jsonInsight = {};

      jsonInsight['id'] = insight.id;
      jsonInsight['type'] = insight.type.value;
      jsonInsight['barcode'] = insight.barcode;
      jsonInsight['countries'] = insight.countries;
      jsonInsight['lang'] = insight.lang;
      jsonInsight['model'] = insight.model;
      jsonInsight['confidence'] = insight.confidence;

      result.add(jsonInsight);
    }

    return result;
  }
}
