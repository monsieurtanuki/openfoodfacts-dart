import 'dart:math';

import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:test/test.dart';

import 'test_constants.dart';

void main() {
  OpenFoodAPIConfiguration.userAgent = TestConstants.TEST_USER_AGENT;
  const UriProductHelper uriHelper = uriHelperFoodTest;

  group('Create user', () {
    test('Create user', () async {
      late String userId;
      late String email;
      late String name;
      String password = "ThisIsThePassword";

      bool shouldRetry = true;
      int counter = 0;
      const int max_tries = 5;

      while (shouldRetry && counter < max_tries) {
        counter++;
        userId = _generateRandomString(10);
        name = 'M. $userId';
        email = "$userId@gmail.com";

        SignUpStatus response = await OpenFoodAPIClient.register(
          user: User(userId: userId, password: password),
          name: name,
          email: email,
          uriHelper: uriHelper,
          newsletter: false,
        );

        if (response.status == 201) {
          shouldRetry = false;
        }
      }

      final LoginStatus? status = await OpenFoodAPIClient.login2(
        User(userId: userId, password: password),
        uriHelper: uriHelper,
      );
      expect(status, isNotNull);
      expect(status!.successful, isTrue);
      expect(status.userId, userId);
      expect(status.userName, name);
      expect(status.preferredLanguage, isNull);
      expect(status.country, isNull);
      expect(status.isAdmin, false);
      expect(status.isModerator, false);
    });

    test('Login with invalid credentials', () async {
      final LoginStatus? status = await OpenFoodAPIClient.login2(
        User(userId: '123', password: '123'),
        uriHelper: uriHelper,
      );
      expect(status?.successful, false);
      expect(status?.statusVerbose, 'user not signed-in');
    });

    test('Login with problematic charset', () async {
      final LoginStatus? status = await OpenFoodAPIClient.login2(
        User(userId: 'លីវយី', password: ''),
        uriHelper: uriHelper,
      );
      expect(status?.successful, false);
      expect(status?.statusVerbose, 'user not signed-in');
    });
  });
}

String _generateRandomString(int length) {
  final Random r = Random();
  return String.fromCharCodes(
    List.generate(length, (index) => r.nextInt(26) + 65),
  ).toLowerCase();
}
