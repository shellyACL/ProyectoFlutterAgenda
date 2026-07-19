class Responsable{
  String? idResponsable;
  String nombreResponsable;
  
  Responsable({
    this.idResponsable,
    required this.nombreResponsable,

  });

  //MAP A OBJETO
  factory Responsable.fromMap(Map<String,dynamic> json){
    return Responsable(
      idResponsable: json['idResponsable'],
      nombreResponsable: json['nombreResponsable'], 
    );
  }

  //OBJETO A MAP
  Map<String, dynamic> toMap(){
    return{
      'idResponsable': idResponsable,
      'nombreResponsable': nombreResponsable,
    };
  }
  @override
  String toString() {
    return 'Responsable(idResponsable: $idResponsable, nombreResponsable: $nombreResponsable)';
  }
}