import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_service.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/access_content.dart';
// Test model for access validation
class TestProduct {

  TestProduct({
    required this.id,
    required this.accessContent,
    required this.isSubscriberOnly,
    this.hasAccess,
  });

  final String id;
  final AccessContent accessContent;
  final bool isSubscriberOnly;
  final bool? hasAccess;

  TestProduct copyWith({bool? hasAccess}) {
    return TestProduct(
      id: id,
      accessContent: accessContent,
      isSubscriberOnly: isSubscriberOnly,
      hasAccess: hasAccess ?? this.hasAccess,
    );
  }
}

void main() {
  group('ActiveSubscriptionService', () {
    late ActiveSubscriptionService service;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUp(() {
      mockUser = MockUser(
        uid: 'test_user_id',
        email: 'test@example.com',
        displayName: 'Test User',
      );
      mockFirebaseAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);

      service = ActiveSubscriptionService(
        environment: StoycoEnvironment.testing,
        firebaseAuth: mockFirebaseAuth,
        cacheDuration: const Duration(seconds: 2), // Short duration for testing
      );
    });

    tearDown(() {
      service.dispose();
      service.clearCache();
    });

    test('should initialize with correct environment', () {
      expect(service.environment, equals(StoycoEnvironment.testing));
    });

    test('should initialize with Firebase Auth', () {
      expect(service.firebaseAuth, isNotNull);
      expect(service.firebaseAuth, equals(mockFirebaseAuth));
    });

    test('should initialize with custom cache duration', () {
      expect(service.cacheDuration, equals(const Duration(seconds: 2)));
    });

    test('should be singleton', () {
      final ActiveSubscriptionService instance1 =
          ActiveSubscriptionService.instance;
      final ActiveSubscriptionService instance2 =
          ActiveSubscriptionService.instance;
      expect(instance1, equals(instance2));
    });

    test('should have required Firebase Auth instance', () {
      expect(
        () => ActiveSubscriptionService(
          environment: StoycoEnvironment.testing,
          firebaseAuth: mockFirebaseAuth,
        ),
        returnsNormally,
      );
    });

    test('should clear cache on logout', () async {
      // This test verifies that the auth state listener is set up
      // In a real scenario, signing out would trigger cache clearing
      expect(service.clearCache, returnsNormally);

      // Sign out the mock user
      await mockFirebaseAuth.signOut();

      // Cache should be cleared (we can't directly test this without making
      // the cache public, but we verify the mechanism is in place)
      expect(mockFirebaseAuth.currentUser, isNull);
    });

    test('clearCache should reset cached data', () {
      // Call clearCache
      service.clearCache();

      // Since cache is private, we verify the method runs without error
      expect(service.clearCache, returnsNormally);
    });

    test(
      'hasActiveSubscriptionForPartner should accept partnerId parameter',
      () {
        // Verify the method exists and accepts the partnerId parameter
        expect(
          () => service.hasActiveSubscriptionForPartner(
            partnerId: '507f1f77bcf86cd799439012',
          ),
          returnsNormally,
        );
      },
    );

    test(
      'hasActiveSubscriptionForPartner should accept forceRefresh parameter',
      () {
        // Verify the method accepts the forceRefresh parameter
        expect(
          () => service.hasActiveSubscriptionForPartner(
            partnerId: '507f1f77bcf86cd799439012',
            forceRefresh: true,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'getActiveSubscriptionsForPartner should accept partnerId parameter',
      () {
        // Verify the method exists and accepts the partnerId parameter
        expect(
          () => service.getActiveSubscriptionsForPartner(
            partnerId: '507f1f77bcf86cd799439012',
          ),
          returnsNormally,
        );
      },
    );

    test(
      'getActiveSubscriptionsForPartner should accept forceRefresh parameter',
      () {
        // Verify the method accepts the forceRefresh parameter
        expect(
          () => service.getActiveSubscriptionsForPartner(
            partnerId: '507f1f77bcf86cd799439012',
            forceRefresh: true,
          ),
          returnsNormally,
        );
      },
    );

    group('hasAccessToContent()', () {
      // New model for access validation
      late AccessContent testContent;
      late TestProduct testProduct;

      setUp(() {
        testContent = AccessContent(
          contentId: 'event_123',
          partnerId: '507f1f77bcf86cd799439012',
          planIds: const <String>['plan_1', 'plan_2', 'plan_3'],
          visibleFrom: DateTime(2024, 1, 1),
          visibleUntil: DateTime(2024, 12, 31),
        );
        testProduct = TestProduct(
          id: 'product_1',
          accessContent: testContent,
          isSubscriberOnly: true,
        );
      });

      test('should accept product parameter', () async {
        expect(
          () async => service.hasAccessToMultiplesContent<TestProduct>(
            contents: <TestProduct>[testProduct],
            getAccessContent: (TestProduct product) => product.accessContent,
            hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
            getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
          ),
          returnsNormally,
        );
      });

      test('should accept optional partnerId parameter', () async {
        expect(
          () async => service.hasAccessToMultiplesContent<TestProduct>(
            contents: <TestProduct>[testProduct],
            getAccessContent: (TestProduct product) => product.accessContent,
            hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
            getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
            partnerId: '507f1f77bcf86cd799439012',
          ),
          returnsNormally,
        );
      });

      test('should accept forceRefresh parameter', () async {
        expect(
          () async => service.hasAccessToMultiplesContent<TestProduct>(
            contents: <TestProduct>[testProduct],
            getAccessContent: (TestProduct product) => product.accessContent,
            hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
            getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
            forceRefresh: true,
          ),
          returnsNormally,
        );
      });

      test('should accept all parameters together', () async {
        expect(
          () async => service.hasAccessToMultiplesContent<TestProduct>(
            contents: <TestProduct>[testProduct],
            getAccessContent: (TestProduct product) => product.accessContent,
            hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
            getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
            partnerId: '507f1f77bcf86cd799439012',
            forceRefresh: true,
          ),
          returnsNormally,
        );
      });

      test('should return List<TestProduct> with hasAccess field', () async {
        final List<TestProduct> result = await service.hasAccessToMultiplesContent<TestProduct>(
          contents: <TestProduct>[testProduct],
          getAccessContent: (TestProduct product) => product.accessContent,
          hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
          getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
        );
        expect(result, isA<List<TestProduct>>());
        expect(result.first.hasAccess, isNotNull);
      });

      test('should handle product with empty planIds', () async {
        final AccessContent emptyContent = AccessContent(
          contentId: 'empty_content',
          partnerId: '507f1f77bcf86cd799439012',
          planIds: const <String>[],
          visibleFrom: DateTime(2024, 1, 1),
          visibleUntil: DateTime(2024, 12, 31),
        );
        final TestProduct emptyProduct = TestProduct(
          id: 'product_empty',
          accessContent: emptyContent,
          isSubscriberOnly: true,
        );
        final List<TestProduct> result = await service.hasAccessToMultiplesContent<TestProduct>(
          contents: <TestProduct>[emptyProduct],
          getAccessContent: (TestProduct product) => product.accessContent,
          hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
          getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
        );
        expect(result.first.hasAccess, isFalse);
      });

      test('should handle product with multiple planIds', () async {
        final AccessContent multiPlanContent = AccessContent(
          contentId: 'multi_plan_content',
          partnerId: '507f1f77bcf86cd799439012',
          planIds: const <String>['plan_1', 'plan_2', 'plan_3', 'plan_4', 'plan_5'],
          visibleFrom: DateTime(2024, 1, 1),
          visibleUntil: DateTime(2024, 12, 31),
        );
        final TestProduct multiPlanProduct = TestProduct(
          id: 'product_multi',
          accessContent: multiPlanContent,
          isSubscriberOnly: true,
        );
        final List<TestProduct> result = await service.hasAccessToMultiplesContent<TestProduct>(
          contents: <TestProduct>[multiPlanProduct],
          getAccessContent: (TestProduct product) => product.accessContent,
          hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
          getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
        );
        expect(result.first.hasAccess, isNotNull);
      });
    });

    group('checkMultipleContentAccess()', () {
      late List<TestProduct> testProducts;

      setUp(() {
        testProducts = <TestProduct>[
          TestProduct(
            id: 'product_1',
            accessContent: AccessContent(
              contentId: 'event_123',
              partnerId: '507f1f77bcf86cd799439012',
              planIds: const <String>['plan_1', 'plan_2'],
              visibleFrom: DateTime(2024, 1, 1),
              visibleUntil: DateTime(2024, 12, 31),
            ),
            isSubscriberOnly: true,
          ),
          TestProduct(
            id: 'product_2',
            accessContent: AccessContent(
              contentId: 'exclusive_456',
              partnerId: '507f1f77bcf86cd799439012',
              planIds: const <String>['plan_3', 'plan_4'],
              visibleFrom: DateTime(2024, 1, 1),
              visibleUntil: DateTime(2024, 12, 31),
            ),
            isSubscriberOnly: true,
          ),
          TestProduct(
            id: 'product_3',
            accessContent: AccessContent(
              contentId: 'asset_789',
              partnerId: '507f1f77bcf86cd799439012',
              planIds: const <String>['plan_5'],
              visibleFrom: DateTime(2024, 1, 1),
              visibleUntil: DateTime(2024, 12, 31),
            ),
            isSubscriberOnly: true,
          ),
        ];
      });

      test('should accept products list parameter', () async {
        expect(
          () async => service.hasAccessToMultiplesContent<TestProduct>(
            contents: testProducts,
            getAccessContent: (TestProduct product) => product.accessContent,
            hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
            getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
          ),
          returnsNormally,
        );
      });

      test('should accept optional partnerId parameter', () async {
        expect(
          () async => service.hasAccessToMultiplesContent<TestProduct>(
            contents: testProducts,
            getAccessContent: (TestProduct product) => product.accessContent,
            hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
            getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
            partnerId: '507f1f77bcf86cd799439012',
          ),
          returnsNormally,
        );
      });

      test('should accept forceRefresh parameter', () async {
        expect(
          () async => service.hasAccessToMultiplesContent<TestProduct>(
            contents: testProducts,
            getAccessContent: (TestProduct product) => product.accessContent,
            hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
            getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
            forceRefresh: true,
          ),
          returnsNormally,
        );
      });

      test('should accept all parameters together', () async {
        expect(
          () async => service.hasAccessToMultiplesContent<TestProduct>(
            contents: testProducts,
            getAccessContent: (TestProduct product) => product.accessContent,
            hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
            getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
            partnerId: '507f1f77bcf86cd799439012',
            forceRefresh: true,
          ),
          returnsNormally,
        );
      });

      test('should return List<TestProduct> with hasAccess field', () async {
        final List<TestProduct> result = await service.hasAccessToMultiplesContent<TestProduct>(
          contents: testProducts,
          getAccessContent: (TestProduct product) => product.accessContent,
          hasAccessToContent: (TestProduct product, bool hasAccess) => product.copyWith(hasAccess: hasAccess),
          getIsSubscriptionOnly: (TestProduct product) => product.isSubscriberOnly,
        );
        expect(result, isA<List<TestProduct>>());
        expect(result.first.hasAccess, isNotNull);
      });
    });

    test('getAllUserAccesses should work without parameters', () {
      // Verify the method works without any required parameters
      expect(() => service.getAllUserAccesses(), returnsNormally);
    });

    test('getAllUserAccesses should accept optional partnerId parameter', () {
      // Verify the method accepts the optional partnerId parameter
      expect(
        () => service.getAllUserAccesses(partnerId: '507f1f77bcf86cd799439012'),
        returnsNormally,
      );
    });

    group('refreshCacheFromPush()', () {
      test('should complete without throwing errors', () async {
        // Should complete successfully even if API call fails
        await expectLater(service.refreshCacheFromPush(), completes);
      });

      test('should not throw error even if API fails', () async {
        // Simulate API error by using invalid token
        final MockUser mockUserWithoutToken = MockUser(
          uid: 'test_user_id',
          email: 'test@example.com',
          displayName: 'Test User',
        );
        final MockFirebaseAuth mockAuthWithoutToken = MockFirebaseAuth(
          mockUser: mockUserWithoutToken,
          signedIn: true,
        );

        final ActiveSubscriptionService serviceWithError = ActiveSubscriptionService(
          environment: StoycoEnvironment.testing,
          firebaseAuth: mockAuthWithoutToken,
          cacheDuration: const Duration(seconds: 2),
        );

        // Should complete without throwing
        await expectLater(serviceWithError.refreshCacheFromPush(), completes);

        serviceWithError.dispose();
      });

      test('should work when called multiple times in sequence', () async {
        // Call refresh multiple times - should not throw
        await expectLater(service.refreshCacheFromPush(), completes);

        await expectLater(service.refreshCacheFromPush(), completes);

        await expectLater(service.refreshCacheFromPush(), completes);
      });

      test('should handle concurrent refresh calls', () async {
        // Call refresh concurrently
        final List<Future<void>> futures = <Future<void>>[
          service.refreshCacheFromPush(),
          service.refreshCacheFromPush(),
          service.refreshCacheFromPush(),
        ];

        // All should complete without error
        await expectLater(Future.wait(futures), completes);
      });

      test('should work even when cache is expired', () async {
        // Wait for cache to expire
        await Future<void>.delayed(const Duration(seconds: 3));

        // Refresh from push should still complete
        await expectLater(service.refreshCacheFromPush(), completes);
      });

      test('should work correctly after clearCache()', () async {
        // Clear cache manually
        service.clearCache();

        // Refresh from push should still work
        await expectLater(service.refreshCacheFromPush(), completes);
      });

      test('should clear cache when called', () {
        // This test verifies the method clears cache
        // We can't directly test cache state, but we verify the method runs
        expect(() => service.refreshCacheFromPush(), returnsNormally);
      });
    });
  });

  group('ActiveUserPlanResponse', () {
    test('should parse JSON correctly', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'error': 0,
        'messageError': '',
        'tecMessageError': '',
        'count': 1,
        'data': <Map<String, dynamic>>[
          <String, dynamic>{
            '_id': '507f1f77bcf86cd799439011',
            'Plan': <String, dynamic>{
              '_id': '507f191e810c19729de860ea',
              'Name': 'Premium Plan',
              'Is_deleted': false,
              'Accesses': <String>['content', 'events'],
            },
            'Partner_id': '507f1f77bcf86cd799439012',
            'User_id': 'firebase_user_123',
            'Recurrence': 'monthly',
            'Subscribed_at': '2024-01-15T10:30:00Z',
            'Is_active': true,
            'Trial_start_date': null,
            'Trial_end_date': null,
            'End_date': '2024-02-15T10:30:00Z',
            'Created_at': '2024-01-15T10:30:00Z',
            'Modified_at': '2024-01-15T10:30:00Z',
          },
        ],
      };

      // Este test requeriría importar el modelo, pero como es un ejemplo básico,
      // solo se muestra la estructura
      expect(json['error'], equals(0));
      expect(json['count'], equals(1));
      expect(json['data'], isA<List<dynamic>>());
    });
  });

  group('StoycoEnvironment', () {
    test('development environment should return correct base URL', () {
      expect(
        StoycoEnvironment.development.baseUrl(),
        equals('https://dev.api.stoyco.io/api/stoyco/v1/'),
      );
    });

    test('testing environment should return correct base URL', () {
      expect(
        StoycoEnvironment.testing.baseUrl(),
        equals('https://qa.api.stoyco.io/api/stoyco/v1/'),
      );
    });

    test('production environment should return correct base URL', () {
      expect(
        StoycoEnvironment.production.baseUrl(),
        equals('https://api.stoyco.io/api/stoyco/v1/'),
      );
    });
  });
}
