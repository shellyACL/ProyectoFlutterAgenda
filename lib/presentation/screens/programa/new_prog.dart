import 'package:agenda_part1/controller/institucion_controller.dart';
import 'package:agenda_part1/controller/programa_controller.dart';
import 'package:agenda_part1/controller/tipo_prog_controller.dart';
import 'package:agenda_part1/infrastructure/models/programa_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgramaAdd extends StatefulWidget {
  final Programa? programaParaEditar;
  const ProgramaAdd({super.key, this.programaParaEditar});

  @override
  State<ProgramaAdd> createState() => _ProgramaAddState();
}

class _ProgramaAddState extends State<ProgramaAdd> {
  final ProgramaController _programaController = Get.find<ProgramaController>();
  final InstitutionController _institucionController = Get.put(InstitutionController());
  final TipoProgController _tipoProgController = Get.put(TipoProgController());

  final TextEditingController _nombreController = TextEditingController();

  String? _selectedInstitucionId;
  String? _selectedTipoProgId;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    if (widget.programaParaEditar != null) {
      _isEditing = true;
      _nombreController.text = widget.programaParaEditar!.nombreProg;
      _selectedInstitucionId = widget.programaParaEditar!.institucion?.idIns;
      _selectedTipoProgId = widget.programaParaEditar!.tipoProg?.idTipoProg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Programa' : 'Nuevo Programa'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              _isEditing
                  ? 'Modifica los datos del programa'
                  : 'Ingresa los datos del nuevo programa',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del programa',
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.school, color: Colors.blue.shade700),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Obx(() {
              if (_institucionController.instituciones.isEmpty) {
                return const CircularProgressIndicator();
              }
              return DropdownButtonFormField<String>(
                initialValue: _selectedInstitucionId,
                decoration: InputDecoration(
                  labelText: 'Institución',
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
                items: _institucionController.instituciones.map((ins) {
                  return DropdownMenuItem(
                    value: ins.idIns,
                    child: Text(ins.nombreIns),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedInstitucionId = value;
                  });
                },
              );
            }),
            const SizedBox(height: 16),

            Obx(() {
              if (_tipoProgController.tiposPrograma.isEmpty) {
                return const CircularProgressIndicator();
              }
              return DropdownButtonFormField<String>(
                initialValue: _selectedTipoProgId,
                decoration: InputDecoration(
                  labelText: 'Tipo de Programa',
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
                items: _tipoProgController.tiposPrograma.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo.idTipoProg,
                    child: Text(tipo.nombreTipoProg),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTipoProgId = value;
                  });
                },
              );
            }),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _guardar,
                icon: Icon(_isEditing ? Icons.save : Icons.add),
                label: Text(_isEditing ? 'Actualizar Cambios' : 'Guardar Programa'),
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

  void _guardar() async {
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) {
      Get.snackbar(
        'Error',
        'El nombre es obligatorio',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (_selectedInstitucionId == null) {
      Get.snackbar(
        'Error',
        'Seleccione una institución',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }
    if (_selectedTipoProgId == null) {
      Get.snackbar(
        'Error',
        'Seleccione un tipo de programa',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    final institucionSeleccionada = _institucionController.instituciones
        .firstWhere((ins) => ins.idIns == _selectedInstitucionId!);
    final tipoProgSeleccionado = _tipoProgController.tiposPrograma
        .firstWhere((tipo) => tipo.idTipoProg == _selectedTipoProgId!);

    if (_isEditing) {
      final programaEditado = Programa(
        idProg: widget.programaParaEditar!.idProg,
        nombreProg: nombre,
        institucion: institucionSeleccionada,
        tipoProg: tipoProgSeleccionado,
      );
      await _programaController.updatePrograma(programaEditado);
    } else {
      await _programaController.addPrograma(
        nombre: nombre,
        ins: institucionSeleccionada,
        tipo: tipoProgSeleccionado,
      );
    }

    Get.back();
  }
}