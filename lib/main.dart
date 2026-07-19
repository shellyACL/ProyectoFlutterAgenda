import 'package:agenda_part1/controller/tarea_controller.dart';
import 'package:agenda_part1/controller/tipo_act_controller.dart';
import 'package:agenda_part1/presentation/screens/materia/list_mat.dart';
import 'package:agenda_part1/presentation/screens/programa/list_prog.dart';
import 'package:agenda_part1/presentation/screens/tarea/list_tar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agenda_part1/presentation/screens/institucion/list_ins.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Agenda',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TareaController _tareaController = Get.put(TareaController());
    final TipoActController _tipoActController = Get.put(TipoActController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              _tareaController.loadTarea();
              _tipoActController.loadTipoAct();

              final tareas = _tareaController.tareas;
              final tipos = _tipoActController.tiposAct;

              if (tipos.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: const Text(
                    'No hay tipos de actividad configurados',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen de tareas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: tipos.map((tipo) {
                        final count = tareas
                            .where((t) => t.tipoAct?.idTipoAct == tipo.idTipoAct)
                            .length;
                        return _buildResumenItem(
                          icon: _getIconForTipo(tipo.nombreTipoAct),
                          label: tipo.nombreTipoAct,
                          count: count,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            Row(
              children: [
                _buildNavButton(
                  context: context,
                  label: 'Instituciones',
                  icon: Icons.business,
                  onPressed: () => Get.to(() => const InstitucionList()),
                ),
                const SizedBox(width: 12),
                _buildNavButton(
                  context: context,
                  label: 'Programas',
                  icon: Icons.school,
                  onPressed: () => Get.to(() => const ProgramaList()),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildNavButton(
                  context: context,
                  label: 'Materias',
                  icon: Icons.book,
                  onPressed: () => Get.to(() => const MateriaList()),
                ),
                const SizedBox(width: 12),
                _buildNavButton(
                  context: context,
                  label: 'Tareas',
                  icon: Icons.assignment_turned_in,
                  onPressed: () => Get.to(() => const TareaList()),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Text(
                    'Espacio para animaciones\n(próximamente)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenItem({
    required IconData icon,
    required String label,
    required int count,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 4),
        Text(
          '$count $label',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  IconData _getIconForTipo(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('examen') || lower.contains('exámen')) {
      return Icons.school;
    } else if (lower.contains('resumen')) {
      return Icons.description;
    } else if (lower.contains('tarea')) {
      return Icons.assignment;
    } else {
      return Icons.label;
    }
  }

  Widget _buildNavButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}