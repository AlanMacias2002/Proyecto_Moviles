import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_moviles/Models/party_model.dart';

class PartyRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _userParties(String uid) =>
      _userDoc(uid).collection('parties');

  Future<String> _requireUid() async {
    final user = _auth.currentUser;
    if (user != null) return user.uid;
    throw StateError('Usuario no autenticado');
  }

  Future<void> ensureUserDocument() async {
    final uid = await _requireUid();
    await _userDoc(uid).set({
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String> createParty(Party party) async {
    final uid = await _requireUid();
    final data = party.toJson()
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    final doc = await _userParties(uid).add(data);
    return doc.id;
  }

  Future<void> updateParty(String partyId, Party party) async {
    final uid = await _requireUid();
    final data = party.toJson()
      ..addAll({'updatedAt': FieldValue.serverTimestamp()});
    await _userParties(uid).doc(partyId).set(data, SetOptions(merge: true));
  }

  Future<void> deleteParty(String partyId) async {
    final uid = await _requireUid();
    await _userParties(uid).doc(partyId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> partiesStream() async* {
    final uid = await _requireUid();
    yield* _userParties(uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // ====== Compartir / Importar ======
  CollectionReference<Map<String, dynamic>> get _sharedParties =>
      _db.collection('shared_parties');

  Future<String> shareParty(String partyId) async {
    final uid = await _requireUid();
    final doc = await _userParties(uid).doc(partyId).get();
    if (!doc.exists) throw StateError('Party no encontrada');
    final partyData = Map<String, dynamic>.from(doc.data()!);
    // Remover timestamps internos para snapshot limpio
    partyData.remove('createdAt');
    partyData.remove('updatedAt');
    final shareDoc = await _sharedParties.add({
      'ownerId': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'party': partyData,
    });
    return shareDoc.id;
  }

  Future<Party> fetchSharedParty(String shareId) async {
    final doc = await _sharedParties.doc(shareId).get();
    if (!doc.exists) throw StateError('QR inválido o expirado');
    final data = doc.data()!;
    final partyJson = Map<String, dynamic>.from(data['party'] as Map);
    return Party.fromJson(partyJson);
  }

  Future<String> importSharedParty(String shareId) async {
    final party = await fetchSharedParty(shareId);
    // crear nueva party para el usuario actual
    return createParty(party);
  }
}
