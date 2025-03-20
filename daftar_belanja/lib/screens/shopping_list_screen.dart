import 'package:daftar_belanja/services/shopping_services.dart';
import 'package:flutter/material.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _controller = TextEditingController();
  final ShoppingServices _shoppingServices = ShoppingServices();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Belanja'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: 
                        const InputDecoration(hintText: 'Masukan nama barang'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _shoppingServices.addShoppingItem(_controller.text);
                      _controller.clear();
                    }, 
                    icon: const Icon(Icons.add)
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<Map<String, String>>(
              stream: _shoppingServices.getShoppingList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, String> items = snapshot.data!;
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final key = items.keys.elementAt(index);
                      final item = items[key];
                      return ListTile(
                        title: Text(item!),
                        trailing: IconButton(
                          onPressed: () {
                            _shoppingServices.removeShoppingItem(key);
                          }, 
                          icon: const Icon(Icons.delete)
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ),
        ],
      ),
    );
  }
}