import 'package:agenda_part1/infrastructure/models/institucion_model.dart';
import 'package:agenda_part1/infrastructure/models/tipoprog_model.dart';

class Programa{
  String? idProg;
  String nombreProg;
  Institucion? institucion;
  TipoProg? tipoProg;
  
  
  Programa({
    this.idProg,
    required this.nombreProg,
    this.institucion,
    this.tipoProg,

  });

  //MAP A OBJETO
  factory Programa.fromMap(Map<String,dynamic> json){
    return Programa(
      idProg: json['idProg'],
      nombreProg: json['nombreProg'],

      institucion: json['idIns'] != null
       ? Institucion.fromMap({'idIns': json['idIns'],
       'nombreIns': json['nombreIns'], 'tipoIns': json['tipoIns'],
       })
       : null,

      tipoProg: json['idTipoProg'] != null
       ? TipoProg.fromMap({'idTipoProg': json['idTipoProg'],
       'nombreTipoProg': json['nombreTipoProg'],
       })
       : null,
    );
  }

  //OBJETO A MAP
  Map<String, dynamic> toMap(){
    return{
      'idProg': idProg,
      'nombreProg': nombreProg,
      'idIns': institucion?.idIns,
      'idTipoProg': tipoProg?.idTipoProg,
    };
  }
  @override
  String toString() {
    return 'Programa('
          'idProg: $idProg, '
          'nombreProg: $nombreProg, '
          'institucion: ${institucion?.nombreIns ?? "Ninguna"}, ' 
          'tipoProg: ${tipoProg?.nombreTipoProg ?? "Sin tipo"}' 
          ')';
    }
}