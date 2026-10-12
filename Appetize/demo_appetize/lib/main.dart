import 'package:flutter/material.dart';

void main() {
  runApp(const StreetwearApp());
}

class StreetwearApp extends StatelessWidget {
  const StreetwearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pepeyo Store - Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: Colors.deepOrangeAccent,
          secondary: Colors.amberAccent,
          surface: const Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
      ),
      home: const CatalogoScreen(),
    );
  }
}

class Producto {
  final String nombre;
  final String categoria;
  final String precio;
  final String imagen;
  final String descripcion;

  Producto({
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.imagen,
    required this.descripcion,
  });
}

class ItemCarrito {
  final Producto producto;
  final String talla;

  ItemCarrito({required this.producto, required this.talla});
}

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final List<ItemCarrito> _carrito = [];

  final List<Producto> productos = [
    p(
      'Bad Bunny Forum Low',
      'Footwear / Collab',
      '\$3,899 MXN',
      'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500',
      'Edición especial con diseño acolchado, doble lengüeta y hebilla ajustable.',
    ),
    p(
      'Oversized Boxy Hoodie',
      'Streetwear / Apparel',
      '\$1,250 MXN',
      'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=500',
      'Sudadera de algodón pesado de 450 GSM con corte boxy y caída relajada.',
    ),
    p(
      'Nike Air Monarch Retro',
      'Classic / Dad Shoes',
      '\$1,699 MXN',
      'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500',
      'Máxima comodidad con amortiguación de aire y suela chunky icónica.',
    ),
    p(
      'Cargo Techwear Pants',
      'Bottoms / Utility',
      '\$1,450 MXN',
      'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=500',
      'Pantalón utilitario con múltiples bolsillos profundos y cinchas ajustables.',
    ),
  ];

  static Producto p(String n, String c, String p, String i, String d) {
    return Producto(nombre: n, categoria: c, precio: p, imagen: i, descripcion: d);
  }

  void _mostrarCarrito(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🛒 Tu Carrito de Compras',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 20),
                  _carrito.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text(
                              'El carrito está vacío',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _carrito.length,
                            itemBuilder: (context, index) {
                              final item = _carrito[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.producto.imagen,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(item.producto.nombre),
                                subtitle: Text('Talla: ${item.talla} • ${item.producto.precio}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () {
                                    setState(() {
                                      _carrito.removeAt(index);
                                    });
                                    setModalState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _carrito.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('¡Compra simulada con éxito! 🎉')),
                            );
                            setState(() {
                              _carrito.clear();
                            });
                          },
                    child: Text('Finalizar Compra (${_carrito.length} ítems)'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 STREETPEPYO VIRTUAL'),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => _mostrarCarrito(context),
              ),
              if (_carrito.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_carrito.length}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepOrange, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXCLUSIVO APPETIZE DEMO',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                SizedBox(height: 8),
                Text(
                  'Oversized & Sneakers Drop',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Simulación en la nube lista para pruebas técnicas.'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Catálogo Destacado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...productos.map((prod) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                child: InkWell(
                  onTap: () async {
                    final agregado = await Navigator.push<ItemCarrito>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleProductoScreen(producto: prod),
                      ),
                    );
                    if (agregado != null) {
                      setState(() {
                        _carrito.add(agregado);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('¡${prod.nombre} añadido al carrito!')),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Image.network(
                        prod.imagen,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prod.categoria.toUpperCase(),
                                style: const TextStyle(fontSize: 10, color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                prod.nombre,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                prod.precio,
                                style: const TextStyle(fontSize: 14, color: Colors.amberAccent),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class DetalleProductoScreen extends StatefulWidget {
  final Producto producto;

  const DetalleProductoScreen({super.key, required this.producto});

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  String tallaSeleccionada = 'M / 27cm';
  final List<String> tallas = ['S / 26cm', 'M / 27cm', 'L / 28cm', 'XL / 29cm'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.producto.nombre)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.producto.imagen,
              height: 280,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.producto.categoria,
                    style: const TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.producto.nombre,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.producto.precio,
                    style: const TextStyle(fontSize: 20, color: Colors.amberAccent, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Descripción:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.producto.descripcion,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Selecciona Talla / Medida:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: tallas.map((talla) {
                      bool isSelected = tallaSeleccionada == talla;
                      return ChoiceChip(
                        label: Text(talla),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            tallaSeleccionada = talla;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      final item = ItemCarrito(
                        producto: widget.producto,
                        talla: tallaSeleccionada,
                      );
                      Navigator.pop(context, item);
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Añadir al Carrito', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}