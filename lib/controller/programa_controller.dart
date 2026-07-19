import 'dart:developer';
import 'package:agenda_part1/infrastructure/models/institucion_model.dart';
import 'package:agenda_part1/infrastructure/models/tipoprog_model.dart';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart'; 
import 'package:agenda_part1/infrastructure/models/programa_model.dart';
import 'package:uuid/uuid.dart';

class ProgramaController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  var programas = <Programa>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPrograma();
  }
  
  bool _isLoaded = false;

  Future<void> loadPrograma() async {
    if (_isLoaded) return;
    try {
      programas.value = await _dbService.getAllPrograma();
      _isLoaded = true;
      log("Programas listados: ${programas.length}");
    } catch (e) {
      log("Error al listar programas: $e");
      programas.value = [];
      _isLoaded = true;
    }
  }

  Future<void> addPrograma({required String nombre, required TipoProg tipo, required Institucion ins }) async {
    try {
      String nuevoId = "PRO-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      
      final nuevoPrograma = Programa(
        idProg: nuevoId,
        nombreProg: nombre,
        tipoProg: tipo,
        institucion: ins,
      );

      await _dbService.insertPrograma(nuevoPrograma);
      programas.add(nuevoPrograma);
      log("Programa agregado correctamente");
    } catch (e) {
      log("Error al agregar programa: $e");
    }
  }

  Future<void> updatePrograma(Programa programaEditado) async {
    try {
      await _dbService.updatePrograma(programaEditado);

      int index = programas.indexWhere((element) => element.idProg == programaEditado.idProg);
      if (index != -1) {
        programas[index] = programaEditado;
        programas.refresh(); 
        log("programa editado correctamente");
      }
    } catch (e) {
      log("Error al editar programa: $e");
    }
  }

  Future<void> deletePrograma(String id) async {
    try {
      await _dbService.deletePrograma(id);
      programas.removeWhere((element) => element.idProg == id);
      log("programa eliminado correctamente");
    } catch (e) {
      log("Error al eliminar programa: $e");
    }
  }
}