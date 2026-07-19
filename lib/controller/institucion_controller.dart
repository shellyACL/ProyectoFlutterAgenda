import 'dart:developer';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart'; 
import 'package:agenda_part1/infrastructure/models/institucion_model.dart';
import 'package:uuid/uuid.dart';

class InstitutionController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  var instituciones = <Institucion>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInstitucion();
  }
  

  Future<void> loadInstitucion() async {
    try {

      instituciones.value = await _dbService.getAllInstitucion();
      log("Instituciones listadas: ${instituciones.length}");
    } catch (e) {
      log("Error al listar instituciones: $e");
    }
  }

  Future<void> addInstitucion({required String nombre, required String tipo}) async {
    try {
      String nuevoId = "INS-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      
      final nuevaInstitucion = Institucion(
        idIns: nuevoId,
        nombreIns: nombre,
        tipoIns: tipo,
      );

      await _dbService.insertInstitucion(nuevaInstitucion);
      instituciones.add(nuevaInstitucion);
      log("Institución agregada correctamente");
    } catch (e) {
      log("Error al agregar institución: $e");
    }
  }

  // Editar
  Future<void> updateInstitucion(Institucion institucionEditada) async {
    try {
      await _dbService.updateInstitucion(institucionEditada);

      int index = instituciones.indexWhere((element) => element.idIns == institucionEditada.idIns);
      if (index != -1) {
        instituciones[index] = institucionEditada;
        instituciones.refresh(); 
        log("Institución editada correctamente");
      }
    } catch (e) {
      log("Error al editar institución: $e");
    }
  }

  // Eliminar
  Future<void> deleteInstitucion(String id) async {
    try {
      await _dbService.deleteInstitucion(id);
      instituciones.removeWhere((element) => element.idIns == id);
      log("Institución eliminada correctamente");
    } catch (e) {
      log("Error al eliminar institución: $e");
    }
  }
}