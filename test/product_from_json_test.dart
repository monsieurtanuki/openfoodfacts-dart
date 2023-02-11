import 'dart:convert';

import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:test/test.dart';

import 'test_constants.dart';

void main() {
  OpenFoodAPIConfiguration.userAgent = TestConstants.TEST_USER_AGENT;

  // Verify that we can save the product as a JSON string and then load it back
  test('Load product from JSON', () async {
    String barcode = '0030000010204';
    ProductQueryConfiguration configurations = ProductQueryConfiguration(
      barcode,
      languages: [OpenFoodFactsLanguage.ENGLISH, OpenFoodFactsLanguage.FRENCH],
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );
    ProductResultV3 result = await OpenFoodAPIClient.getProductV3(
      configurations,
      user: TestConstants.TEST_USER,
    );
    expect(result.status, ProductResultV3.statusSuccess);
    Product product = result.product!;
    Map<String, dynamic> productMap = product.toJson();
    String encodedJson = jsonEncode(productMap);
    final Map<String, dynamic> decodedJson =
        json.decode(encodedJson) as Map<String, dynamic>;
    Product product2 = Product.fromJson(decodedJson);
    expect(product.productName, equals(product2.productName));
  });

  test('Load product from JSON - multilingual categories', () async {
    String encodedJson =
        '{"code":"3175681132467","product_name":"Les galettes orge et boulgour au chèvre et miel","brands":"Céréal Bio","lang":"fr","quantity":"200g","image_small_url":"https://images.openfoodfacts.org/images/products/317/568/113/2467/front_fr.167.200.jpg","image_front_url":"https://images.openfoodfacts.org/images/products/317/568/113/2467/front_fr.167.400.jpg","image_front_small_url":"https://images.openfoodfacts.org/images/products/317/568/113/2467/front_fr.167.200.jpg","image_ingredients_url":"https://images.openfoodfacts.org/images/products/317/568/113/2467/ingredients_fr.141.400.jpg","image_nutrition_url":"https://images.openfoodfacts.org/images/products/317/568/113/2467/nutrition_fr.165.400.jpg","image_packaging_url":"https://images.openfoodfacts.org/images/products/317/568/113/2467/packaging_fr.143.400.jpg","serving_size":"100g","product_quantity":"200","selected_images":{"front":{"thumb":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/front_fr.167.100.jpg"},"small":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/front_fr.167.200.jpg"},"display":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/front_fr.167.400.jpg"},"original":{},"unknown":{}},"ingredients":{"thumb":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/ingredients_fr.141.100.jpg"},"small":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/ingredients_fr.141.200.jpg"},"display":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/ingredients_fr.141.400.jpg"},"original":{},"unknown":{}},"nutrition":{"thumb":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/nutrition_fr.165.100.jpg"},"small":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/nutrition_fr.165.200.jpg"},"display":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/nutrition_fr.165.400.jpg"},"original":{},"unknown":{}},"packaging":{"thumb":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/packaging_fr.143.100.jpg"},"small":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/packaging_fr.143.200.jpg"},"display":{"fr":"https://images.openfoodfacts.org/images/products/317/568/113/2467/packaging_fr.143.400.jpg"},"original":{},"unknown":{}},"other":{"thumb":{},"small":{},"display":{},"original":{},"unknown":{}}},"images":{},"ingredients_analysis_tags":["en:non-vegan","en:vegetarian","en:palm-oil-content-unknown"],"nutriments":{"salt_100g":1.0,"fiber_100g":6.3,"sugars_100g":3.4,"fat_100g":10.0,"saturated-fat_100g":1.7,"proteins_100g":5.4,"nova-group_100g":3,"energy_100g":920.0,"energy-kcal":220.0,"energy-kcal_100g":220.0,"carbohydrates_100g":24.0,"salt_serving":1.0,"fiber_serving":6.3,"sugars_serving":3.4,"fat_serving":10.0,"saturated-fat_serving":1.7,"proteins_serving":5.4,"proteins_unit":"G","nova-group_serving":3,"energy_serving":920.0,"carbohydrates_serving":24.0,"energy_unit":"KCAL","energy-kcal_unit":"KCAL","sodium_serving":0.4,"sodium_100g":0.4,"sodium_unit":"G"},"additives_tags":[],"allergens_tags":[],"nutrient_levels":{"sugars":"low","fat":"moderate","saturated-fat":"moderate","salt":"moderate"},"nutrition_grade_fr":"a","categories_tags":["en:plant-based-foods-and-beverages","en:plant-based-foods","en:cereals-and-potatoes","en:fruits-and-vegetables-based-foods","en:cereals-and-their-products","en:meals","en:sandwiches","en:meat-analogues","en:plant-based-meals","fr:cereales-preparees","en:veggie-patties","en:bulgur-dishes","en:low-fat-prepared-meals","en:veggie-burgers","fr:galettes-de-cereales-aux-legumes","fr:plats-prepares-au-fromage"],"categories_tags_in_languages":{"fr":["Aliments et boissons à base de végétaux","Aliments d\'origine végétale","Céréales et pommes de terre","Aliments à base de fruits et de légumes","Céréales et dérivés","Plats préparés","Sandwichs","Substituts de viande","Plats préparés d\'origine végétale","Céréales préparées","Steaks végétaux","Plats à base de boulgour","Plats préparés à faible teneur en matières grasses","Hamburgers végétariens","Galettes de céréales aux légumes","Plats-prepares-au-fromage"]},"labels_tags":["en:organic","en:vegetarian","en:eu-organic","en:non-eu-agriculture","en:es-eco-019-ct","en:eu-agriculture","en:eu-non-eu-agriculture","en:fr-bio-01","en:high-fibres","en:made-in-france","en:no-additives","en:no-colorings","en:no-preservatives","en:nutriscore","en:nutriscore-grade-a","fr:ab-agriculture-biologique","en:es-eco-019"],"labels_tags_in_languages":{"fr":["Bio","Végétarien","Bio européen","Agriculture non UE","ES-ECO-019-CT","Agriculture UE","Agriculture UE/Non UE","FR-BIO-01","Riche en fibres","Fabriqué en France","Sans additifs","Sans colorants","Sans conservateurs","Nutriscore","Nutriscore A","AB Agriculture Biologique","en:es-eco-019"]},"attribute_groups":[{"id":"nutritional_quality","name":"Qualité nutritionnelle","attributes":[{"id":"nutriscore","name":"Nutri-Score","title":"Nutri-Score A","icon_url":"https://static.openfoodfacts.org/images/attributes/nutriscore-a.svg","description":"","description_short":"Très bonne qualité nutritionnelle","match":80.0,"status":"known"},{"id":"low_salt","name":"Sel","title":"Sel en quantité modérée","icon_url":"https://static.openfoodfacts.org/images/attributes/nutrient-level-salt-medium.svg","description_short":"1 g / 100 g","match":45.0,"status":"known"},{"id":"low_fat","name":"Matières grasses / Lipides","title":"Matières grasses / Lipides en quantité modérée","icon_url":"https://static.openfoodfacts.org/images/attributes/nutrient-level-fat-medium.svg","description_short":"10 g / 100 g","match":55.2941176470588,"status":"known"},{"id":"low_sugars","name":"Sucres","title":"Sucres en faible quantité","icon_url":"https://static.openfoodfacts.org/images/attributes/nutrient-level-sugars-low.svg","description_short":"3.4 g / 100 g","match":86.4,"status":"known"},{"id":"low_saturated_fat","name":"Acides gras saturés","title":"Acides gras saturés en quantité modérée","icon_url":"https://static.openfoodfacts.org/images/attributes/nutrient-level-saturated-fat-medium.svg","description_short":"1.7 g / 100 g","match":76.5714285714286,"status":"known"}]},{"id":"allergens","name":"Allergènes","warning":"Il est toujours possible que les données sur les allergènes soient manquantes, incomplètes, incorrectes ou que la composition du produit ait changé. Si vous êtes allergique, vérifiez toujours les informations sur l\'emballage réel du produit.","attributes":[{"id":"allergens_no_gluten","name":"Gluten","title":"Contient : Gluten","icon_url":"https://static.openfoodfacts.org/images/attributes/contains-gluten.svg","match":0.0,"status":"known"},{"id":"allergens_no_milk","name":"Lait","title":"Contient : Lait","icon_url":"https://static.openfoodfacts.org/images/attributes/contains-milk.svg","match":0.0,"status":"known"},{"id":"allergens_no_eggs","name":"Œufs","title":"Présence inconnue : Œufs","icon_url":"https://static.openfoodfacts.org/images/attributes/eggs-content-unknown.svg","status":"unknown"},{"id":"allergens_no_nuts","name":"Fruits à coque","title":"Peut contenir : Fruits à coque","icon_url":"https://static.openfoodfacts.org/images/attributes/may-contain-nuts.svg","match":20.0,"status":"known"},{"id":"allergens_no_peanuts","name":"Arachides","title":"Présence inconnue : Arachides","icon_url":"https://static.openfoodfacts.org/images/attributes/peanuts-content-unknown.svg","status":"unknown"},{"id":"allergens_no_sesame_seeds","name":"Graines de sésame","title":"Peut contenir : Graines de sésame","icon_url":"https://static.openfoodfacts.org/images/attributes/may-contain-sesame-seeds.svg","match":20.0,"status":"known"},{"id":"allergens_no_soybeans","name":"Soja","title":"Peut contenir : Soja","icon_url":"https://static.openfoodfacts.org/images/attributes/may-contain-soybeans.svg","match":20.0,"status":"known"},{"id":"allergens_no_celery","name":"Céleri","title":"Peut contenir : Céleri","icon_url":"https://static.openfoodfacts.org/images/attributes/may-contain-celery.svg","match":20.0,"status":"known"},{"id":"allergens_no_mustard","name":"Moutarde","title":"Présence inconnue : Moutarde","icon_url":"https://static.openfoodfacts.org/images/attributes/mustard-content-unknown.svg","status":"unknown"},{"id":"allergens_no_lupin","name":"Lupin","title":"Présence inconnue : Lupin","icon_url":"https://static.openfoodfacts.org/images/attributes/lupin-content-unknown.svg","status":"unknown"},{"id":"allergens_no_fish","name":"Poisson","title":"Présence inconnue : Poisson","icon_url":"https://static.openfoodfacts.org/images/attributes/fish-content-unknown.svg","status":"unknown"},{"id":"allergens_no_crustaceans","name":"Crustacés","title":"Présence inconnue : Crustacés","icon_url":"https://static.openfoodfacts.org/images/attributes/crustaceans-content-unknown.svg","status":"unknown"},{"id":"allergens_no_molluscs","name":"Mollusques","title":"Présence inconnue : Mollusques","icon_url":"https://static.openfoodfacts.org/images/attributes/molluscs-content-unknown.svg","status":"unknown"},{"id":"allergens_no_sulphur_dioxide_and_sulphites","name":"Anhydride sulfureux et sulfites","title":"Présence inconnue : Anhydride sulfureux et sulfites","icon_url":"https://static.openfoodfacts.org/images/attributes/sulphur-dioxide-and-sulphites-content-unknown.svg","status":"unknown"}]},{"id":"ingredients_analysis","name":"Ingrédients","attributes":[{"id":"vegan","name":"Végétalien","title":"Non végétalien","icon_url":"https://static.openfoodfacts.org/images/attributes/non-vegan.svg","match":0.0,"status":"known"},{"id":"vegetarian","name":"Végétarien","title":"Végétarien","icon_url":"https://static.openfoodfacts.org/images/attributes/vegetarian.svg","match":100.0,"status":"known"},{"id":"palm_oil_free","name":"Sans huile de palme","title":"Présence d\'huile de palme inconnue","icon_url":"https://static.openfoodfacts.org/images/attributes/palm-oil-content-unknown.svg","status":"unknown"}]},{"id":"processing","name":"Transformation des aliments","attributes":[{"id":"nova","name":"Groupe NOVA","title":"NOVA 3","icon_url":"https://static.openfoodfacts.org/images/attributes/nova-group-3.svg","description":"","description_short":"Aliments transformés","match":50.0,"status":"known"}]},{"id":"ingredients","name":"","attributes":[{"id":"additives","name":"Additifs","title":"Sans additifs","icon_url":"https://static.openfoodfacts.org/images/attributes/0-additives.svg","match":100.0,"status":"known"}]},{"id":"labels","name":"Labels","attributes":[{"id":"labels_organic","name":"Agriculture biologique","title":"Produit bio","icon_url":"https://static.openfoodfacts.org/images/attributes/organic.svg","description":"L\'agriculture biologique vise à protéger l\'environnement et à conserver la biodiversité en prohibant ou limitant l\'utilisation d\'engrais synthétiques, de pesticides et d\'additifs alimentaires.","description_short":"Encourage la durabilité écologique et la biodiversité.","match":100.0,"status":"known"},{"id":"labels_fair_trade","name":"Commerce équitable","title":"Ne provient pas du commerce équitable","icon_url":"https://static.openfoodfacts.org/images/attributes/not-fair-trade.svg","description":"Quand vous achetez des produits du commerce équitable, les producteurs dans les pays en développement sont payés un prix plus haut et plus équitable, ce qui les aide à atteindre des plus hauts standards sociaux et environnementaux et à les conserver.","description_short":"Les produits du commerce équitable aident les producteurs des pays en voie de développement.","match":0.0,"status":"known"}]}]}';
    final Map<String, dynamic> decodedJson =
        json.decode(encodedJson) as Map<String, dynamic>;
    Product product = Product.fromJson(decodedJson);
    expect(
        product.categoriesTagsInLanguages,
        equals({
          OpenFoodFactsLanguage.FRENCH: [
            'Aliments et boissons à base de végétaux',
            'Aliments d\'origine végétale',
            'Céréales et pommes de terre',
            'Aliments à base de fruits et de légumes',
            'Céréales et dérivés',
            'Plats préparés',
            'Sandwichs',
            'Substituts de viande',
            'Plats préparés d\'origine végétale',
            'Céréales préparées',
            'Steaks végétaux',
            'Plats à base de boulgour',
            'Plats préparés à faible teneur en matières grasses',
            'Hamburgers végétariens',
            'Galettes de céréales aux légumes',
            'Plats-prepares-au-fromage'
          ]
        }));
  });
}
