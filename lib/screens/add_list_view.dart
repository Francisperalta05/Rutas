// import 'package:app_ruta/model/list_route_map_model.dart';
// import 'package:app_ruta/provider/home_provider.dart';
import 'package:flutter/material.dart';

import '../models/list_route_map_model.dart';
import '../themes/colores.dart';
import 'home_view.dart';

class AddListView extends StatefulWidget {
  const AddListView({super.key});

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<AddListView> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para cada campo del formulario
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de RouterMap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Expanded(
            child: ListView(
              children: [
                // Campo para el título
                SearchRoute(),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Titulo',
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
                  ),
                  controller: _titleController,
                  // decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                // Campo para el subtítulo
                TextFormField(
                  controller: _subTitleController,
                  decoration: InputDecoration(
                    hintText: 'SubTitulo',
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un subtítulo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // Campo para el precio
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: 'Precio',
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
                ListTile(
                  title: const Text('Fecha'),
                  subtitle:
                      Text(_selectedDate.toLocal().toString().split(' ')[0]),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final title = _titleController.text;
                      final subTitle = _subTitleController.text;
                      final price = int.parse(_priceController.text);

                      ListRouterMap newRouterMap = ListRouterMap(
                        price,
                        title: title,
                        subTitle: subTitle,
                        time: _selectedDate,
                      );
                      // homeProvider.saveItem(newRouterMap);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Datos guardados: ${newRouterMap.title}')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
