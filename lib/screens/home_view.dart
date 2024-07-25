import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ticket/flutter_ticket.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/models/list_model.dart';
import 'package:maps_app/screens/map_screen.dart';
import 'package:maps_app/themes/colores.dart';

import '../blocs/location/location_bloc.dart';
import '../services/traffic_service.dart';
import 'add_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _Header(),
            const SizedBox(height: 10),
            // const SearchRoute(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                // padding: EdgeInsets.all(8.0),
                child: _ListRouter(),
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colores.yellow,
        onPressed: () => Navigator.pushNamed(context, "add"),
        label: const Row(
          children: [
            Icon(Icons.add),
            Text("Ruta"),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Titulo aqui oh logo",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colores.yellow,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  "https://static.vecteezy.com/system/resources/previews/019/495/169/non_2x/woman-girl-avatar-user-person-long-hair-pink-clothing-colored-outline-style-vector.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colores.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.notifications_active,
                        color: Colores.white,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: -1,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colores.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ListRouter extends StatelessWidget {
  _ListRouter();

  late LocationBloc locationBloc;

  @override
  Widget build(BuildContext context) {
    locationBloc = BlocProvider.of<LocationBloc>(context);
    DateFormat format = DateFormat('HH:mm', 'es_ES');
    TextStyle titleStyle =
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0);
    return FutureBuilder<List<ListModel>>(
        future: TrafficService().getRoutesList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final list = snapshot.data ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext contex, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      locationBloc.startFollowingUser(
                        LatLng(list[index].startLatitude,
                            list[index].startLongitude),
                      );
                      final destination =
                          await BlocProvider.of<SearchBloc>(context)
                              .getCoorsStartToEnd(
                                  LatLng(list[index].startLatitude,
                                      list[index].startLongitude),
                                  LatLng(list[index].destinationLatitude,
                                      list[index].destinationLongitude));
                      BlocProvider.of<MapBloc>(context)
                          .drawRoutePolyline(destination);

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => MapScreen()));
                    },
                    child: Ticket(
                      innerRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      outerRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 4.0),
                          blurRadius: 2.0,
                          spreadRadius: 2.0,
                          color: Color.fromRGBO(196, 196, 196, .76),
                        )
                      ],
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colores.white,
                        ),
                        // title: Text(routerMapList[index].title),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    format.format(DateTime.now()),
                                    style: titleStyle,
                                  ),
                                  const Text("Om 35 min"),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(list[index].title),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colores.yellow,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AddListView(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Colores.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        });
  }
}

class SearchRoute extends StatefulWidget {
  const SearchRoute({super.key});

  @override
  State<SearchRoute> createState() => _SearchRouteState();
}

class _SearchRouteState extends State<SearchRoute> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 200,
      decoration: BoxDecoration(
        color: Colores.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4.0),
            blurRadius: 2.0,
            spreadRadius: 2.0,
            color: Color.fromRGBO(196, 196, 196, .76),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Inicio',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colores.yellow,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colores.yellow, width: 0.3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colores.yellow, width: 0.3),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.gps_fixed,
                      color: Colores.yellow,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.close,
                      color: Colores.yellow,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un precio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Destino',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colores.yellow,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colores.yellow, width: 0.3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colores.yellow, width: 0.3),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.room_outlined,
                      color: Colores.yellow,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.import_export_outlined,
                      color: Colores.yellow,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un precio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colores.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("14:00",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colores.black,
                          )),
                      Icon(
                        Icons.access_time,
                        color: Colores.black.withOpacity(0.6),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
