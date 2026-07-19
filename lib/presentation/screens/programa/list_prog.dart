import 'package:agenda_part1/controller/programa_controller.dart';
import 'package:agenda_part1/presentation/screens/programa/new_prog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgramaList extends StatefulWidget {
  const ProgramaList({super.key});

  @override
  State<ProgramaList> createState() => _ProgramaListState();
}

class _ProgramaListState extends State<ProgramaList> {
  final ProgramaController controller = Get.put(ProgramaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programas'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.programas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No hay programas',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Presiona el botón + para agregar uno',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.programas.length,
          itemBuilder: (context, index) {
            final item = controller.programas[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    item.nombreProg.isNotEmpty ? item.nombreProg[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  item.nombreProg,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Institución: ${item.institucion?.nombreIns ?? "Sin institución"} | '
                  'Tipo: ${item.tipoProg?.nombreTipoProg ?? "Sin tipo"}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue.shade700),
                      onPressed: () {
                        Get.to(() => ProgramaAdd(programaParaEditar: item));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade400),
                      onPressed: () {
                        controller.deletePrograma(item.idProg!);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const ProgramaAdd());
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}