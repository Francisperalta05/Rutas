import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';

import 'package:maps_app/services/services.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'screens/add_list_view.dart';
import 'screens/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => LocationBloc()),
      BlocProvider(
          create: (context) =>
              MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
      BlocProvider(
          create: (context) => SearchBloc(trafficService: TrafficService()))
    ],
    child: const MapsApp(),
  ));
}

class MapsApp extends StatelessWidget {
  const MapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MapsApp',
        // home: LoadingScreen(),
        home: HomeView(),
        routes: {
          "home": (BuildContext context) => const HomeView(),
          "add": (BuildContext context) => const AddListView(),
        },
      ),
    );
  }
}
