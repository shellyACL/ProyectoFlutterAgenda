import 'package:agenda_part1/controller/materia_controller.dart';
import 'package:agenda_part1/controller/tarea_controller.dart';
import 'package:agenda_part1/controller/tipo_act_controller.dart';
import 'package:agenda_part1/infrastructure/models/tarea_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TareaAdd extends StatefulWidget {
  final Tarea? tareaParaEditar;
  const TareaAdd({super.key, this.tareaParaEditar});

  @override
  State<TareaAdd> createState() => _TareaAddState();
}

class _TareaAddState extends State<TareaAdd> {
  final TareaController _tareaController = Get.find<TareaController>();
  final MateriaController _materiaController = Get.put(MateriaController());
  final TipoActController _tipoActController = Get.put(TipoActController());

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _notaObtenidaController = TextEditingController();
  final TextEditingController _ponderacionController = TextEditingController();
  final TextEditingController _fechaEntregaController = TextEditingController();

  String? _selectedMateriaId;
  String? _selectedTipoActId;
  String _selectedEstado = 'Pendiente';

  bool _isEditing = false;

  final List<String> _estadosDisponibles = [
    'Pendiente',
    'En progreso',
    'Completada',
    'Cancelada',
  ];

  @override
  void initState() {
    super.initState();

    _materiaController.loadMateria();
    _tipoActController.loadTipoAct();

    if (widget.tareaParaEditar != null) {
      _isEditing = true;
      final t = widget.tareaParaEditar!;
      _nombreController.text = t.nombreTarea;
      _descripcionController.text = t.descTarea ?? '';
      _fechaEntregaController.text = t.fechaEntTarea ?? '';
      _notaObtenidaController.text = t.notaObtenida?.toString() ?? '';
      _ponderacionController.text = t.ponderacion?.toString() ?? '';
      _selectedEstado = t.estadoTarea;
      _selectedMateriaId = t.materia?.idMateria;
      _selectedTipoActId = t.tipoAct?.idTipoAct;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Tarea' : 'Nueva Tarea'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                _isEditing
                    ? 'Modifica los datos de la tarea'
                    : 'Ingresa los datos de la nueva tarea',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la tarea *',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.assignment, color: Colors.blue.shade700),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción (opcional)',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.description, color: Colors.blue.shade700),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      _fechaEntregaController.text =
                          date.toIso8601String().split('T').first;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _fechaEntregaController,
                    decoration: InputDecoration(
                      labelText: 'Fecha de entrega (opcional)',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedEstado,
                decoration: InputDecoration(
                  labelText: 'Estado *',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.flag, color: Colors.blue.shade700),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                ),
                items: _estadosDisponibles.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEstado = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _notaObtenidaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Nota obtenida (opcional)',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.numbers, color: Colors.blue.shade700),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _ponderacionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Ponderación (opcional)',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.percent, color: Colors.blue.shade700),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Obx(() {
                if (_materiaController.materias.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedMateriaId,
                  decoration: InputDecoration(
                    labelText: 'Materia *',
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.book, color: Colors.blue.shade700),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                    ),
                  ),
                  items: _materiaController.materias.map((m) {
                    return DropdownMenuItem(
                      value: m.idMateria,
                      child: Text(m.nombreMateria),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMateriaId = value;
                    });
                  },
                );
              }),
              const SizedBox(height: 16),

              Obx(() {
                if (_tipoActController.tiposAct.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedTipoActId,
                  decoration: InputDecoration(
                    labelText: 'Tipo de actividad *',
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.label, color: Colors.blue.shade700),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                    ),
                  ),
                  items: _tipoActController.tiposAct.map((t) {
                    return DropdownMenuItem(
                      value: t.idTipoAct,
                      child: Text(t.nombreTipoAct),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTipoActId = value;
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
                  label: Text(_isEditing ? 'Actualizar Cambios' : 'Guardar Tarea'),
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
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _guardar() async {
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) {
      Get.snackbar(
        'Error',
        'El nombre de la tarea es obligatorio',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (_selectedMateriaId == null) {
      Get.snackbar(
        'Error',
        'Seleccione una materia',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (_selectedTipoActId == null) {
      Get.snackbar(
        'Error',
        'Seleccione un tipo de actividad',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    final materia = _materiaController.materias
        .firstWhere((m) => m.idMateria == _selectedMateriaId!);
    final tipoAct = _tipoActController.tiposAct
        .firstWhere((t) => t.idTipoAct == _selectedTipoActId!);

    int? notaObtenida = int.tryParse(_notaObtenidaController.text.trim());
    int? ponderacion = int.tryParse(_ponderacionController.text.trim());
    final fechaEntrega = _fechaEntregaController.text.trim().isEmpty
        ? null
        : _fechaEntregaController.text.trim();

    if (_isEditing) {
      final tareaEditada = Tarea(
        idTarea: widget.tareaParaEditar!.idTarea,
        nombreTarea: nombre,
        descTarea: _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
        fechaCreaTarea: widget.tareaParaEditar!.fechaCreaTarea,
        fechaEntTarea: fechaEntrega,
        estadoTarea: _selectedEstado,
        notaObtenida: notaObtenida,
        ponderacion: ponderacion,
        materia: materia,
        tipoAct: tipoAct,
      );
      await _tareaController.updateTarea(tareaEditada);
    } else {
      await _tareaController.addTarea(
        nombreTarea: nombre,
        descTarea: _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
        fechaEntTarea: fechaEntrega,
        estadoTarea: _selectedEstado,
        notaObtenida: notaObtenida,
        ponderacion: ponderacion,
        materia: materia,
        tipoAct: tipoAct,
      );
    }

    Get.back();
  }
}