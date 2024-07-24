import 'package:get_it/get_it.dart';
import 'package:sport_social_mobile_mock/services/data_mock_service.dart';
import 'package:sport_social_mobile_mock/services/live_game_service.dart';

class ServiceLocator {
  static final getIt = GetIt.instance;

  static T get<T extends Object>() {
    return getIt<T>();
  }

  static void setup() {
    getIt.registerSingletonAsync<DataMockService>(
      () async => DataMockService().initialize(),
    );

    getIt.registerSingletonAsync<LiveGameService>(
      () async => LiveGameService().initialize(),
    );
  }
}
