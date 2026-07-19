import 'dart:developer';
import 'package:agenda_part1/infrastructure/models/horario_model.dart';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart';
import 'package:agenda_part1/infrastructure/models/materia_model.dart';
import 'package:agenda_part1/infrastructure/models/responsable_model.dart';
import 'package:agenda_part1/infrastructure/models/institucion_model.dart';
import 'package:agenda_part1/infrastructure/models/periodo_model.dart';
import 'package:agenda_part1/infrastructure/models/estado_model.dart';
import 'package:uuid/uuid.dart';

class MateriaController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  var materias = <Materia>[].obs;
  var horariosPorMateria = <String, List<Horario>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadMateria();
  }

  bool _isLoaded = false;

  Future<void> loadMateria() async {
    if (_isLoaded) return;
    try {
      materias.value = await _dbService.getAllMateria();
      _isLoaded = true;
      log("Materias listadas: ${materias.length}");
    } catch (e) {
      log("Error al listar materias: $e");
      materias.value = []; 
      _isLoaded = true;
    }
  }

  Future<void> addMateria({
    required String nombreMateria,
    required int notaMinima,
    required Responsable responsable,
    required Institucion institucion,
    required Periodo periodo,
    required Estado estado,
  }) async {
    try {
      String nuevoId = "MAT-${const Uuid().v4().substring(0, 8).toUpperCase()}";

      final now = DateTime.now();
      final fechaIni = now.toIso8601String().split('T').first; // yyyy-MM-dd
      final fechaFin = now.add(Duration(days: periodo.diasDurPeriodo)).toIso8601String().split('T').first;

      final nuevaMateria = Materia(
        idMateria: nuevoId,
        nombreMateria: nombreMateria,
        fechaIni: fechaIni,
        fechaFin: fechaFin,
        notaMinima: notaMinima,
        notaAct: 0, 
        responsable: responsable,
        institucion: institucion,
        periodo: periodo,
        estado: estado,
      );

      await _dbService.insertMateria(nuevaMateria);
      materias.add(nuevaMateria);
      log("Materia agregada correctamente");
    } catch (e) {
      log("Error al agregar materia: $e");
    }
  }

  Future<void> updateMateria(Materia materiaEditada) async {
    try {
      await _dbService.updateMateria(materiaEditada);

      int index = materias.indexWhere((element) => element.idMateria == materiaEditada.idMateria);
      if (index != -1) {
        materias[index] = materiaEditada;
        materias.refresh();
        log("Materia editada correctamente");
      }
    } catch (e) {
      log("Error al editar materia: $e");
    }
  }

  Future<void> deleteMateria(String id) async {
    try {
      await _dbService.deleteMateria(id);
      materias.removeWhere((element) => element.idMateria == id);
      log("Materia eliminada correctamente");
    } catch (e) {
      log("Error al eliminar materia: $e");
    }
  }
}