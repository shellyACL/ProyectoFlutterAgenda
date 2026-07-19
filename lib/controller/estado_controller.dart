import 'dart:developer';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart';
import 'package:agenda_part1/infrastructure/models/estado_model.dart';
import 'package:uuid/uuid.dart';

class EstadoController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  var estados = <Estado>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEstado();
  }

  Future<void> loadEstado() async {
    try {
      var listado = await _dbService.getAllEstado();

      if (listado.isEmpty) {
        log("Tabla estado vacía. Sembrando sugeridos...");
        await _seedDefaultEstados();
        listado = await _dbService.getAllEstado();
      }

      estados.value = listado;
      log("Estados listados: ${estados.length}");
    } catch (e) {
      log("Error al listar estados: $e");
    }
  }

  Future<void> _seedDefaultEstados() async {
    List<String> sugeridos = ['Activo', 'Inactivo', 'Finalizado', 'En curso', 'Pendiente'];

    for (String nombre in sugeridos) {
      String nuevoId = "EST-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final nuevoEstado = Estado(
        idEstado: nuevoId,
        nombreEstado: nombre,
      );
      await _dbService.insertEstado(nuevoEstado);
    }
  }

  Future<void> addEstado({required String nombre}) async {
    try {
      String nuevoId = "EST-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final nuevoEstado = Estado(
        idEstado: nuevoId,
        nombreEstado: nombre,
      );
      await _dbService.insertEstado(nuevoEstado);
      estados.add(nuevoEstado);
      log("Estado agregado correctamente");
    } catch (e) {
      log("Error al agregar estado: $e");
    }
  }

  Future<void> updateEstado(Estado estadoEditado) async {
    try {
      await _dbService.updateEstado(estadoEditado);
      int index = estados.indexWhere((e) => e.idEstado == estadoEditado.idEstado);
      if (index != -1) {
        estados[index] = estadoEditado;
        estados.refresh();
        log("Estado editado correctamente");
      }
    } catch (e) {
      log("Error al editar estado: $e");
    }
  }

  Future<void> deleteEstado(String id) async {
    try {
      await _dbService.deleteEstado(id);
      estados.removeWhere((e) => e.idEstado == id);
      log("Estado eliminado correctamente");
    } catch (e) {
      log("Error al eliminar estado: $e");
    }
  }
}