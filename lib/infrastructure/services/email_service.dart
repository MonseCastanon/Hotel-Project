import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:hotel_app/domain/entities/user.dart';

class EmailService {
  static Future<void> sendApprovalEmail(User employee) async {
    final username = dotenv.env['MAIL_USERNAME'];
    final password = dotenv.env['MAIL_PASSWORD'];
    final server = dotenv.env['MAIL_SERVER'];
    final portStr = dotenv.env['MAIL_PORT'];

    if (username == null || password == null || server == null) {
      print('Faltan credenciales de correo en el .env');
      return;
    }

    // SMTP Server
    final smtpServer = SmtpServer(
      server,
      port: int.tryParse(portStr ?? '587') ?? 587,
      username: username,
      password: password,
      ignoreBadCertificate: false,
    );

    // Mensaje
    final message = Message()
      ..from = Address(username, 'Sistema de Administración Hotelera')
      ..recipients.add(employee.email)
      ..subject = 'Tu cuenta del sistema hotelero ha sido aprobada'
      ..text = '''Hola, ${employee.name}:

Tu cuenta ha sido validada y aprobada por el gerente.

Rol asignado: ${employee.role.label}

Ya puedes acceder al sistema de administración hotelera.

Por seguridad, utiliza la contraseña que estableciste durante tu registro.

Si no reconoces esta acción, contacta al administrador del hotel.

Saludos,
Sistema de Administración Hotelera''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Correo enviado: \${sendReport.toString()}');
    } catch (e) {
      print('Error al enviar correo: $e');
    }
  }
}
