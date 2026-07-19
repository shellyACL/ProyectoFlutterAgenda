import 'dart:developer';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart';
import 'package:agenda_part1/infrastructure/models/tipoact_model.dart';
import 'package:uuid/uuid.dart';

class TipoActController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  var tiposAct = <TipoAct>[].obs;
  bool _isLoaded = false;

  @override
  void onInit() {
    super.onInit();
    loadTipoAct();
  }

  Future<void> loadTipoAct() async {
    if (_isLoaded) return;
    try {
      var listado = await _dbService.getAllTipoAct();
      if (listado.isEmpty) {
        log("Tabla tipoAct vacía. Sembrando sugeridos...");
        await _seedDefaultTipos();
        listado = await _dbService.getAllTipoAct();
      }
      tiposAct.value = listado;
      _isLoaded = true;
      log("Tipos de actividad listados: ${tiposAct.length}");
    } catch (e) {
      log("Error al listar tipos de actividad: $e");
      tiposAct.value = [];
      _isLoaded = true;
    }
  }


  Future<void> _seedDefaultTipos() async {
    final sugeridos = [
      {'nombre': 'Exámen', 'reqNota': true},
      {'nombre': 'Resumen', 'reqNota': false},
      {'nombre': 'Tarea', 'reqNota': false},
    ];

    for (var item in sugeridos) {
      String nuevoId = "TACT-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final nuevoTipo = TipoAct(
        idTipoAct: nuevoId,
        nombreTipoAct: item['nombre'] as String,
        reqNotaRapidaTipoAct: item['reqNota'] as bool,
      );
      await _dbService.insertTipoAct(nuevoTipo);
    }
  }

  Future<void> addTipoAct({
    required String nombre,
    required bool reqNotaRapida,
  }) async {
    try {
      String nuevoId = "TACT-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final nuevoTipo = TipoAct(
        idTipoAct: nuevoId,
        nombreTipoAct: nombre,
        reqNotaRapidaTipoAct: reqNotaRapida,
      );
      await _dbService.insertTipoAct(nuevoTipo);
      tiposAct.add(nuevoTipo);
      log("Tipo de actividad agregado correctamente");
    } catch (e) {
      log("Error al agregar tipo de actividad: $e");
    }
  }

  Future<void> updateTipoAct(TipoAct tipoEditado) async {
    try {
      await _dbService.updateTipoAct(tipoEditado);
      int index = tiposAct.indexWhere((element) => element.idTipoAct == tipoEditado.idTipoAct);
      if (index != -1) {
        tiposAct[index] = tipoEditado;
        tiposAct.refresh();
        log("Tipo de actividad editado correctamente");
      }
    } catch (e) {
      log("Error al editar tipo de actividad: $e");
    }
  }

  Future<void> deleteTipoAct(String id) async {
    try {
      await _dbService.deleteTipoAct(id);
      tiposAct.removeWhere((element) => element.idTipoAct == id);
      log("Tipo de actividad eliminado correctamente");
    } catch (e) {
      log("Error al eliminar tipo de actividad: $e");
    }
  }
}