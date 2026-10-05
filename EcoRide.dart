import 'dart:math';

void main(){
  List<vehiculo> flota = [
    patinete(id: 'A', bateria: 44, precioMinuto: 0.25, velocMaxima: 25, latitud: 39, longitud: 2, enUso: true),
    patinete(id: 'B', bateria: 67, precioMinuto: 0.10, velocMaxima: 25, latitud: 32, longitud: 5, enUso: true),
    patinete(id: 'C', bateria: 12, precioMinuto: 0.15, velocMaxima: 25, latitud: 36, longitud: 10, enUso: false),
    coche(id: 'D', bateria: 42, precioMinuto: 1, plazas: 4, requiLic: true, latitud: 40, longitud: 1, enUso: true),
    coche(id: 'E', bateria: 100, precioMinuto: 1, plazas: 4, requiLic: true, latitud: 60, longitud: 7, enUso: false),
  ];

  vehiculo mejorBateria = flota.reduce(
    (a, b) => a.bateria >= b.bateria
        ? a
        : b,
  );

  print('Vehiculo con mas bateria: ${mejorBateria.id}');
  print('Bateria: ${mejorBateria.bateria}%');
  print('Estado:-- ${mejorBateria.estadoBat()}');

  print("Vehiculos sin uso y con menos de 20% de bateria: ");
  print(flota.where((c) => !c.enUso && c.bateria > 20).toList());

  User user = User.nou(
    id: "F",
    name: "Nestor Schierse Galey",
    email: "nestorschierse@paucasesnovescifp.cat",
  );
}

class User{
  String _id;
  String _name;
  double _saldo;

  String email;
  bool VIP = false;

  User.nou({
    required String id, 
    required String name, 
    required String email}) : 
      _id = id,
      _name = name,
      email = email,
      _saldo = 0.0;

  User.completo(
    String id, 
    String name, 
    String email, 
    double saldo, 
    bool VIP) : 
      _id = id,
      _name = name,
      email = email,
      _saldo = saldo,
      VIP = VIP;  
  
  double get saldo => _saldo;
  String get id => _id;

  recargarSaldo(double num){
    if(num <= 0.0){
      throw ArgumentError('La cantidad debe ser mayor que cero');
    }else {
      _saldo += num;
    }
  }
}

mixin GPSLocation {
  double latitud = 0.0;
  double longitud = 0.0;

  actGPS(double lat, double lng){
    latitud = lat;
    longitud = lng;
  }

  ({double lat, double lng}) obtGPS(){
    return(lat: latitud, lng: longitud);
  }    
}

abstract class vehiculo with GPSLocation{
  String id = ''; 
  int bateria;
  bool enUso = false;
  double precioMinuto = 0.0;

  vehiculo({
    required this.id,
    required this.bateria,
    this.enUso = false,
    required this.precioMinuto,
    double latitud = 0.0,
    double longitud = 0.0,
  });

  String estadoBat() => switch (bateria) {
    _ when bateria >= 80 => 'Alta',
    _ when bateria <= 79 && bateria >= 20 => 'Mediana',
    _ => 'Critica',
  };

  double costReserva(int mins);
}

class patinete extends vehiculo{
  int velocMaxima;
  
  patinete({
    required super.id,
    required super.bateria,
    super.enUso = false,
    required super.precioMinuto,
    super.latitud = 0.0,
    super.longitud = 0.0,
    required this.velocMaxima,
  });
  
  @override
  double costReserva(int minutos, {User? usuario}) {
    if (minutos <= 0) {
      throw ArgumentError('Los minutos tiene que ser positivos.');
    }

    double cost = minutos * precioMinuto;

    if (usuario != null && usuario.VIP) {
      cost *= 0.90;
    }

    return cost;
  }
}

class coche extends vehiculo {
  int plazas;
  bool requiLic;

  coche({
    required super.id,
    required super.bateria,
    super.enUso = false,
    required super.precioMinuto,
    super.latitud = 0.0,
    super.longitud = 0.0,
    required this.plazas,
    required this.requiLic,
  });

  @override
  double costReserva(int minutos, {User? usuario}) {
    if (minutos <= 0) {
      throw ArgumentError('Els minuts han de ser positius.');
    }

    return (minutos * precioMinuto) + 2.0;
  }
}

