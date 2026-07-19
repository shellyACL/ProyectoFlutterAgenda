import 'package:agenda_part1/controller/institucion_controller.dart';
import 'package:agenda_part1/presentation/screens/institucion/new_ins.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstitucionList extends StatefulWidget {
  const InstitucionList({super.key});

  @override
  State<InstitucionList> createState() => _InstitucionListState();
}

class _InstitucionListState extends State<InstitucionList> {
  final InstitutionController controller = Get.put(InstitutionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instituciones'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.instituciones.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No hay instituciones',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Presiona el botón + para agregar una',
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
          itemCount: controller.instituciones.length,
          itemBuilder: (context, index) {
            final item = controller.instituciones[index];
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
                    item.nombreIns.isNotEmpty ? item.nombreIns[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  item.nombreIns,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  item.tipoIns,
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
                        Get.to(() => InstitucionAdd(institucionParaEditar: item));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade400),
                      onPressed: () {
                        controller.deleteInstitucion(item.idIns!);
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
          Get.to(() => const InstitucionAdd());
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}