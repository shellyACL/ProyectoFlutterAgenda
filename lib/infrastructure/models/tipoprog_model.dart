class TipoProg{
  String? idTipoProg;
  String nombreTipoProg;
  
  TipoProg({
    this.idTipoProg,
    required this.nombreTipoProg,

  });

  //MAP A OBJETO
  factory TipoProg.fromMap(Map<String,dynamic> json){
    return TipoProg(
      idTipoProg: json['idTipoProg'],
      nombreTipoProg: json['nombreTipoProg'], 
    );
  }

  //OBJETO A MAP
  Map<String, dynamic> toMap(){
    return{
      'idTipoProg': idTipoProg,
      'nombreTipoProg': nombreTipoProg,
    };
  }
  @override
  String toString() {
    return 'TipoProg(idTipoProg: $idTipoProg, nombreTipoProg: $nombreTipoProg)';
  }
}