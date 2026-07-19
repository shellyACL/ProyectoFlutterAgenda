import 'package:agenda_part1/controller/institucion_controller.dart';
import 'package:agenda_part1/infrastructure/models/institucion_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstitucionAdd extends StatefulWidget {
  final Institucion? institucionParaEditar;

  const InstitucionAdd({super.key, this.institucionParaEditar});

  @override
  State<InstitucionAdd> createState() => _InstitucionAddState();
}

class _InstitucionAddState extends State<InstitucionAdd> {
  final InstitutionController controller = Get.find<InstitutionController>();

  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController tipoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.institucionParaEditar != null) {
      nombreCtrl.text = widget.institucionParaEditar!.nombreIns;
      tipoCtrl.text = widget.institucionParaEditar!.tipoIns;
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    tipoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = widget.institucionParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Institución' : 'Nueva Institución'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              esEditar ? 'Modifica los datos de la institución' : 'Ingresa los datos de la nueva institución',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(
                labelText: 'Nombre de la Institución',
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.business, color: Colors.blue.shade700),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: tipoCtrl,
              decoration: InputDecoration(
                labelText: 'Tipo (Ej: Universidad, Colegio)',
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.category, color: Colors.blue.shade700),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (nombreCtrl.text.trim().isEmpty || tipoCtrl.text.trim().isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Todos los campos son obligatorios',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                      colorText: Colors.red.shade900,
                    );
                    return;
                  }

                  if (esEditar) {
                    final institucionModificada = Institucion(
                      idIns: widget.institucionParaEditar!.idIns,
                      nombreIns: nombreCtrl.text.trim(),
                      tipoIns: tipoCtrl.text.trim(),
                    );
                    await controller.updateInstitucion(institucionModificada);
                  } else {
                    await controller.addInstitucion(
                      nombre: nombreCtrl.text.trim(),
                      tipo: tipoCtrl.text.trim(),
                    );
                  }

                  Get.back();
                },
                icon: Icon(esEditar ? Icons.save : Icons.add),
                label: Text(esEditar ? 'Actualizar Cambios' : 'Guardar Institución'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}