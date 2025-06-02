class Contact {
  final int? id;
  final String nombre;
  final String apellido;
  final String email;
  final int telefono; // cambia a int

  Contact(
      {this.id,
      required this.nombre,
      required this.apellido,
      required this.email,
      required this.telefono});

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['contactoId'] ?? map['ContactoId'],
      nombre: map['nombre'] ?? map['Nombre'] ?? '',
      apellido: map['apellido'] ?? map['Apellido'] ?? '',
      email: map['email'] ?? map['Email'] ?? '',
      telefono: (map['telefono'] ?? map['Telefono'] ?? 0) is int
          ? map['telefono'] ?? map['Telefono'] ?? 0
          : int.tryParse(
                  (map['telefono'] ?? map['Telefono'] ?? '0').toString()) ??
              0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contactoId': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
    };
  }
}
