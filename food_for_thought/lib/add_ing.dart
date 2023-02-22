import 'package:flutter/material.dart';

class Ingredient {
  String name;
  String measurement;

  Ingredient({required this.name, required this.measurement});
}

class IngredientList {
  List<Ingredient> _ingredients = [];

  void addIngredient(Ingredient ingredient) {
    _ingredients.add(ingredient);
  }

  List<Ingredient> get ingredients => _ingredients;
}

class AddIngredientPage extends StatefulWidget {
  final IngredientList ingredientList;

  AddIngredientPage({required this.ingredientList});

  @override
  // ignore: library_private_types_in_public_api
  _AddIngredientPageState createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _measurementController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _measurementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ingredient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ingredient Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ingredient name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _measurementController,
                decoration: InputDecoration(labelText: 'Measurement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a measurement';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final measurement = _measurementController.text;
                    widget.ingredientList.addIngredient(
                        Ingredient(name: name, measurement: measurement));
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Ingredient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientPage extends StatefulWidget {
  final IngredientList ingredientList;

  IngredientPage({required this.ingredientList});

  @override
  // ignore: library_private_types_in_public_api
  _IngredientPageState createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredients'),
      ),
      body: ListView.builder(
        itemCount: widget.ingredientList.ingredients.length,
        itemBuilder: (context, index) {
          final ingredient = widget.ingredientList.ingredients[index];
          return ListTile(
            title: Text(ingredient.name),
            subtitle: Text(ingredient.measurement),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddIngredientPage(ingredientList: widget.ingredientList)),
          );
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
