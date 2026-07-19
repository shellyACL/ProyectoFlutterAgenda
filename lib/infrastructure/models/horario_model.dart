import 'package:agenda_part1/infrastructure/models/materia_model.dart';

class Horario{
  String? idHorario;
  String diaHorario;
  String iniHorario;
  String finHorario;
  Materia? materia;
  
  Horario({
    this.idHorario,
    required this.diaHorario,
    required this.iniHorario,
    required this.finHorario,
    this.materia,

  });

  //MAP A OBJETO
  factory Horario.fromMap(Map<String,dynamic> json){
    return Horario(
      idHorario: json['idHorario'],
      diaHorario: json['diaHorario'],
      iniHorario: json['iniHorario'],
      finHorario: json['finHorario'],
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
      'idHorario': idHorario,
      'diaHorario': diaHorario,
      'iniHorario': iniHorario,
      'finHorario': finHorario,
      'idMateria': materia?.idMateria,
    };
  }
  @override
  String toString() {
    return 'Horario('
          'idHorario: $idHorario, '
          'diaHorario: $diaHorario, '
          'iniHorario: $iniHorario, '
          'finHorario: $finHorario, '

          'materia: ${materia?.nombreMateria ?? "Sin materia"}' 
          ')';
    }
}