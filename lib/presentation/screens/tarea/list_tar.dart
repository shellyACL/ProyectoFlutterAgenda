import 'package:agenda_part1/controller/tarea_controller.dart';
import 'package:agenda_part1/presentation/screens/tarea/new_tar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TareaList extends StatefulWidget {
  const TareaList({super.key});

  @override
  State<TareaList> createState() => _TareaListState();
}

class _TareaListState extends State<TareaList> {
  final TareaController controller = Get.put(TareaController());

  @override
  void initState() {
    super.initState();
    controller.loadTarea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.tareas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No hay tareas registradas',
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
          itemCount: controller.tareas.length,
          itemBuilder: (context, index) {
            final item = controller.tareas[index];

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
                            item.nombreTarea.isNotEmpty
                                ? item.nombreTarea[0].toUpperCase()
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
                                item.nombreTarea,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Mat: ${item.materia?.nombreMateria ?? "Sin mat."} | '
                                'Tipo: ${item.tipoAct?.nombreTipoAct ?? "Sin tipo."}',
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
                                Get.to(() => TareaAdd(tareaParaEditar: item));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red.shade400),
                              onPressed: () {
                                controller.deleteTarea(item.idTarea!);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estado: ${item.estadoTarea}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    if (item.fechaEntTarea != null && item.fechaEntTarea!.isNotEmpty)
                      Text(
                        'Fecha entrega: ${item.fechaEntTarea}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    if (item.tipoAct?.reqNotaRapidaTipoAct == true) ...[
                      if (item.notaObtenida != null)
                        Text(
                          'Nota: ${item.notaObtenida}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      if (item.ponderacion != null)
                        Text(
                          'Ponderación: ${item.ponderacion}%',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const TareaAdd());
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}