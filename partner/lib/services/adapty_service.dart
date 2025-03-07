import 'dart:developer';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdaptyService {
  AdaptyService._();
  static AdaptyService instance = AdaptyService._();

  void activate() {
    try {
      Adapty().activate();
      log('✔ ADAPTY ACTIVATED');
    } on AdaptyError catch (error) {
      log('❌ ADAPTY ERROR: ${error.message}');
    }
  }

  Future<AdaptyProfile?> getAdaptyProfile() async {
    activate();
    try {
      final profile = await Adapty().getProfile();
      await updateAdaptyProfileOnFirebase(profile);
      log('✔ ADAPTY PROFILE: $profile');
      return profile;
    } on AdaptyError catch (adaptyError) {
      log('ADAPTY ERROR: ${adaptyError.message}');
      return null;
    } catch (e) {
      log('UNKNOWN ADAPTY ERROR: $e');
      return null;
    }
  }

  Future<void> updateAdaptyProfileOnFirebase(AdaptyProfile? profile) async {
    await FirebaseFirestore.instance.collection('partners').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'customerUserId': profile?.profileId,
      'accessLevel': profile?.accessLevels['haem_premium']?.isActive ?? false ? 'premium' : 'free',
      'subscriptions': profile?.subscriptions.map((key, value) {
        return MapEntry(key, {
          'activatedAt': value.activatedAt,
          'activeIntroductoryOfferType': value.activeIntroductoryOfferType,
          'activePromotionalOfferId': value.activePromotionalOfferId,
          'activePromotionalOfferType': value.activePromotionalOfferType,
          'billingIssueDetectedAt': value.billingIssueDetectedAt,
          'cancellationReason': value.cancellationReason,
          'expiresAt': value.expiresAt,
          'isActive': value.isActive,
          'isInGracePeriod': value.isInGracePeriod,
          'isLifetime': value.isLifetime,
          'isRefund': value.isRefund,
          'isSandbox': value.isSandbox,
          'renewedAt': value.renewedAt,
          'startsAt': value.startsAt,
          'store': value.store,
          'unsubscribedAt': value.unsubscribedAt,
          'vendorOriginalTransactionId': value.vendorOriginalTransactionId,
          'vendorProductId': value.vendorProductId,
          'vendorTransactionId': value.vendorTransactionId,
          'willRenew': value.willRenew,
        });
      }),
    });

    final user = await FirebaseFirestore.instance.collection('partners').doc(FirebaseAuth.instance.currentUser!.uid).get();
    final userData = user.data();
    final hasGift = userData?['gift'] != null;
    bool hasGiftExpired;
    if (hasGift) {
      final Timestamp? giftTimestamp = userData?['gift'];
      hasGiftExpired = giftTimestamp?.toDate().isBefore(DateTime.now()) ?? false;
    } else {
      hasGiftExpired = false;
    }
    log('🎁 HAS GIFT: $hasGift');
    log('🎁 HAS GIFT EXPIRED: $hasGiftExpired');

    bool isPro;
    if (profile?.accessLevels['haem_premium']?.isActive ?? false) {
      isPro = true;
    } else if (hasGift && !hasGiftExpired) {
      isPro = true;
    } else {
      isPro = false;
    }
    await FirebaseAuth.instance.currentUser?.updateDisplayName(isPro ? 'pro' : 'free');
  }

  Future<void> updateFirebaseProfileOnAdapty() async {
    final builder = AdaptyProfileParametersBuilder()
      ..setFirebaseAppInstanceId(
        await FirebaseAnalytics.instance.appInstanceId,
      );

    try {
      await Adapty().updateProfile(builder.build());
      log('🎉 FIREBASE PROFILE UPDATED ON ADAPTY');
    } on AdaptyError catch (adaptyError) {
      log('ADAPTY ERROR: ${adaptyError.message}');
    } catch (e) {
      log('UNKNOWN ADAPTY ERROR: $e');
    }
  }

  Future<AdaptyProfile?> getAdaptyProfileOnly() async {
    activate();
    try {
      final profile = await Adapty().getProfile();
      return profile;
    } on AdaptyError catch (adaptyError) {
      log('ADAPTY ERROR: ${adaptyError.message}');
      return null;
    } catch (e) {
      log('UNKNOWN ADAPTY ERROR: $e');
      return null;
    }
  }

  Future<AdaptyPaywall?> getPaywall() async {
    activate();
    try {
      final AdaptyPaywall paywall = await Adapty().getPaywall(placementId: 'haem_main', locale: 'tr');
      return paywall;
    } on AdaptyError catch (error) {
      log('ADAPTY PAYWALL ERROR: ${error.message}');
      return null;
    } catch (error) {
      log('UNKNOWN ADAPTY ERROR: $error');
      return null;
    }
  }

  Future<List<AdaptyPaywallProduct>> getProducts() async {
    final paywall = await getPaywall();

    if (paywall == null) {
      log('PAYWALL IS NULL');
      return [];
    }

    try {
      final List<AdaptyPaywallProduct> products = await Adapty().getPaywallProducts(paywall: paywall);
      return products;
    } on AdaptyError catch (error) {
      log('ADAPTY PRODUCTS ERROR: ${error.message}');
      return [];
    } catch (error) {
      log('UNKNOWN ADAPTY ERROR: $error');
      return [];
    }
  }

  Future<void> makePurchase(AdaptyPaywallProduct product) async {
    try {
      final profile = await Adapty().makePurchase(product: product);
      if (profile?.accessLevels['haem_premium']?.isActive ?? false) {
        log('PURCHASE SUCCESSFUL. ${product.localizedTitle} is now active.');
        await FirebaseAuth.instance.currentUser?.updateDisplayName('pro');
        await updateAdaptyProfileOnFirebase(profile);
      } else {
        log('PURCHASE FAILED');
      }
    } on AdaptyError catch (error) {
      log('ADAPTY PURCHASE ERROR: ${error.message}');
    } catch (error) {
      log('UNKNOWN ADAPTY ERROR: $error');
    }
  }
}
