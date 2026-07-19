import 'dart:developer';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart';
import 'package:agenda_part1/infrastructure/models/tarea_model.dart';
import 'package:agenda_part1/infrastructure/models/materia_model.dart';
import 'package:agenda_part1/infrastructure/models/tipoact_model.dart';
import 'package:uuid/uuid.dart';

class TareaController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  var tareas = <Tarea>[].obs;
  bool _isLoaded = false;

  @override
  void onInit() {
    super.onInit();
    loadTarea();
  }

  Future<void> loadTarea() async {
    if (_isLoaded) return;
    try {
      tareas.value = await _dbService.getAllTarea();
      _isLoaded = true;
      log("Tareas listadas globalmente: ${tareas.length}");
    } catch (e) {
      log("Error al listar tareas: $e");
      tareas.value = [];
      _isLoaded = true;
    }
  }

  Future<void> addTarea({
    required String nombreTarea,
    String? descTarea,
    String? fechaEntTarea,
    required String estadoTarea,
    int? notaObtenida,
    int? ponderacion,
    required Materia materia,
    required TipoAct tipoAct,
  }) async {
    try {
      String nuevoId = "TAR-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final fechaCreaTarea = DateTime.now().toIso8601String().split('T').first;

      final nuevaTarea = Tarea(
        idTarea: nuevoId,
        nombreTarea: nombreTarea,
        descTarea: descTarea,
        fechaCreaTarea: fechaCreaTarea,
        fechaEntTarea: fechaEntTarea,
        estadoTarea: estadoTarea,
        notaObtenida: notaObtenida,
        ponderacion: ponderacion,
        materia: materia,
        tipoAct: tipoAct,
      );

      await _dbService.insertTarea(nuevaTarea);
      tareas.add(nuevaTarea);
      log("Tarea agregada individualmente con éxito.");
    } catch (e) {
      log("Error al agregar tarea: $e");
    }
  }


  Future<void> updateTarea(Tarea tareaEditada) async {
    try {
      await _dbService.updateTarea(tareaEditada);
      int index = tareas.indexWhere((element) => element.idTarea == tareaEditada.idTarea);
      if (index != -1) {
        tareas[index] = tareaEditada;
        tareas.refresh();
        log("Tarea editada individualmente con éxito.");
      }
    } catch (e) {
      log("Error al editar tarea: $e");
    }
  }

  Future<void> deleteTarea(String id) async {
    try {
      await _dbService.deleteTarea(id);
      tareas.removeWhere((element) => element.idTarea == id);
      log("Tarea eliminada correctamente.");
    } catch (e) {
      log("Error al eliminar tarea: $e");
    }
  }

  Future<void> deleteTareasByMateria(String idMateria) async {
    try {
      await _dbService.deleteTareaByMateria(idMateria);
      tareas.removeWhere((t) => t.materia?.idMateria == idMateria);
      log("Limpieza completada: Tareas asociadas a la materia $idMateria eliminadas.");
    } catch (e) {
      log("Error al eliminar tareas de la materia: $e");
    }
  }

  Future<List<Tarea>> getTareasByMateria(String idMateria) async {
    try {
      return await _dbService.getTareaByMateria(idMateria);
    } catch (e) {
      log("Error al obtener tareas por materia: $e");
      return [];
    }
  }
}