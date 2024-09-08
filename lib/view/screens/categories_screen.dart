import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CategoriesScreen
 extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
  static List<String> getCategories() {
    return _CategoriesScreenState.categories;
  }
}
class _CategoriesScreenState extends State<
CategoriesScreen> {
  static List<String> categories = [];
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categories[index]),
                onTap: () {
                  _showOptionsDialog(context, index);
                },
              );
            },
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                _showCreateCategoryDialog(context);
              },
              child: const Text('Add Category'),
            ),
          ),
        ],
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
                  _saveCategories();
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
  void _showOptionsDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showEditCategoryDialog(context, index);
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    categories.removeAt(index);
                    _saveCategories();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }
  void _showEditCategoryDialog(BuildContext context, int index) {
    String editedCategory = categories[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            onChanged: (value) {
              editedCategory = value;
            },
            controller: TextEditingController(text: editedCategory),
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
                  categories[index] = editedCategory;
                  _saveCategories();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('categories', categories);
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      categories = prefs.getStringList('categories') ?? [];
    });
  }
}
