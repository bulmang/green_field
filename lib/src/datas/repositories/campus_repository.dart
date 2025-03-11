import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cores/error_handler/result.dart';
import '../../model/campus.dart';
import '../services/firebase_stores/firebase_store_service.dart';

class CampusRepository {
  final FirebaseStoreService firebaseStoreService;

  CampusRepository({required this.firebaseStoreService});

  Future<Result<Campus, Exception>> getCampus(String campusName) async {
    final result = await firebaseStoreService.getCampus(campusName);

    switch (result) {
      case Success(value: final campus):
        final sortedEntries = campus.floorDescription!.entries.toList()
          ..sort((a, b) {
            final floorA = int.parse(a.key.split('층')[0]);
            final floorB = int.parse(b.key.split('층')[0]);
            return floorA.compareTo(floorB);
          });

        final sortedFloorDescription = Map<String, List<dynamic>>.fromEntries(sortedEntries as Iterable<MapEntry<String, List>>);
        campus.floorDescription = sortedFloorDescription;

        return Success(campus);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  Future<Result<Campus, Exception>> createCampusDB(Campus campus) async {
    final result = await firebaseStoreService.createCampusDB(campus);

    switch (result) {
      case Success(value: final campus):
        return Success(campus);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

}

final campusRepositoryProvider = Provider<CampusRepository>((ref) {
  return CampusRepository(firebaseStoreService: FirebaseStoreService(firebase_store.FirebaseFirestore.instance));
});

