import 'package:agenda_part1/infrastructure/models/estado_model.dart';
import 'package:agenda_part1/infrastructure/models/institucion_model.dart';
import 'package:agenda_part1/infrastructure/models/periodo_model.dart';
import 'package:agenda_part1/infrastructure/models/responsable_model.dart';

class Materia{
  String? idMateria;
  String nombreMateria;
  String? fechaIni;
  String? fechaFin;
  int notaMinima;
  int notaAct;
  Responsable? responsable;
  Institucion? institucion;
  Periodo? periodo;
  Estado? estado;
  
  Materia({
    this.idMateria,
    required this.nombreMateria,
    this.fechaIni,
    this.fechaFin,
    required this.notaMinima,
    required this.notaAct,
    this.responsable,
    this.institucion,
    this.periodo,
    this.estado,
  });

  //MAP A OBJETO
  factory Materia.fromMap(Map<String,dynamic> json){
    return Materia(
      idMateria: json['idMateria'],
      nombreMateria: json['nombreMateria'],
      fechaIni: json['fechaIni'],
      fechaFin: json['fechaFin'],
      notaMinima: json['notaMinima'] ?? 0,
      notaAct: json['notaAct'] ?? 0,
      responsable: json['idResponsable'] != null
       ? Responsable.fromMap({'idResponsable': json['idResponsable'],
       'nombreResponsable': json['nombreResponsable'],
       })
       : null,

      institucion: json['idIns'] != null
       ? Institucion.fromMap({'idIns': json['idIns'],
       'nombreIns': json['nombreIns'], 'tipoIns': json['tipoIns'],
       })
       : null,

      periodo: json['idPeriodo'] != null
       ? Periodo.fromMap({'idPeriodo': json['idPeriodo'],
       'nombrePeriodo': json['nombrePeriodo'],
       'diasDurPeriodo': json['diasDurPeriodo'],
       })
       : null,

      estado: json['idEstado'] != null
       ? Estado.fromMap({'idEstado': json['idEstado'],
       'nombreEstado': json['nombreEstado'],
       })
       : null,
    );
  }

  //OBJETO A MAP
  Map<String, dynamic> toMap(){
    return{
      'idMateria': idMateria,
      'nombreMateria': nombreMateria,
      'fechaIni': fechaIni,
      'fechaFin': fechaFin,
      'notaMinima': notaMinima,
      'notaAct': notaAct,
      'idResponsable': responsable?.idResponsable,
      'idIns': institucion?.idIns,
      'idPeriodo': periodo?.idPeriodo,
      'idEstado': estado?.idEstado,
    };
  }
  @override
  String toString() {
    return 'Materia(idMateria: $idMateria, nombreMateria: $nombreMateria, fechaIni: $fechaIni, fechaFin: $fechaFin, notaMinima: $notaMinima, notaAct: $notaAct, responsable: ${responsable?.nombreResponsable ?? "Sin Responsable"}, institucion: ${institucion?.nombreIns ?? "Ninguna"},  periodo: ${periodo?.nombrePeriodo ?? "Sin periodo"}, estado: ${estado?.nombreEstado ?? "Sin Estado"} )';
    }
}