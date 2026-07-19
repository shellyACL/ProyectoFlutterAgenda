class Institucion{
  String? idIns;
  String nombreIns;
  String tipoIns; 
  

  Institucion({
    this.idIns,
    required this.nombreIns,
    required this.tipoIns,

  });

  //MAP A OBJETO
  factory Institucion.fromMap(Map<String,dynamic> json){
    return Institucion(
      idIns: json['idIns'],
      nombreIns: json['nombreIns'], 
      tipoIns: json['tipoIns'],
    );
  }

  //OBJETO A MAP
  Map<String, dynamic> toMap(){
    return{
      'idIns': idIns,
      'nombreIns': nombreIns,
      'tipoIns': tipoIns,
    };
  }
  @override
  String toString() {
    return 'Institucion(idIns: $idIns, nombreIns: $nombreIns, tipoIns: $tipoIns)';
  }
}