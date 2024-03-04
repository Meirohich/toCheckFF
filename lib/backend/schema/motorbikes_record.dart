import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MotorbikesRecord extends FirestoreRecord {
  MotorbikesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "points" field.
  LatLng? _points;
  LatLng? get points => _points;
  bool hasPoints() => _points != null;

  // "price" field.
  int? _price;
  int get price => _price ?? 0;
  bool hasPrice() => _price != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _points = snapshotData['points'] as LatLng?;
    _price = castToType<int>(snapshotData['price']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('motorbikes');

  static Stream<MotorbikesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MotorbikesRecord.fromSnapshot(s));

  static Future<MotorbikesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MotorbikesRecord.fromSnapshot(s));

  static MotorbikesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MotorbikesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MotorbikesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MotorbikesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MotorbikesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MotorbikesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMotorbikesRecordData({
  String? name,
  LatLng? points,
  int? price,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'points': points,
      'price': price,
    }.withoutNulls,
  );

  return firestoreData;
}

class MotorbikesRecordDocumentEquality implements Equality<MotorbikesRecord> {
  const MotorbikesRecordDocumentEquality();

  @override
  bool equals(MotorbikesRecord? e1, MotorbikesRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.points == e2?.points &&
        e1?.price == e2?.price;
  }

  @override
  int hash(MotorbikesRecord? e) =>
      const ListEquality().hash([e?.name, e?.points, e?.price]);

  @override
  bool isValidKey(Object? o) => o is MotorbikesRecord;
}
