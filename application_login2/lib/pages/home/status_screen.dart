import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/status_provider.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final _nameController = TextEditingController();
  String _selectedColor = '#4CAF50';

  @override
  void initState() {
    super.initState();
    _loadStatuses();
  }

  void _loadStatuses() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final statusProvider = Provider.of<StatusProvider>(context, listen: false);
    statusProvider.loadStatuses(auth.currentUser!.id);
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Estado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del estado',
                hintText: 'Ej: Feliz, Trabajando, etc',
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedColor,
              decoration: const InputDecoration(labelText: 'Color'),
              items: [
                '#4CAF50',
                '#F44336',
                '#2196F3',
                '#FF9800',
                '#9C27B0',
              ].map((color) {
                return DropdownMenuItem(
                  value: color,
                  child: Row(
                    children: [
                      Container(width: 20, height: 20, color: _parseColor(color)),
                      const SizedBox(width: 8),
                      Text(color),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => _selectedColor = v!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty) {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                final statusProvider = Provider.of<StatusProvider>(context, listen: false);
                
                final success = await statusProvider.createStatus(
                  auth.currentUser!.id,
                  _nameController.text,
                  _selectedColor,
                );
                
                if (success && mounted) {
                  Navigator.pop(context);
                  _nameController.clear();
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _deleteStatus(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Eliminar este estado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final statusProvider = Provider.of<StatusProvider>(context, listen: false);
      await statusProvider.deleteStatus(id, auth.currentUser!.id);
    }
  }

  Color _parseColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Estados'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<StatusProvider>(
        builder: (context, statusProvider, child) {
          if (statusProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (statusProvider.statuses.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay estados creados'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: statusProvider.statuses.length,
            itemBuilder: (context, index) {
              final status = statusProvider.statuses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _parseColor(status.color).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.circle,
                      color: _parseColor(status.color),
                      size: 20,
                    ),
                  ),
                  title: Text(status.statusName),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteStatus(status.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}