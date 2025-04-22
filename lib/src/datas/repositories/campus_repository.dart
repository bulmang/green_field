import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:green_field/src/datas/services/firebase_stores/firebase_store_campus_service.dart';
import 'package:green_field/src/domains/interfaces/campus_service_interface.dart';

import '../../cores/error_handler/result.dart';
import '../../model/campus.dart';

class CampusRepository {
  final CampusServiceInterface service;

  CampusRepository({required this.service});

  Future<Result<Campus, Exception>> getCampus(String campusName) async {
    final result = await service.getCampus(campusName);

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
    final result = await service.createCampusDB(campus);

    switch (result) {
      case Success(value: final campus):
        return Success(campus);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

}

final campusRepositoryProvider = Provider<CampusRepository>((ref) {
  return CampusRepository(service: FirebaseStoreCampusService(firebase_store.FirebaseFirestore.instance));
});

