import 'package:flutter/material.dart';
import 'package:maps_app/services/services.dart';

import '../models/list_model.dart';

class RouteListScreen extends StatelessWidget {
  const RouteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de ítems de ejemplo
    final items = List<String>.generate(20, (index) => 'Ítem $index');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Rutas'),
      ),
      body: FutureBuilder<List<ListModel>>(
          future: TrafficService().getRoutesList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final item = snapshot.data?[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text("${item?.title}"),
                    onTap: () {
                      // Acción al tocar el ítem
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Seleccionaste $item')),
                      );
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}
