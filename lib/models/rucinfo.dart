class RucInfo {
  int id;
  String ruc;
  String razonSocial;
  int digitoVerificador;
  String estado;

  RucInfo({
    required this.id,
    required this.ruc,
    required this.razonSocial,
    required this.digitoVerificador,
    required this.estado,
  });

  factory RucInfo.fromJson(Map<String, dynamic> json){
    return RucInfo(
      id: json['id'] as int,
      ruc: json['ruc'] as String,
      razonSocial: json['razonSocial'] as String,
      digitoVerificador: ['digitoVerificador'] as int,
      estado: ['estado'] as String,
    );
  }
}
