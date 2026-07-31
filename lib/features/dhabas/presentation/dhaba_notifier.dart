import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/dhaba_model.dart';
import '../domain/dhaba_repository.dart';
import '../domain/dhaba_search_query.dart';
import '../domain/dhaba_sorter.dart';
import '../data/dhaba_repository_impl.dart';

final dhabaRepositoryProvider = Provider<DhabaRepository>((ref) => DhabaRepositoryImpl());

final dhabaSearchQueryProvider = StateProvider<DhabaSearchQuery>((ref) => const DhabaSearchQuery());

final dhabaSorterProvider = StateProvider<DhabaSorter>((ref) => const DistanceSorter());

final dhabaListProvider = FutureProvider<List<DhabaModel>>((ref) async {
  final repository = ref.watch(dhabaRepositoryProvider);
  final query = ref.watch(dhabaSearchQueryProvider);
  final sorter = ref.watch(dhabaSorterProvider);

  final rawList = await repository.searchDhabas(query);
  return sorter.sort(rawList);
});
