class Contact {
  final int? contactoId;
  final String nombre;
  final String apellido;
  final String email;
  final int telefono;
  final bool activo;

  Contact(
      {this.contactoId,
      required this.nombre,
      required this.apellido,
      required this.email,
      this.activo = true,
      required this.telefono});

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      contactoId: map['contactoId'] ?? map['ContactoId'],
      nombre: map['nombre'] ?? map['Nombre'] ?? '',
      apellido: map['apellido'] ?? map['Apellido'] ?? '',
      email: map['email'] ?? map['Email'] ?? '',
      telefono: (map['telefono'] ?? map['Telefono'] ?? 0) is int
          ? map['telefono'] ?? map['Telefono'] ?? 0
          : int.tryParse(
                  (map['telefono'] ?? map['Telefono'] ?? '0').toString()) ??
              0,
      activo: map['activo'] ?? map['Activo'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'activo': activo,
    };

    if (contactoId != null) {
      map['contactoId'] = contactoId as Object;
    }

    return map;
  }
}
