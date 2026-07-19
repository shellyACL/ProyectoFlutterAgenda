import 'dart:developer';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart'; 
import 'package:agenda_part1/infrastructure/models/tipoprog_model.dart';
import 'package:uuid/uuid.dart';

class TipoProgController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  
  var tiposPrograma = <TipoProg>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTipoProg();
  }

  Future<void> loadTipoProg() async {
    try {
      var listado = await _dbService.getAllTipoProg();

      if (listado.isEmpty) {
        log("Tabla tipoProg vacía. Sembrando sugeridos...");
        await _seedDefaultTipos();
        listado = await _dbService.getAllTipoProg();
      }

      tiposPrograma.value = listado;
      log("Tipos de programa listados: ${tiposPrograma.length}");
    } catch (e) {
      log("Error al listar tipos de programa: $e");
    }
  }

  Future<void> _seedDefaultTipos() async {
    List<String> sugeridos = ['Carrera', 'Maestria', 'Diplomado'];

    for (String nombre in sugeridos) {
      String nuevoId = "TIP-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final nuevoTipo = TipoProg(
        idTipoProg: nuevoId,
        nombreTipoProg: nombre,
      );
      await _dbService.insertTipoProg(nuevoTipo);
    }
  }

  Future<void> addTipoProg({required String nombre}) async {
    try {
      String nuevoId = "TIP-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      
      final nuevoTipo = TipoProg(
        idTipoProg: nuevoId,
        nombreTipoProg: nombre,
      );

      await _dbService.insertTipoProg(nuevoTipo);
      tiposPrograma.add(nuevoTipo);
      log("Tipo de programa agregado correctamente");
    } catch (e) {
      log("Error al agregar tipo de programa: $e");
    }
  }

  Future<void> updateTipoProg(TipoProg tipoEditado) async {
    try {
      await _dbService.updateTipoProg(tipoEditado);

      int index = tiposPrograma.indexWhere((element) => element.idTipoProg == tipoEditado.idTipoProg);
      if (index != -1) {
        tiposPrograma[index] = tipoEditado;
        tiposPrograma.refresh(); 
        log("Tipo de programa editado correctamente");
      }
    } catch (e) {
      log("Error al editar tipo de programa: $e");
    }
  }

  Future<void> deleteTipoProg(String id) async {
    try {
      await _dbService.deleteTipoProg(id);
      tiposPrograma.removeWhere((element) => element.idTipoProg == id);
      log("Tipo de programa eliminado correctamente");
    } catch (e) {
      log("Error al eliminar tipo de programa: $e");
    }
  }
}