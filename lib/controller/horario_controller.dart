import 'dart:developer';
import 'package:get/get.dart';
import 'package:agenda_part1/infrastructure/data/database_service.dart';
import 'package:agenda_part1/infrastructure/models/horario_model.dart';
import 'package:agenda_part1/infrastructure/models/materia_model.dart';
import 'package:uuid/uuid.dart';

class HorarioController extends GetxController {
  final DatabaseService _dbService = DatabaseService();
  var horarios = <Horario>[].obs;
  bool _isLoaded = false;

  @override
  void onInit() {
    super.onInit();
    loadHorario();
  }

  Future<void> loadHorario() async {
    if (_isLoaded) return;
    try {
      horarios.value = await _dbService.getAllHorario();
      _isLoaded = true;
      log("Horarios listados: ${horarios.length}");
    } catch (e) {
      log("Error al listar horarios: $e");
      horarios.value = [];
      _isLoaded = true;
    }
  }

  Future<void> addHorario({
    required String diaHorario,
    required String iniHorario,
    required String finHorario,
    required Materia materia,
  }) async {
    try {
      String nuevoId = "HOR-${const Uuid().v4().substring(0, 8).toUpperCase()}";
      final nuevoHorario = Horario(
        idHorario: nuevoId,
        diaHorario: diaHorario,
        iniHorario: iniHorario,
        finHorario: finHorario,
        materia: materia,
      );
      await _dbService.insertHorario(nuevoHorario);
      horarios.add(nuevoHorario);
      log("Horario agregado correctamente");
    } catch (e) {
      log("Error al agregar horario: $e");
    }
  }

  Future<void> updateHorario(Horario horarioEditado) async {
    try {
      await _dbService.updateHorario(horarioEditado);
      int index = horarios.indexWhere((element) => element.idHorario == horarioEditado.idHorario);
      if (index != -1) {
        horarios[index] = horarioEditado;
        horarios.refresh();
        log("Horario editado correctamente");
      }
    } catch (e) {
      log("Error al editar horario: $e");
    }
  }

  Future<void> deleteHorario(String id) async {
    try {
      await _dbService.deleteHorario(id);
      horarios.removeWhere((element) => element.idHorario == id);
      log("Horario eliminado correctamente");
    } catch (e) {
      log("Error al eliminar horario: $e");
    }
  }

  Future<List<Horario>> getHorariosByMateria(String idMateria) async {
    try {
      return await _dbService.getHorarioByMateria(idMateria);
    } catch (e) {
      log("Error al obtener horarios: $e");
      return [];
    }
  }

  Future<void> deleteHorariosByMateria(String idMateria) async {
    try {
      await _dbService.deleteHorarioByMateria(idMateria);
      horarios.removeWhere((h) => h.materia?.idMateria == idMateria);
      log("Horarios eliminados para la materia $idMateria");
    } catch (e) {
      log("Error al eliminar horarios de la materia: $e");
    }
  }

  Future<void> saveHorariosForMateria({
    required String idMateria,
    required List<Horario> horariosNuevos,
    required Materia materia,
  }) async {
    try {

      List<Horario> horariosActualesBD = await getHorariosByMateria(idMateria);
      List<Horario> nuevosValidos = horariosNuevos
          .where((h) => h.iniHorario.isNotEmpty && h.finHorario.isNotEmpty)
          .toList();

      bool huboCambios = false;

      if (horariosActualesBD.length != nuevosValidos.length) {

        huboCambios = true;
      } else {

        for (int i = 0; i < nuevosValidos.length; i++) {
          final actual = horariosActualesBD[i];
          final nuevo = nuevosValidos[i];

          if (actual.diaHorario != nuevo.diaHorario ||
              actual.iniHorario != nuevo.iniHorario ||
              actual.finHorario != nuevo.finHorario) {
            huboCambios = true;
            break; 
          }
        }
      }

      if (huboCambios) {
        log("Se detectaron cambios en los horarios de $idMateria. Reemplazando...");
        
        await deleteHorariosByMateria(idMateria);

        for (var horario in nuevosValidos) {
          await addHorario(
            diaHorario: horario.diaHorario,
            iniHorario: horario.iniHorario,
            finHorario: horario.finHorario,
            materia: materia,
          );
        }
        log("Horarios actualizados con éxito para materia $idMateria");
      } else {
        log("No se detectaron cambios en los horarios para la materia $idMateria. Manteniendo datos intactos.");
      }
    } catch (e) {
      log("Error al guardar horarios mediante comparación: $e");
    }
  }
}