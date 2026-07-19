import 'package:agenda_part1/controller/estado_controller.dart';
import 'package:agenda_part1/controller/institucion_controller.dart';
import 'package:agenda_part1/controller/materia_controller.dart';
import 'package:agenda_part1/controller/periodo_controller.dart';
import 'package:agenda_part1/controller/programa_controller.dart';
import 'package:agenda_part1/controller/responsable_controller.dart';
import 'package:agenda_part1/controller/horario_controller.dart';
import 'package:agenda_part1/infrastructure/models/materia_model.dart';
import 'package:agenda_part1/infrastructure/models/responsable_model.dart';
import 'package:agenda_part1/infrastructure/models/horario_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MateriaAdd extends StatefulWidget {
  final Materia? materiaParaEditar;
  const MateriaAdd({super.key, this.materiaParaEditar});

  @override
  State<MateriaAdd> createState() => _MateriaAddState();
}

class _MateriaAddState extends State<MateriaAdd> {
  final MateriaController _materiaController = Get.find<MateriaController>();
  final InstitutionController _institucionController = Get.put(InstitutionController());
  final ProgramaController _programaController = Get.put(ProgramaController());
  final ResponsableController _responsableController = Get.put(ResponsableController());
  final PeriodoController _periodoController = Get.put(PeriodoController());
  final EstadoController _estadoController = Get.put(EstadoController());
  final HorarioController _horarioController = Get.put(HorarioController());

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _notaMinimaController = TextEditingController();
  final TextEditingController _nombreResponsableController = TextEditingController();

  String? _selectedProgramaId;
  String? _selectedInstitucionId;
  String? _selectedResponsableId;
  String? _selectedPeriodoId;
  String? _selectedEstadoId;

  bool _isEditing = false;
  bool _institucionBloqueada = false;

  List<Horario> _horarios = [];

  final List<String> _diasSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

  @override
  void initState() {
    super.initState();

    if (widget.materiaParaEditar != null) {
      _isEditing = true;
      final m = widget.materiaParaEditar!;
      _nombreController.text = m.nombreMateria;
      _notaMinimaController.text = m.notaMinima.toString();
      _selectedInstitucionId = m.institucion?.idIns;
      _selectedResponsableId = m.responsable?.idResponsable;
      if (m.responsable != null) {
        _nombreResponsableController.text = m.responsable!.nombreResponsable;
      }
      _selectedPeriodoId = m.periodo?.idPeriodo;
      _selectedEstadoId = m.estado?.idEstado;
      _institucionBloqueada = _selectedInstitucionId != null;
      _cargarHorariosExistentes(m.idMateria!);
    } else {
      _horarios = [Horario(diaHorario: 'Lunes', iniHorario: '', finHorario: '')];
    }
  }

  void _cargarHorariosExistentes(String idMateria) async {
    final horariosBD = await _horarioController.getHorariosByMateria(idMateria);
    setState(() {
      if (horariosBD.isNotEmpty) {
        _horarios = horariosBD;
      } else {
        _horarios = [Horario(diaHorario: 'Lunes', iniHorario: '', finHorario: '')];
      }
    });
  }

  void _agregarFilaHorario() {
    setState(() {
      _horarios.add(Horario(diaHorario: 'Lunes', iniHorario: '', finHorario: ''));
    });
  }

  void _eliminarFilaHorario(int index) {
    setState(() {
      if (_horarios.length > 1) {
        _horarios.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Materia' : 'Nueva Materia'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                _isEditing ? 'Modifica los datos de la materia' : 'Ingresa los datos de la nueva materia',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la materia',
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
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _notaMinimaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nota mínima *',
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
              const SizedBox(height: 16),

              Obx(() {
                if (_programaController.programas.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedProgramaId,
                  decoration: InputDecoration(
                    labelText: 'Programa (opcional)',
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
                  items: _programaController.programas.map((prog) {
                    return DropdownMenuItem(
                      value: prog.idProg,
                      child: Text(prog.nombreProg),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProgramaId = value;
                      if (value != null) {
                        final programa = _programaController.programas
                            .firstWhere((p) => p.idProg == value);
                        _selectedInstitucionId = programa.institucion?.idIns;
                        _institucionBloqueada = true;
                      } else {
                        _institucionBloqueada = false;
                        _selectedInstitucionId = null;
                      }
                    });
                  },
                );
              }),
              const SizedBox(height: 16),

              Obx(() {
                if (_institucionController.instituciones.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedInstitucionId,
                  decoration: InputDecoration(
                    labelText: 'Institución *',
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
                  onChanged: _institucionBloqueada
                      ? null
                      : (value) {
                          setState(() {
                            _selectedInstitucionId = value;
                          });
                        },
                );
              }),
              const SizedBox(height: 16),

              Obx(() {
                if (_responsableController.responsables.isEmpty) {
                  return TextField(
                    controller: _nombreResponsableController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del responsable (nuevo) *',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.blue.shade700),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                      ),
                    ),
                  );
                } else {
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedResponsableId,
                    decoration: InputDecoration(
                      labelText: 'Responsable *',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.blue.shade700),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                      ),
                    ),
                    items: _responsableController.responsables.map((r) {
                      return DropdownMenuItem(
                        value: r.idResponsable,
                        child: Text(r.nombreResponsable),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedResponsableId = value;
                      });
                    },
                  );
                }
              }),
              const SizedBox(height: 16),

              Obx(() {
                if (_periodoController.periodos.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedPeriodoId,
                  decoration: InputDecoration(
                    labelText: 'Período *',
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                    ),
                  ),
                  items: _periodoController.periodos.map((p) {
                    return DropdownMenuItem(
                      value: p.idPeriodo,
                      child: Text('${p.nombrePeriodo} (${p.diasDurPeriodo} días)'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriodoId = value;
                    });
                  },
                );
              }),
              const SizedBox(height: 16),

              Obx(() {
                if (_estadoController.estados.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedEstadoId,
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
                  items: _estadoController.estados.map((e) {
                    return DropdownMenuItem(
                      value: e.idEstado,
                      child: Text(e.nombreEstado),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedEstadoId = value;
                    });
                  },
                );
              }),

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Horarios de la Materia',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _horarios.length,
                itemBuilder: (context, index) {
                  final horario = _horarios[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            initialValue: horario.diaHorario.isEmpty ? 'Lunes' : horario.diaHorario,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: _diasSemana.map((dia) {
                              return DropdownMenuItem(value: dia, child: Text(dia));
                            }).toList(),
                            onChanged: (val) {
                              setState(() { horario.diaHorario = val ?? 'Lunes'; });
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: horario.iniHorario,
                            decoration: InputDecoration(
                              hintText: '08:00',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            onChanged: (val) => horario.iniHorario = val.trim(),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: horario.finHorario,
                            decoration: InputDecoration(
                              hintText: '10:00',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            onChanged: (val) => horario.finHorario = val.trim(),
                          ),
                        ),
                        if (_horarios.length > 1)
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                            onPressed: () => _eliminarFilaHorario(index),
                          ),
                      ],
                    ),
                  );
                },
              ),

              TextButton.icon(
                onPressed: _agregarFilaHorario,
                icon: Icon(Icons.add, color: Colors.blue.shade700),
                label: Text(
                  'Añadir otro día/hora',
                  style: TextStyle(color: Colors.blue.shade700),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardar,
                  icon: Icon(_isEditing ? Icons.save : Icons.add),
                  label: Text(_isEditing ? 'Actualizar Cambios' : 'Guardar Materia'),
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
        'El nombre es obligatorio',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    final notaMinima = int.tryParse(_notaMinimaController.text);
    if (notaMinima == null) {
      Get.snackbar(
        'Error',
        'Nota mínima debe ser un número',
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

    if (_selectedPeriodoId == null) {
      Get.snackbar(
        'Error',
        'Seleccione un período',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (_selectedEstadoId == null) {
      Get.snackbar(
        'Error',
        'Seleccione un estado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    for (var h in _horarios) {
      if (h.iniHorario.isEmpty || h.finHorario.isEmpty) {
        Get.snackbar(
          'Error',
          'Por favor llena las horas de inicio y fin de todos los horarios',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }
    }

    Responsable responsable;
    if (_responsableController.responsables.isEmpty) {
      final nombreResponsable = _nombreResponsableController.text.trim();
      if (nombreResponsable.isEmpty) {
        Get.snackbar(
          'Error',
          'Ingrese el nombre del responsable',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }
      await _responsableController.addResponsable(nombre: nombreResponsable);
      responsable = _responsableController.responsables.last;
    } else {
      if (_selectedResponsableId == null) {
        Get.snackbar(
          'Error',
          'Seleccione un responsable',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }
      responsable = _responsableController.responsables
          .firstWhere((r) => r.idResponsable == _selectedResponsableId!);
    }

    final institucion = _institucionController.instituciones
        .firstWhere((ins) => ins.idIns == _selectedInstitucionId!);
    final periodo = _periodoController.periodos
        .firstWhere((p) => p.idPeriodo == _selectedPeriodoId!);
    final estado = _estadoController.estados
        .firstWhere((e) => e.idEstado == _selectedEstadoId!);

    if (_isEditing) {
      final mParaEditar = widget.materiaParaEditar!;
      final materiaEditada = Materia(
        idMateria: mParaEditar.idMateria,
        nombreMateria: nombre,
        notaMinima: notaMinima,
        notaAct: mParaEditar.notaAct,
        fechaIni: mParaEditar.fechaIni,
        fechaFin: mParaEditar.fechaFin,
        responsable: responsable,
        institucion: institucion,
        periodo: periodo,
        estado: estado,
      );

      await _materiaController.updateMateria(materiaEditada);
      await _horarioController.saveHorariosForMateria(
        idMateria: mParaEditar.idMateria!,
        horariosNuevos: _horarios,
        materia: materiaEditada,
      );
    } else {
      await _materiaController.addMateria(
        nombreMateria: nombre,
        notaMinima: notaMinima,
        responsable: responsable,
        institucion: institucion,
        periodo: periodo,
        estado: estado,
      );

      final nuevaMateria = _materiaController.materias.last;

      await _horarioController.saveHorariosForMateria(
        idMateria: nuevaMateria.idMateria!,
        horariosNuevos: _horarios,
        materia: nuevaMateria,
      );
    }

    Get.back();
  }
}