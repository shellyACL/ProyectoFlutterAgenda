import 'dart:developer';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart';
import 'package:agenda_part1/infrastructure/models/responsable_model.dart';
import 'package:uuid/uuid.dart';

class ResponsableController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  var responsables = <Responsable>[].obs;
  bool _isLoaded = false;

  @override
  void onInit() {
    super.onInit();
    loadResponsable();
  }

  Future<void> loadResponsable() async {
    if (_isLoaded) return;
    try {
      responsables.value = await _dbService.getAllResponsable();
      _isLoaded = true;
      log("Responsables listados: ${responsables.length}");
    } catch (e) {
      log("Error al listar responsables: $e");
      responsables.value = [];
      _isLoaded = true;
    }
  }

  Future<void> addResponsable({required String nombre}) async {
    try {
      String nuevoId = "RES-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final nuevoResponsable = Responsable(
        idResponsable: nuevoId,
        nombreResponsable: nombre,
      );
      await _dbService.insertResponsable(nuevoResponsable);
      responsables.add(nuevoResponsable);
      log("Responsable agregado correctamente");
    } catch (e) {
      log("Error al agregar responsable: $e");
    }
  }

  Future<void> updateResponsable(Responsable responsableEditado) async {
    try {
      await _dbService.updateResponsable(responsableEditado);
      int index = responsables.indexWhere(
          (element) => element.idResponsable == responsableEditado.idResponsable);
      if (index != -1) {
        responsables[index] = responsableEditado;
        responsables.refresh();
        log("Responsable editado correctamente");
      }
    } catch (e) {
      log("Error al editar responsable: $e");
    }
  }

  Future<void> deleteResponsable(String id) async {
    try {
      await _dbService.deleteResponsable(id);
      responsables.removeWhere((element) => element.idResponsable == id);
      log("Responsable eliminado correctamente");
    } catch (e) {
      log("Error al eliminar responsable: $e");
    }
  }
}