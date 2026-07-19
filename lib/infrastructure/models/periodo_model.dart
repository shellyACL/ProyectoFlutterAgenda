class Periodo{
  String? idPeriodo;
  String nombrePeriodo;
  int diasDurPeriodo;
  
  Periodo({
    this.idPeriodo,
    required this.nombrePeriodo,
    required this.diasDurPeriodo,

  });

  //MAP A OBJETO
  factory Periodo.fromMap(Map<String,dynamic> json){
    return Periodo(
      idPeriodo: json['idPeriodo'],
      nombrePeriodo: json['nombrePeriodo'], 
      diasDurPeriodo: json['diasDurPeriodo'], 
    );
  }

  //OBJETO A MAP
  Map<String, dynamic> toMap(){
    return{
      'idPeriodo': idPeriodo,
      'nombrePeriodo': nombrePeriodo,
      'diasDurPeriodo': diasDurPeriodo,
    };
  }
  @override
  String toString() {
    return 'Periodo(idPeriodo: $idPeriodo, nombrePeriodo: $nombrePeriodo, diasDurPeriodo: $diasDurPeriodo)';
  }
}