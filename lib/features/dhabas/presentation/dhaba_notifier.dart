import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../../../models/dhaba_model.dart';
import '../domain/dhaba_repository.dart';
import '../domain/dhaba_search_query.dart';
import '../domain/dhaba_sorter.dart';
import '../data/dhaba_api.dart';
import '../data/dhaba_repository_impl.dart';

final dhabaApiProvider = Provider((ref) {
  return DhabaApi(ref.watch(dioClientProvider));
});

final dhabaRepositoryProvider = Provider<DhabaRepository>((ref) {
  return DhabaRepositoryImpl(ref.watch(dhabaApiProvider));
});

final dhabaSearchQueryProvider = StateProvider<DhabaSearchQuery>((ref) => const DhabaSearchQuery());

final dhabaSorterProvider = StateProvider<DhabaSorter>((ref) => const DistanceSorter());

final dhabaListProvider = FutureProvider<List<DhabaModel>>((ref) async {
  final repository = ref.watch(dhabaRepositoryProvider);
  final query = ref.watch(dhabaSearchQueryProvider);
  final sorter = ref.watch(dhabaSorterProvider);

  final rawList = await repository.searchDhabas(query);
  return sorter.sort(rawList);
});
