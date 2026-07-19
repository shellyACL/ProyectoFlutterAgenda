class Estado{
  String? idEstado;
  String nombreEstado;
  
  Estado({
    this.idEstado,
    required this.nombreEstado,

  });

  //MAP A OBJETO
  factory Estado.fromMap(Map<String,dynamic> json){
    return Estado(
      idEstado: json['idEstado'],
      nombreEstado: json['nombreEstado'], 
    );
  }

  //OBJETO A MAP
  Map<String, dynamic> toMap(){
    return{
      'idEstado': idEstado,
      'nombreEstado': nombreEstado,
    };
  }
  @override
  String toString() {
    return 'Estado(idEstado: $idEstado, nombreEstado: $nombreEstado)';
  }
}