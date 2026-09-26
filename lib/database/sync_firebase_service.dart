import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_database.dart';
import 'sync_foundation.dart';

/// Stage A Firebase connectivity layer.
///
/// This service deliberately does NOT synchronize accounting records yet.
/// It only:
///   1. signs this installation in anonymously,
///   2. verifies access to the AABM Firestore collection, and
///   3. records the connection result in the local sync_state table.
///
/// Stage B will use the same authenticated Firestore connection to transport
/// the existing SyncFoundation outbox.
class SyncFirebaseService {
  SyncFirebaseService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String collectionName = 'aabm_sync_changes';

  static User? get currentUser => _auth.currentUser;

  static Future<void> initialize(AppDatabase db) async {
    await SyncFoundation.initialize(db);

    try {
      final user = _auth.currentUser ??
          (await _auth.signInAnonymously()).user;

      if (user == null) {
        throw StateError('Firebase anonymous authentication returned no user.');
      }

      final deviceId = await SyncFoundation.getDeviceId(db);
      final changeId = 'connection-test-$deviceId';
      final ref = _firestore.collection(collectionName).doc(changeId);

      await ref.set({
        'type': 'connection_test',
        'deviceId': deviceId,
        'firebaseUid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await ref.delete();

      await SyncFoundation.setState(db, 'firebase_status', 'CONNECTED');
      await SyncFoundation.setState(db, 'firebase_uid', user.uid);
      await SyncFoundation.setState(
        db,
        'firebase_last_test_at',
        DateTime.now().toUtc().toIso8601String(),
      );
    } catch (error) {
      await SyncFoundation.setState(db, 'firebase_status', 'ERROR');
      await SyncFoundation.setState(db, 'firebase_last_error', '$error');
      // Do not prevent the existing offline-first application from opening.
      // A later sync attempt can retry when connectivity is available.
      // ignore: avoid_print
      print('AABM Firebase Stage A connection failed: $error');
    }
  }

  /// Re-run the Stage A connection test manually.
  static Future<bool> testConnection(AppDatabase db) async {
    try {
      await initialize(db);
      final status = await SyncFoundation.getState(db, 'firebase_status');
      return status == 'CONNECTED';
    } catch (_) {
      return false;
    }
  }
}
