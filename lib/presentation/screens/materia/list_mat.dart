import 'package:agenda_part1/controller/materia_controller.dart';
import 'package:agenda_part1/controller/horario_controller.dart';
import 'package:agenda_part1/presentation/screens/materia/new_mat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MateriaList extends StatefulWidget {
  const MateriaList({super.key});

  @override
  State<MateriaList> createState() => _MateriaListState();
}

class _MateriaListState extends State<MateriaList> {
  final MateriaController controller = Get.put(MateriaController());
  final HorarioController horarioController = Get.put(HorarioController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.materias.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No hay materias',
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
          itemCount: controller.materias.length,
          itemBuilder: (context, index) {
            final item = controller.materias[index];
            final horariosMateria = horarioController.horarios
                .where((h) => h.materia?.idMateria == item.idMateria)
                .toList();

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            item.nombreMateria.isNotEmpty
                                ? item.nombreMateria[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nombreMateria,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Inst: ${item.institucion?.nombreIns ?? "Sin inst."} | '
                                'Resp: ${item.responsable?.nombreResponsable ?? "Sin resp."}',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue.shade700),
                              onPressed: () {
                                Get.to(() => MateriaAdd(materiaParaEditar: item));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red.shade400),
                              onPressed: () {
                                controller.deleteMateria(item.idMateria!);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (horariosMateria.isEmpty)
                      Text(
                        'Sin horarios asignados',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: horariosMateria.map((horario) {
                          return Chip(
                            avatar: Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.blue.shade700,
                            ),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                            backgroundColor: Colors.blue.shade50,
                            label: Text(
                              '${horario.diaHorario}: ${horario.iniHorario} - ${horario.finHorario}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
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
          Get.to(() => const MateriaAdd());
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}