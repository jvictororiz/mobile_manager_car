import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_manager_car/data/datasource/firebase/car_firebase_service.dart';
import 'package:mobile_manager_car/data/repository/user_repository.dart';
import 'package:mobile_manager_car/domain/usecase/car_usecase.dart';
import 'package:mobile_manager_car/domain/usecase/user_usecase.dart';

import '../../data/datasource/firebase/driver_firebase_service.dart';
import '../../data/datasource/firebase/historic_firebase_service.dart';
import '../../data/datasource/firebase/metric_firebase_service.dart';
import '../../data/datasource/firebase/reminder_firebase_service.dart';
import '../../data/datasource/firebase/user_firebase_service.dart';
import '../../data/datasource/preferences/Preferences.dart';
import '../../data/repository/car_repository.dart';
import '../../data/repository/driver_repository.dart';
import '../../data/repository/historic_repository.dart';
import '../../data/repository/metric_repository.dart';
import '../../data/repository/reminder_repository.dart';
import '../../domain/usecase/driver_usecase.dart';
import '../../domain/usecase/historic_usecase.dart';
import '../../domain/usecase/metric_usecase.dart';
import '../../domain/usecase/reminder_rent_values_usecase.dart';
import '../../domain/usecase/reminder_usecase.dart';
import '../../presentation/pages/authentication/controller/login_controller.dart';
import '../../presentation/pages/authentication/controller/register_controller.dart';
import '../../presentation/pages/car/controller/list_car_controller.dart';
import '../../presentation/pages/car/controller/register_car_controller.dart';
import '../../presentation/pages/driver/controller/list_driver_controller.dart';
import '../../presentation/pages/driver/controller/register_driver_controller.dart';
import '../../presentation/pages/home/controller/home_controller.dart';
import '../../presentation/pages/profile/controller/profile_controller.dart';
import '../../presentation/pages/timelineCar/controller/add_timeline_controller.dart';
import '../../presentation/pages/timelineCar/controller/timeline_controller.dart';

class Module {
  static void init() {
    GetIt getIt = GetIt.instance;

    //preferences
    getIt.registerLazySingleton<Preferences>(() => Preferences());

    //firebase
    getIt.registerFactory(() => FirebaseAuth.instance);
    getIt.registerFactory(() => FirebaseStorage.instance);
    getIt.registerFactory(() => FirebaseDatabase.instance);

    //dataSource
    getIt.registerLazySingleton<UserFirebaseService>(() => UserFirebaseService(getIt()));
    getIt.registerLazySingleton<CarFirebaseService>(() => CarFirebaseService(getIt(), getIt(), getIt(), getIt()));
    getIt.registerLazySingleton<DriverFirebaseService>(() => DriverFirebaseService(getIt(), getIt(), getIt()));
    getIt.registerLazySingleton<HistoricFirebaseService>(() => HistoricFirebaseService(getIt(), getIt()));
    getIt.registerLazySingleton<MetricFirebaseService>(() => MetricFirebaseService(getIt(), getIt()));
    getIt.registerLazySingleton<ReminderFirebaseService>(() => ReminderFirebaseService(getIt(), getIt()));

    //repository
    getIt.registerLazySingleton<UserRepository>(() => UserRepository(getIt()));
    getIt.registerLazySingleton<CarRepository>(() => CarRepository(getIt()));
    getIt.registerLazySingleton<DriverRepository>(() => DriverRepository(getIt()));
    getIt.registerLazySingleton<HistoricRepository>(() => HistoricRepository(getIt()));
    getIt.registerLazySingleton<MetricRepository>(() => MetricRepository(getIt()));
    getIt.registerLazySingleton<ReminderRepository>(() => ReminderRepository(getIt()));

    //usecase
    getIt.registerLazySingleton<UserUseCase>(() => UserUseCase(getIt()));
    getIt.registerLazySingleton<CarUseCase>(() => CarUseCase(getIt()));
    getIt.registerLazySingleton<DriverUseCase>(() => DriverUseCase(getIt()));
    getIt.registerLazySingleton<HistoricUseCase>(() => HistoricUseCase(getIt()));
    getIt.registerLazySingleton<MetricUseCase>(() => MetricUseCase(getIt()));
    getIt.registerLazySingleton<ReminderUseCase>(() => ReminderUseCase(getIt()));
    getIt.registerLazySingleton<ReminderRentValuesUseCase>(() => ReminderRentValuesUseCase());

    //controller
    getIt.registerFactory<LoginController>(() => LoginController(getIt(), getIt()));
    getIt.registerFactory<RegisterController>(() => RegisterController(getIt(), getIt()));
    getIt.registerFactory<RegisterCarController>(() => RegisterCarController(getIt(), getIt()));
    getIt.registerFactory<ListCarController>(() => ListCarController(getIt(), getIt(), getIt()));
    getIt.registerFactory<ListDriverController>(() => ListDriverController(getIt()));
    getIt.registerFactory<RegisterDriverController>(() => RegisterDriverController(getIt(), getIt()));
    getIt.registerFactory<HomeController>(() => HomeController(getIt(), getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory<TimelineController>(() => TimelineController(getIt()));
    getIt.registerFactory<AddTimelineController>(() => AddTimelineController(getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory<ProfileController>(() => ProfileController(getIt()));
  }
}
