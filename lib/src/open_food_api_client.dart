import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'interface/json_object.dart';
import 'model/product_packaging.dart';
import 'model/product_result_v3.dart';
import 'model/login_status.dart';
import 'model/ocr_ingredients_result.dart';
import 'model/ocr_packaging_result.dart';
import 'model/ordered_nutrients.dart';
import 'model/product_freshness.dart';
import 'model/product_image.dart';
import 'model/sign_up_status.dart';
import 'model/taxonomy_additive.dart';
import 'model/taxonomy_allergen.dart';
import 'model/taxonomy_category.dart';
import 'model/taxonomy_country.dart';
import 'model/taxonomy_ingredient.dart';
import 'model/taxonomy_label.dart';
import 'model/taxonomy_language.dart';
import 'model/taxonomy_nova.dart';
import 'model/taxonomy_origin.dart';
import 'model/taxonomy_packaging.dart';
import 'model/taxonomy_packaging_material.dart';
import 'model/taxonomy_packaging_recycling.dart';
import 'model/taxonomy_packaging_shape.dart';
import 'model/parameter/barcode_parameter.dart';
import 'model/insight.dart';
import 'model/product.dart';
import 'model/product_result.dart';
import 'model/robotoff_question.dart';
import 'model/search_result.dart';
import 'model/send_image.dart';
import 'model/spelling_corrections.dart';
import 'model/status.dart';
import 'model/user.dart';
import 'utils/abstract_query_configuration.dart';
import 'utils/country_helper.dart';
import 'utils/image_helper.dart';
import 'utils/ocr_field.dart';
import 'utils/product_fields.dart';
import 'utils/product_search_query_configuration.dart';
import 'utils/query_type.dart';
import 'utils/tag_type.dart';
import 'utils/taxonomy_query_configuration.dart';
import 'utils/uri_helper.dart';
import 'utils/http_helper.dart';
import 'utils/language_helper.dart';
import 'utils/product_helper.dart';
import 'utils/product_query_configurations.dart';

/// Client calls of the Open Food Facts API
class OpenFoodAPIClient {
  OpenFoodAPIClient._();

  /// Add the given product to the database.
  /// Returns a Status object as result.
  ///
  /// Please read the language mechanics explanation if you intend to display
  /// or update data in specific language: https://github.com/openfoodfacts/openfoodfacts-dart/blob/master/DOCUMENTATION.md#about-languages-mechanics
  static Future<Status> saveProduct(
    final User user,
    final Product product, {
    final QueryType? queryType,
    final OpenFoodFactsCountry? country,
    final OpenFoodFactsLanguage? language,
  }) async {
    final Map<String, String> parameterMap = <String, String>{};
    parameterMap.addAll(user.toData());
    parameterMap.addAll(product.toServerData());
    if (language != null) {
      parameterMap['lc'] = language.offTag;
    }
    if (country != null) {
      parameterMap['cc'] = country.offTag;
    }

    var productUri = UriHelper.getPostUri(
      path: '/cgi/product_jqm2.pl',
      queryType: queryType,
    );

    if (product.nutriments != null) {
      final Map<String, String> rawNutrients = product.nutriments!.toData();
      for (final MapEntry<String, String> entry in rawNutrients.entries) {
        String key = 'nutriment_${entry.key}';
        final int pos = key.indexOf('_100g');
        if (pos != -1) {
          key = key.substring(0, pos);
        }
        parameterMap[key] = entry.value;
      }
    }
    parameterMap.remove('nutriments');
    final Response response = await HttpHelper().doPostRequest(
      productUri,
      parameterMap,
      user,
      queryType: queryType,
      addCredentialsToBody: true,
    );
    return Status.fromApiResponse(response.body);
  }

  /// Temporary: saves product packagings V3 style.
  ///
  /// For the moment that's the only field supported in WRITE by API V3.
  /// Long term target is of course more something like [saveProduct].
  static Future<ProductResultV3> temporarySaveProductV3(
    final User user,
    final String barcode, {
    final List<ProductPackaging>? packagings,
    final QueryType? queryType,
    final OpenFoodFactsCountry? country,
    final OpenFoodFactsLanguage? language,
  }) async {
    final Map<String, dynamic> parameterMap = <String, dynamic>{};
    parameterMap.addAll(user.toData());
    if (packagings == null) {
      // For the moment it's the only purpose of this method: saving packagings.
      throw Exception('packagings cannot be null');
    }
    parameterMap['product'] = {};
    parameterMap['product']['packagings'] = packagings;
    if (language != null) {
      parameterMap['lc'] = language.offTag;
      parameterMap['tags_lc'] = language.offTag;
    }
    if (country != null) {
      parameterMap['cc'] = country.offTag;
    }

    var productUri = UriHelper.getPatchUri(
      path: '/api/v3/product/$barcode',
      queryType: queryType,
    );

    final Response response = await HttpHelper().doPatchRequest(
      productUri,
      parameterMap,
      user,
      queryType: queryType,
    );
    return ProductResultV3.fromJson(jsonDecode(response.body));
  }

  /// Send one image to the server.
  /// The image will be added to the product specified in the SendImage
  /// Returns a Status object as result.
  static Future<Status> addProductImage(
    User user,
    SendImage image, {
    QueryType? queryType,
  }) async {
    var dataMap = <String, String>{};
    var fileMap = <String, Uri>{};

    dataMap.addAll(image.toData());
    fileMap.putIfAbsent(image.getImageDataKey(), () => image.imageUri);

    var imageUri = UriHelper.getUri(
      path: '/cgi/product_image_upload.pl',
      queryType: queryType,
      addUserAgentParameters: false,
    );

    return await HttpHelper().doMultipartRequest(
      imageUri,
      dataMap,
      files: fileMap,
      user: user,
      queryType: queryType,
    );
  }

  /// Returns the product for the given barcode.
  /// The ProductResult does not contain a product, if the product is not available.
  /// No parsing of ingredients.
  /// No adjustment by language.
  /// No replacing of '&quot;' with '"'.
// TODO: deprecated from 2022-12-01; remove when old enough
  @Deprecated('Use getProductV3 instead')
  static Future<ProductResult> getProductRaw(
    String barcode,
    OpenFoodFactsLanguage language, {
    User? user,
    QueryType? queryType,
  }) async {
    final String productString = await getProductString(
      ProductQueryConfiguration(
        barcode,
        language: language,
        country: null,
        fields: null,
      ),
      user: user,
      queryType: queryType,
    );
    return ProductResult.fromJson(json.decode(productString));
  }

  /// Returns the product for the given barcode.
  /// The ProductResult does not contain a product, if the product is not available.
  /// ingredients, images and product name will be prepared for the given language.
  ///
  /// Please read the language mechanics explanation if you intend to show
  /// or update data in specific language: https://github.com/openfoodfacts/openfoodfacts-dart/blob/master/DOCUMENTATION.md#about-languages-mechanics
// TODO: deprecated from 2022-12-01; remove when old enough
  @Deprecated('Use getProductV3 instead')
  static Future<ProductResult> getProduct(
    ProductQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) async {
    if (configuration.matchesV3()) {
      Exception("The configuration must not match V3!");
    }
    final String productString = await getProductString(
      configuration,
      user: user,
      queryType: queryType,
    );
    final String jsonStr = _replaceQuotes(productString);
    final ProductResult result = ProductResult.fromJson(jsonDecode(jsonStr));
    if (result.product != null) {
      ProductHelper.removeImages(result.product!, configuration.language);
      ProductHelper.createImageUrls(result.product!, queryType: queryType);
    }
    return result;
  }

  /// Returns the product for the given barcode.
  /// The ProductResult does not contain a product, if the product is not available.
  /// ingredients, images and product name will be prepared for the given language.
  ///
  /// Please read the language mechanics explanation if you intend to show
  /// or update data in specific language: https://github.com/openfoodfacts/openfoodfacts-dart/blob/master/DOCUMENTATION.md#about-languages-mechanics
  static Future<ProductResultV3> getProductV3(
    ProductQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) async {
    if (!configuration.matchesV3()) {
      Exception("The configuration must match V3!");
    }
    final String productString = await getProductString(
      configuration,
      user: user,
      queryType: queryType,
    );
    final String jsonStr = _replaceQuotes(productString);
    final ProductResultV3 result =
        ProductResultV3.fromJson(jsonDecode(jsonStr));
    if (result.product != null) {
      ProductHelper.removeImages(result.product!, configuration.language);
      ProductHelper.createImageUrls(result.product!, queryType: queryType);
    }
    return result;
  }

  /// Returns the response body of "get product" API for the given barcode.
  static Future<String> getProductString(
    final ProductQueryConfiguration configuration, {
    final User? user,
    final QueryType? queryType,
  }) async {
    final Response response = await configuration.getResponse(user, queryType);
    return response.body;
  }

  static String _replaceQuotes(String str) {
    return str.replaceAll('&quot;', '\\"');
  }

  /// Returns the URI to the product page on a website
  ///
  /// If the target website supports different domains for country + language,
  /// [replaceSubdomain] should be set to true.
  static Uri getProductUri(
    final String barcode, {
    final OpenFoodFactsLanguage? language,
    final OpenFoodFactsCountry? country,
    final QueryType? queryType,
    required final bool replaceSubdomain,
  }) {
    final Uri uri = UriHelper.getUri(
      path: 'product/$barcode',
      queryType: queryType,
      addUserAgentParameters: false,
    );
    if (!replaceSubdomain) {
      return uri;
    }
    return UriHelper.replaceSubdomain(
      uri,
      language: language,
      country: country,
    );
  }

  /// Returns the URI to the translation page for a taxonomy.
  ///
  /// Not supported for EMB_CODES.
  /// If the target website supports different subdomains for language,
  /// [replaceSubdomain] should be set to true.
  static Uri getTaxonomyTranslationUri(
    final TagType taxonomyTagType, {
    required final OpenFoodFactsLanguage language,
    final QueryType? queryType,
    final bool replaceSubdomain = true,
  }) {
    if (taxonomyTagType == TagType.EMB_CODES) {
      throw Exception('No taxonomy translation for $taxonomyTagType');
    }
    final Uri uri = UriHelper.getUri(
      path: taxonomyTagType.offTag,
      queryType: queryType,
      queryParameters: {'translate': '1'},
      addUserAgentParameters: false,
    );
    if (!replaceSubdomain) {
      return uri;
    }
    return UriHelper.replaceSubdomainWithCodes(
      uri,
      languageCode: language.offTag,
    );
  }

  /// Returns the URI to the crowdin page for a [language].
  static Uri getCrowdinUri(final OpenFoodFactsLanguage language) =>
      Uri.parse('https://crowdin.com/project/openfoodfacts/${language.offTag}');

  /// Search the OpenFoodFacts product database with the given parameters.
  /// Returns the list of products as SearchResult.
  /// Query the language specific host from OpenFoodFacts.
  static Future<SearchResult> searchProducts(
    final User? user,
    final AbstractQueryConfiguration configuration, {
    final QueryType? queryType,
  }) async {
    final Response response = await configuration.getResponse(user, queryType);
    final String jsonStr = _replaceQuotes(response.body);
    final SearchResult result = SearchResult.fromJson(json.decode(jsonStr));
    _removeImages(result, configuration);
    return result;
  }

  /// Returns the [ProductFreshness] for all the [barcodes].
  static Future<Map<String, ProductFreshness>> getProductFreshness({
    required final List<String> barcodes,
    final User? user,
    final OpenFoodFactsLanguage? language,
    final OpenFoodFactsCountry? country,
    final QueryType? queryType,
  }) async {
    final SearchResult searchResult = await searchProducts(
      user,
      ProductSearchQueryConfiguration(
        parametersList: [BarcodeParameter.list(barcodes)],
        language: language,
        country: country,
        fields: [
          ProductField.BARCODE,
          ProductField.ECOSCORE_SCORE,
          ProductField.NUTRISCORE,
          ProductField.INGREDIENTS_TAGS,
          ProductField.LAST_MODIFIED,
          ProductField.STATES_TAGS,
        ],
      ),
      queryType: queryType,
    );
    final Map<String, ProductFreshness> result = <String, ProductFreshness>{};
    if (searchResult.products == null) {
      return result;
    }
    for (final Product product in searchResult.products!) {
      result[product.barcode!] = ProductFreshness.fromProduct(product);
    }
    return result;
  }

  static Future<Map<String, T>?>
      getTaxonomy<T extends JsonObject, F extends Enum>(
    TaxonomyQueryConfiguration<T, F> configuration, {
    User? user,
    QueryType? queryType,
  }) async {
    final Uri uri = configuration.getPostUri(queryType);
    final Response response = await HttpHelper().doPostRequest(
      uri,
      configuration.getParametersMap(),
      user,
      queryType: queryType,
      addCredentialsToBody: false,
    );

    Map<String, dynamic> decodedJson =
        json.decode(_replaceQuotes(response.body))
          ..removeWhere((String key, dynamic value) {
            if (value is Map) {
              return value.isEmpty;
            }
            if (value is List) {
              return value.isEmpty;
            }
            return false;
          });
    if (decodedJson.isEmpty) {
      // We requested something that doesn't have any results.
      return null;
    }
    return configuration.convertResults(decodedJson);
  }

  static Future<Map<String, TaxonomyPackagingShape>?>
      getTaxonomyPackagingShapes(
    TaxonomyPackagingShapeQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
          getTaxonomy<TaxonomyPackagingShape, TaxonomyPackagingShapeField>(
            configuration,
            user: user,
            queryType: queryType,
          );

  static Future<
      Map<String, TaxonomyPackagingMaterial>?> getTaxonomyPackagingMaterials(
    TaxonomyPackagingMaterialQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyPackagingMaterial, TaxonomyPackagingMaterialField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<
      Map<String, TaxonomyPackagingRecycling>?> getTaxonomyPackagingRecycling(
    TaxonomyPackagingRecyclingQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyPackagingRecycling, TaxonomyPackagingRecyclingField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyNova>?> getTaxonomyNova(
    TaxonomyNovaQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyNova, TaxonomyNovaField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyCategory>?> getTaxonomyCategories(
    TaxonomyCategoryQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyCategory, TaxonomyCategoryField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyAdditive>?> getTaxonomyAdditives(
    TaxonomyAdditiveQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyAdditive, TaxonomyAdditiveField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyAllergen>?> getTaxonomyAllergens(
    TaxonomyAllergenQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyAllergen, TaxonomyAllergenField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyCountry>?> getTaxonomyCountries(
    TaxonomyCountryQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyCountry, TaxonomyCountryField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyIngredient>?> getTaxonomyIngredients(
    TaxonomyIngredientQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyIngredient, TaxonomyIngredientField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyLabel>?> getTaxonomyLabels(
    TaxonomyLabelQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyLabel, TaxonomyLabelField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyLanguage>?> getTaxonomyLanguages(
    TaxonomyLanguageQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyLanguage, TaxonomyLanguageField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyPackaging>?> getTaxonomyPackagings(
    final TaxonomyPackagingQueryConfiguration configuration, {
    final User? user,
    final QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyPackaging, TaxonomyPackagingField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static Future<Map<String, TaxonomyOrigin>?> getTaxonomyOrigins(
    TaxonomyOriginQueryConfiguration configuration, {
    User? user,
    QueryType? queryType,
  }) =>
      getTaxonomy<TaxonomyOrigin, TaxonomyOriginField>(
        configuration,
        user: user,
        queryType: queryType,
      );

  static void _removeImages(
    final SearchResult searchResult,
    final AbstractQueryConfiguration configuration,
  ) {
    if (searchResult.products != null) {
      searchResult.products!.asMap().forEach((index, product) {
        ProductHelper.removeImages(product, configuration.language);
      });
    }
  }

  static Future<InsightsResult> getRandomInsight(
    User user, {
    InsightType? type,
    String? country,
    String? valueTag,
    String? serverDomain,
    QueryType? queryType,
  }) async {
    final Map<String, String> parameters = {};

    if (type != null && type.value != null) {
      parameters['type'] = type.value!;
    }
    if (country != null) {
      parameters['country'] = country;
    }
    if (valueTag != null) {
      parameters['value_tag'] = valueTag;
    }
    if (serverDomain != null) {
      parameters['server_domain'] = serverDomain;
    }

    var insightUri = UriHelper.getRobotoffUri(
      path: 'api/v1/insights/random/',
      queryType: queryType,
      queryParameters: parameters,
    );

    Response response = await HttpHelper().doGetRequest(
      insightUri,
      user: user,
      queryType: queryType,
    );
    var result =
        InsightsResult.fromJson(json.decode(utf8.decode(response.bodyBytes)));

    return result;
  }

  static Future<InsightsResult> getProductInsights(
    String barcode,
    User user, {
    QueryType? queryType,
  }) async {
    var insightsUri = UriHelper.getRobotoffUri(
      path: 'api/v1/insights/$barcode',
      queryType: queryType,
    );

    Response response = await HttpHelper().doGetRequest(
      insightsUri,
      user: user,
      queryType: queryType,
    );

    return InsightsResult.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));
  }

  static Future<RobotoffQuestionResult> getRobotoffQuestionsForProduct(
    String barcode,
    String lang, {
    User? user,
    int? count,
    QueryType? queryType,
  }) async {
    if (count == null || count <= 0) {
      count = 1;
    }

    final Map<String, String> parameters = <String, String>{
      'lang': lang,
      'count': count.toString()
    };

    var robotoffQuestionUri = UriHelper.getRobotoffUri(
      path: 'api/v1/questions/$barcode',
      queryParameters: parameters,
      queryType: queryType,
    );

    Response response = await HttpHelper().doGetRequest(
      robotoffQuestionUri,
      user: user,
      queryType: queryType,
    );
    var result = RobotoffQuestionResult.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));

    return result;
  }

  static Future<RobotoffQuestionResult> getRandomRobotoffQuestion(
    String lang,
    User user, {
    int? count,
    List<InsightType>? types,
    QueryType? queryType,
  }) async {
    if (count == null || count <= 0) {
      count = 1;
    }

    final List<String> typesValues = [];
    if (types != null) {
      for (final InsightType t in types) {
        final String? value = t.value;
        if (value != null) {
          typesValues.add(value);
        }
      }
    }

    final Map<String, String> parameters = <String, String>{
      'lang': lang,
      'count': count.toString(),
      if (typesValues.isNotEmpty) 'insight_types': typesValues.join(',')
    };

    var robotoffQuestionUri = UriHelper.getRobotoffUri(
      path: 'api/v1/questions/random',
      queryParameters: parameters,
      queryType: queryType,
    );

    Response response = await HttpHelper().doGetRequest(
      robotoffQuestionUri,
      user: user,
      queryType: queryType,
    );
    var result = RobotoffQuestionResult.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));

    return result;
  }

  static Future<Status> postInsightAnnotation(
    String? insightId,
    InsightAnnotation annotation, {
    User? user,
    String? deviceId,
    bool update = true,
    final QueryType? queryType,
  }) async {
    var insightUri = UriHelper.getRobotoffUri(
      path: 'api/v1/insights/annotate',
      queryType: queryType,
    );

    final Map<String, String> annotationData = {
      'annotation': annotation.value.toString(),
      'update': update ? '1' : '0'
    };
    if (insightId != null) {
      annotationData['insight_id'] = insightId;
    }

    if (deviceId != null) {
      annotationData['device_id'] = deviceId;
    }

    Response response = await HttpHelper().doPostRequest(
      insightUri,
      annotationData,
      user,
      queryType: queryType,
      addCredentialsToBody: false,
      addCredentialsToHeader: true,
    );
    return Status.fromApiResponse(response.body);
  }

  // TODO: deprecated from 2022-11-22; remove when old enough
  @Deprecated('Unstable version, do not use and wait for the next version')
  static Future<SpellingCorrection?> getIngredientSpellingCorrection({
    String? ingredientName,
    Product? product,
    User? user,
    QueryType? queryType,
  }) async {
    Map<String, String> spellingCorrectionParam;

    if (ingredientName != null) {
      spellingCorrectionParam = {
        'text': ingredientName,
      };
    } else if (product != null && product.barcode != null) {
      spellingCorrectionParam = {
        'barcode': product.barcode!,
      };
    } else {
      return null;
    }

    var spellingCorrectionUri = UriHelper.getRobotoffUri(
      path: 'api/v1/predict/ingredients/spellcheck',
      queryType: queryType,
    );

    Response response = await HttpHelper().doPostRequest(
      spellingCorrectionUri,
      spellingCorrectionParam,
      user,
      queryType: queryType,
      addCredentialsToBody: false,
      addCredentialsToHeader: true,
    );
    SpellingCorrection result = SpellingCorrection.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));

    return result;
  }

  /// Extract the ingredients from image with the given parameters.
  /// The ingredients language should be given (ingredients_fr, ingredients_de, ingredients_en)
  /// Returns the ingredients using OCR.
  /// By default the query will use the Google Cloud Vision.
  static Future<OcrIngredientsResult> extractIngredients(
    User user,
    String barcode,
    OpenFoodFactsLanguage language, {
    OcrField ocrField = OcrField.GOOGLE_CLOUD_VISION,
    QueryType? queryType,
  }) async {
    final Uri uri = UriHelper.getPostUri(
      path: '/cgi/ingredients.pl',
      queryType: queryType,
    );
    final Map<String, String> queryParameters = <String, String>{
      'code': barcode,
      'process_image': '1',
      'id': 'ingredients_${language.offTag}',
      'ocr_engine': ocrField.offTag
    };
    final Response response = await HttpHelper().doPostRequest(
      uri,
      queryParameters,
      user,
      queryType: queryType,
      addCredentialsToBody: false,
    );
    return OcrIngredientsResult.fromJson(
      json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  /// Extracts the text from packaging image with OCR.
  static Future<OcrPackagingResult> extractPackaging(
    final User user,
    final String barcode,
    final OpenFoodFactsLanguage language, {
    final OcrField ocrField = OcrField.GOOGLE_CLOUD_VISION,
    final QueryType? queryType,
  }) async {
    final Uri uri = UriHelper.getPostUri(
      path: '/cgi/packaging.pl',
      queryType: queryType,
    );
    final Map<String, String> queryParameters = <String, String>{
      'code': barcode,
      'process_image': '1',
      'id': 'packaging_${language.offTag}',
      'ocr_engine': ocrField.offTag
    };
    final Response response = await HttpHelper().doPostRequest(
      uri,
      queryParameters,
      user,
      queryType: queryType,
      addCredentialsToBody: false,
    );
    return OcrPackagingResult.fromJson(
      json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  /// Returns suggestions.
  ///
  /// The [limit] has a max value of 400 on the server side.
  static Future<List<dynamic>> getAutocompletedSuggestions(
    final TagType taxonomyType, {
    final String input = '',
    final OpenFoodFactsLanguage language = OpenFoodFactsLanguage.ENGLISH,
    final QueryType? queryType,
    final int limit = 25,
  }) async {
    final Uri uri = UriHelper.getPostUri(
      path: '/cgi/suggest.pl',
      queryType: queryType,
    );
    final Map<String, String> queryParameters = <String, String>{
      'tagtype': taxonomyType.offTag,
      'term': input,
      'lc': language.offTag,
      'limit': limit.toString(),
    };
    final Response response = await HttpHelper().doPostRequest(
      uri,
      queryParameters,
      null,
      queryType: queryType,
      addCredentialsToBody: false,
    );
    return json.decode(response.body);
  }

  /// Uses the auth.pl API to see if login was successful
  /// Returns a bool if the login data of the provided user is correct
  // TODO: deprecated from 2022-10-12; remove when old enough
  @Deprecated('Use login2 instead')
  static Future<bool> login(
    User user, {
    QueryType? queryType,
  }) async =>
      (await login2(user, queryType: queryType))?.successful ?? false;

  /// Logs in and returns data about the user if relevant.
  ///
  /// Returns null if connection issue.
  static Future<LoginStatus?> login2(
    final User user, {
    final QueryType? queryType,
  }) async {
    final Uri uri = UriHelper.getPostUri(
      path: '/cgi/auth.pl',
      queryType: queryType,
    );
    final Response response = await HttpHelper().doPostRequest(
      uri,
      <String, String>{'body': '1'},
      user,
      queryType: queryType,
      addCredentialsToBody: true,
    );
    if (response.statusCode == 200 || response.statusCode == 403) {
      return LoginStatus.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  /// A username may not exceed 20 characters
  static const USER_NAME_MAX_LENGTH = 20;

  /// Creates a new user
  /// Returns [Status.status] 201 = complete; 400 = wrong inputs + [Status.error]; 500 = server error;
  ///
  /// When creating a [producer account](https://world.pro.openfoodfacts.org/) use [orgName] (former requested_org) to name the Producer or brand
  static Future<SignUpStatus> register({
    required User user,
    required String name,
    required String email,
    String? orgName,
    bool newsletter = true,
    QueryType? queryType,
  }) async {
    if (name.length > USER_NAME_MAX_LENGTH) {
      throw ArgumentError(
        'A username may not exceed $USER_NAME_MAX_LENGTH characters!',
      );
    }

    var registerUri = UriHelper.getUri(
      path: '/cgi/user.pl',
      queryType: queryType,
      addUserAgentParameters: false,
    );

    Map<String, String> data = <String, String>{
      'name': name,
      'email': email,
      'userid': user.userId,
      'password': user.password,
      'confirm_password': user.password,
      if (orgName != null) 'pro': 'on',
      'pro_checkbox': '1',
      'requested_org': orgName ?? ' ',
      if (newsletter) 'newsletter': 'on',
      'action': 'process',
      'type': 'add',
      '.submit': 'Register',
    };

    Status status = await HttpHelper().doMultipartRequest(
      registerUri,
      data,
      queryType: queryType,
    );

    return SignUpStatus(status);
  }

  /// Uses reset_password.pl to send a password reset Email
  /// needs only
  /// Returns [Status.status] 200 = complete; 400 = wrong inputs or other error + [Status.error]; 500 = server error;
  static Future<Status> resetPassword(
    String emailOrUserID, {
    QueryType? queryType,
  }) async {
    var passwordResetUri = UriHelper.getUri(
      path: '/cgi/reset_password.pl',
      queryType: queryType,
      addUserAgentParameters: false,
    );

    Map<String, String> data = <String, String>{
      'userid_or_email': emailOrUserID,
      'action': 'process',
      'type': 'send_email',
      'submit': '.submit',
    };

    Status status = await HttpHelper().doMultipartRequest(
      passwordResetUri,
      data,
      queryType: queryType,
    );
    if (status.body == null) {
      return Status(
        status: 500,
        error:
            'No response, open an issue here: https://github.com/openfoodfacts/openfoodfacts-dart/issues/new',
      );
    } else if (status.body!.contains('There is no account with this email')) {
      return Status(
        status: 400,
        body: 'There is no account with this email',
      );
    } else if (status.body!.contains('has been sent to the e-mail address')) {
      return Status(
        status: 200,
        body:
            'An email with a link to reset your password has been sent to the e-mail address associated with your account.',
      );
    } else {
      return status.copyWith(status: 400);
    }
  }

  /// Returns the nutrient hierarchy specific to a country, localized.
  ///
  /// [cc] is the country code, as ISO 3166-1 alpha-2
  static Future<OrderedNutrients> getOrderedNutrients({
    required final String cc,
    required final OpenFoodFactsLanguage language,
    final QueryType? queryType,
  }) async =>
      OrderedNutrients.fromJson(
        jsonDecode(
          await getOrderedNutrientsJsonString(
            country: CountryHelper.fromJson(cc)!,
            language: language,
          ),
        ),
      );

  /// Returns the nutrient hierarchy specific to a country, localized, as JSON
  static Future<String> getOrderedNutrientsJsonString({
    required final OpenFoodFactsCountry country,
    required final OpenFoodFactsLanguage language,
    final QueryType? queryType,
  }) async {
    final Uri uri = UriHelper.getPostUri(
      path: 'cgi/nutrients.pl',
      queryType: queryType,
    );
    Map<String, String> queryParameters = <String, String>{
      'cc': country.offTag,
      'lc': language.offTag,
    };
    final Response response = await HttpHelper().doPostRequest(
      uri,
      queryParameters,
      null,
      queryType: queryType,
      addCredentialsToBody: false,
    );
    if (response.statusCode != 200) {
      throw Exception('Could not retrieve ordered nutrients!');
    }
    return response.body;
  }

  /// Rotates a product image from an already uploaded image.
  ///
  /// "I want, for this [barcode], this [imageField] and this [language],
  /// the image to be computed from the already uploaded image
  /// referenced by [imgid], with a rotation of [angle].
  ///
  /// Returns the URL to the "display" picture after the operation.
  /// Returns null if KO, but would probably throw an exception instead.
  static Future<String?> setProductImageAngle({
    required final String barcode,
    required final ImageField imageField,
    required final OpenFoodFactsLanguage language,
    required final String imgid,
    required final ImageAngle angle,
    required final User user,
    final QueryType? queryType,
  }) async =>
      await _callProductImageCrop(
        barcode: barcode,
        imageField: imageField,
        language: language,
        imgid: imgid,
        user: user,
        extraParameters: <String, String>{
          'angle': angle.degreesClockwise,
        },
      );

  /// Crops a product image from an already uploaded image.
  ///
  /// "I want, for this [barcode], this [imageField] and this [language],
  /// the image to be computed from the already uploaded image
  /// referenced by [imgid], with a possible rotation of [angle] and then
  /// a cropping on rectangle ([x1],[y1],[x2],[y2]), those coordinates
  /// being taken from the uploaded image size.
  ///
  /// Returns the URL to the "display" picture after the operation.
  /// Returns null if KO, but would probably throw an exception instead.
  static Future<String?> setProductImageCrop({
    required final String barcode,
    required final ImageField imageField,
    required final OpenFoodFactsLanguage language,
    required final String imgid,
    required final int x1,
    required final int y1,
    required final int x2,
    required final int y2,
    required final User user,
    final ImageAngle angle = ImageAngle.NOON,
    final QueryType? queryType,
  }) async =>
      await _callProductImageCrop(
        barcode: barcode,
        imageField: imageField,
        language: language,
        imgid: imgid,
        user: user,
        extraParameters: <String, String>{
          'x1': x1.toString(),
          'y1': y1.toString(),
          'x2': x2.toString(),
          'y2': y2.toString(),
          'angle': angle.degreesClockwise,
          'coordinates_image_size': 'full',
        },
      );

  /// Calls `cgi/product_image_crop.pl` on a [ProductImage].
  ///
  /// Returns the URL to the "display" picture after the operation.
  /// Returns null if KO, but would probably throw an exception instead.
  static Future<String?> _callProductImageCrop({
    required final String barcode,
    required final ImageField imageField,
    required final OpenFoodFactsLanguage language,
    required final String imgid,
    required final Map<String, String> extraParameters,
    required final User user,
    final QueryType? queryType,
  }) async {
    final String id = '${imageField.offTag}_${language.offTag}';
    final Map<String, String> queryParameters = <String, String>{
      'code': barcode,
      'id': id,
      'imgid': imgid,
    };
    queryParameters.addAll(extraParameters);
    final Uri uri = UriHelper.getPostUri(
      path: 'cgi/product_image_crop.pl',
      queryType: queryType,
    );

    final Response response = await HttpHelper().doPostRequest(
      uri,
      queryParameters,
      user,
      queryType: queryType,
      addCredentialsToBody: true,
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Bad response (${response.statusCode}): ${response.body}');
    }
    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;
    final String status = json['status'];
    if (status != 'status ok') {
      throw Exception('Status not ok ($status)');
    }
    final String imagefield = json['imagefield'];
    if (imagefield != id) {
      throw Exception(
          'Different imagefield: expected "$id", actual "$imageField"');
    }
    final Map<String, dynamic> images = json['image'];
    final String? filename = images['display_url'];
    if (filename == null) {
      return null;
    }
    return '${ImageHelper.getProductImageRootUrl(barcode, queryType: queryType)}/$filename';
  }

  /// Unselect a product image.
  ///
  /// Typically, after that the openfoodfacts web page will _not_ show
  /// the image as selected for this product x imagefield x language anymore.
  /// Throws an exception if not successful.
  /// Will work OK even when there was no previous selected product image.
  static Future<void> unselectProductImage({
    required final String barcode,
    required final ImageField imageField,
    required final OpenFoodFactsLanguage language,
    required final User user,
    final QueryType? queryType,
  }) async {
    final String id = '${imageField.offTag}_${language.offTag}';
    final Uri uri = UriHelper.getPostUri(
      path: 'cgi/product_image_unselect.pl',
      queryType: queryType,
    );
    final Map<String, String> queryParameters = <String, String>{
      'code': barcode,
      'id': id,
    };

    final Response response = await HttpHelper().doPostRequest(
      uri,
      queryParameters,
      user,
      queryType: queryType,
      addCredentialsToBody: true,
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Bad response (${response.statusCode}): ${response.body}');
    }
    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;
    final String status = json['status'];
    if (status != 'status ok') {
      throw Exception('Status not ok ($status)');
    }
    final int statusCode = json['status_code'];
    if (statusCode != 0) {
      throw Exception('Status Code not ok ($statusCode)');
    }
    final String imagefield = json['imagefield'];
    if (imagefield != id) {
      throw Exception(
          'Different imagefield: expected "$id", actual "$imageField"');
    }
  }
}