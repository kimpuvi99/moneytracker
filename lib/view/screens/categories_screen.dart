import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends
 State<CategoriesScreen> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Cargar categorías al iniciar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showCreateCategoryDialog(context);
              },
              child: const Text('Add Category'),
            ),
            // Aquí mostramos la lista de categorías
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(categories[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCategoryDialog(BuildContext context) {
    String newCategory = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            onChanged: (value) {
              newCategory = value;
            },
            decoration: const InputDecoration(hintText: 'Category name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  categories.add(newCategory);
                  _saveCategories(); // Guardar categorías después de agregar una nueva
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Función para guardar las categorías en Shared Preferences
  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('categories', categories);
  }

  // Función para cargar las categorías desde Shared Preferences
  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      categories = prefs.getStringList('categories') ?? []; // Si no hay categorías guardadas, inicializar con una lista vacía
    });
  }
}
