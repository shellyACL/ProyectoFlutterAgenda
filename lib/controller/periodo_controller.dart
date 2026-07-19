import 'dart:developer';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart';
import 'package:agenda_part1/infrastructure/models/periodo_model.dart';
import 'package:uuid/uuid.dart';

class PeriodoController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  var periodos = <Periodo>[].obs;
  bool _isLoaded = false;

  @override
  void onInit() {
    super.onInit();
    loadPeriodo();
  }

  Future<void> loadPeriodo() async {
    if (_isLoaded) return;
    try {
      var listado = await _dbService.getAllPeriodo();
      if (listado.isEmpty) {
        log("Tabla periodo vacía. Sembrando sugeridos...");
        await _seedDefaultPeriodos();
        listado = await _dbService.getAllPeriodo();
      }
      periodos.value = listado;
      _isLoaded = true;
      log("Períodos listados: ${periodos.length}");
    } catch (e) {
      log("Error al listar períodos: $e");
      periodos.value = [];
      _isLoaded = true;
    }
  }

  Future<void> _seedDefaultPeriodos() async {
    final sugeridos = [
      {'nombre': 'Bimestral', 'dias': 60},
      {'nombre': 'Semestral', 'dias': 180},
      {'nombre': 'Anual', 'dias': 365},
      {'nombre': 'Mensual', 'dias': 30},
    ];
    for (var item in sugeridos) {
      String nuevoId = "PER-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final nuevo = Periodo(
        idPeriodo: nuevoId,
        nombrePeriodo: item['nombre'] as String,
        diasDurPeriodo: item['dias'] as int,
      );
      await _dbService.insertPeriodo(nuevo);
    }
  }

  Future<void> addPeriodo({required String nombre, required int dias}) async {
    try {
      String nuevoId = "PER-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final nuevo = Periodo(
        idPeriodo: nuevoId,
        nombrePeriodo: nombre,
        diasDurPeriodo: dias,
      );
      await _dbService.insertPeriodo(nuevo);
      periodos.add(nuevo);
      log("Período agregado correctamente");
    } catch (e) {
      log("Error al agregar período: $e");
    }
  }

  Future<void> updatePeriodo(Periodo periodoEditado) async {
    try {
      await _dbService.updatePeriodo(periodoEditado);
      int index = periodos.indexWhere((element) => element.idPeriodo == periodoEditado.idPeriodo);
      if (index != -1) {
        periodos[index] = periodoEditado;
        periodos.refresh();
        log("Período editado correctamente");
      }
    } catch (e) {
      log("Error al editar período: $e");
    }
  }

  Future<void> deletePeriodo(String id) async {
    try {
      await _dbService.deletePeriodo(id);
      periodos.removeWhere((element) => element.idPeriodo == id);
      log("Período eliminado correctamente");
    } catch (e) {
      log("Error al eliminar período: $e");
    }
  }
}