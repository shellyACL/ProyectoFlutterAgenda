import 'package:agenda_part1/infrastructure/models/materia_model.dart';
import 'package:agenda_part1/infrastructure/models/tipoact_model.dart';

class Tarea{
  String? idTarea;
  String nombreTarea;
  String? descTarea;
  String fechaCreaTarea;
  String? fechaEntTarea;
  String estadoTarea;
  int? notaObtenida;
  int? ponderacion;
  Materia? materia;
  TipoAct? tipoAct;
 
  Tarea({
    this.idTarea,
    required this.nombreTarea,
    this.descTarea,
    required this.fechaCreaTarea,
    this.fechaEntTarea,
    required this.estadoTarea,
    this.notaObtenida,
    this.ponderacion,
    this.materia,
    this.tipoAct,
  });

  //MAP A OBJETO
  factory Tarea.fromMap(Map<String,dynamic> json){
    return Tarea(
      idTarea: json['idTarea'],
      nombreTarea: json['nombreTarea'],
      descTarea: json['descTarea'],
      fechaCreaTarea: json['fechaCreaTarea'],
      fechaEntTarea: json['fechaEntTarea'],
      estadoTarea: json['estadoTarea'],
      notaObtenida: json['notaObtenida'],
      ponderacion: json['ponderacion'],
      tipoAct: json['idTipoAct'] != null
       ? TipoAct.fromMap({'idTipoAct': json['idTipoAct'],
       'nombreTipoAct': json['nombreTipoAct'], 'reqNotaRapidaTipoAct': json['reqNotaRapidaTipoAct'],
       })
       : null,
      materia: json['idMateria'] != null
       ? Materia.fromMap({'idMateria': json['idMateria'],
       'nombreMateria': json['nombreMateria'], 
       })
       : null,
    );
  }

  //OBJETO A MAP
  Map<String, dynamic> toMap(){
    return{
      'idTarea': idTarea,
      'nombreTarea': nombreTarea,
      'descTarea': descTarea,
      'fechaCreaTarea': fechaCreaTarea,
      'fechaEntTarea': fechaEntTarea,
      'estadoTarea': estadoTarea,
      'notaObtenida': notaObtenida,
      'ponderacion': ponderacion,
      'idMateria': materia?.idMateria,
      'idTipoAct': tipoAct?.idTipoAct,

    };
  }
  @override
  String toString() {
    return 'Tarea(idTarea: $idTarea, nombreTarea: $nombreTarea, descTarea: $descTarea, fechaCreaTarea: $fechaCreaTarea, fechaEntTarea: $fechaEntTarea, estadoTarea: $estadoTarea, notaObtenida: $notaObtenida, ponderacion: $ponderacion, materia: ${materia?.nombreMateria ?? "Sin Materia"}, tipoAct: ${tipoAct?.nombreTipoAct ?? "Sin Tipo de Actividad"} )';
    }
}