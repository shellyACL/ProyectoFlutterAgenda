class TipoAct{
  String? idTipoAct;
  String nombreTipoAct;
  bool reqNotaRapidaTipoAct; // si no or esta vez el usuario deberá llenarlo, en otra version se realizara algo más automatizado
  
  TipoAct({
    this.idTipoAct,
    required this.nombreTipoAct,
    required this.reqNotaRapidaTipoAct,

  });

  //MAP A OBJETO
  factory TipoAct.fromMap(Map<String,dynamic> json){
    return TipoAct(
      idTipoAct: json['idTipoAct'],
      nombreTipoAct: json['nombreTipoAct'], 
      reqNotaRapidaTipoAct: json['reqNotaRapidaTipoAct']==1, 
    );
  }

  //OBJETO A MAP
  Map<String, dynamic> toMap(){
    return{
      'idTipoAct': idTipoAct,
      'nombreTipoAct': nombreTipoAct,
      'reqNotaRapidaTipoAct': reqNotaRapidaTipoAct ? 1:0,
    };
  }
  @override
  String toString() {
    return 'TipoAct(idTipoAct: $idTipoAct, nombreTipoAct: $nombreTipoAct, reqNotaRapidaTipoAct: $reqNotaRapidaTipoAct)';
  }
}