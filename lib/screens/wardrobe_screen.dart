import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wardrove_provider.dart';
import '../models/clothing.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  String _selectedCategory = 'Todos';

  final List<String> _categories = [
    'Todos',
    'Camisetas',
    'Sneakers',
    'Chaquetas',
    'Pantalones',
    'Accesorios',
  ];

  void _showAddClothingDialog(BuildContext context) {
    final nameController = TextEditingController();
    String selectedCategory = 'Camisetas';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Añadir prenda',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la prenda',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children:
                        [
                              'Camisetas',
                              'Sneakers',
                              'Chaquetas',
                              'Pantalones',
                              'Accesorios',
                            ]
                            .map(
                              (cat) => ChoiceChip(
                                label: Text(cat),
                                selected: selectedCategory == cat,
                                onSelected: (_) =>
                                    setModalState(() => selectedCategory = cat),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Tomar foto y guardar'),
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isEmpty) return;
                        Navigator.pop(ctx);
                        await context
                            .read<WardrobeProvider>()
                            .addClothingWithCamera(
                              name: name,
                              category: selectedCategory,
                            );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wardrobeProvider = context.watch<WardrobeProvider>();
    // Aquí se obtienen todas las prendas (API + Usuario) filtradas por categoría
    final items = wardrobeProvider.getByCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Guardarropa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              wardrobeProvider.randomizeOutfit();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🎲 Outfit aleatorio generado')),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final cat = _categories[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    // Estilo del texto dinámico basado en el tema
                    labelStyle: TextStyle(
                      color: cat == _selectedCategory
                          ? Theme.of(context)
                                .cardColor // Color claro cuando seleccionado
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    selected: cat == _selectedCategory,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    // Color de fondo cuando está seleccionado (Oscuro según tus temas)
                    selectedColor: Theme.of(context).colorScheme.onSurface,
                    // Color de fondo cuando NO está seleccionado
                    backgroundColor: Theme.of(context).cardColor,
                    // Elimina el borde si deseas un look más limpio
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checkroom,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay prendas disponibles',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: items.length,
              itemBuilder: (_, index) => _ClothingCard(item: items[index]),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddClothingDialog(context),
        backgroundColor: Theme.of(context).cardColor,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Nueva Prenda'),
      ),
    );
  }
}

class _ClothingCard extends StatelessWidget {
  final Clothing item;
  const _ClothingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WardrobeProvider>();
    final isFav = provider.isFavourite(item);

    return GestureDetector(
      onTap: () => provider.setSuggestedOutfit(item),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: item.isFromApi
                    ? Image.network(
                        item.imagePath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      )
                    : Image.file(
                        File(item.imagePath),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 4, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => provider.toggleFavouriteOutfit(item),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pinkAccent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => provider.removeClothing(item),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
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
