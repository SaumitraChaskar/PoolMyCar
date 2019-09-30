import 'package:mailer/mailer.dart';
import '../smtp_server/gmail.dart';

sendBookingMail(String mailTo) async {
  String username = 'testsubject846@gmail.com';
  String password = 'test1subject';

  final smtpServer = gmail(username, password);

  // Create our message.
  final message = new Message()
    ..from = new Address(username, 'PoolMyCar')
    ..recipients.add(mailTo)
    ..subject = 'New Booking'
    ..text = 'Booking created at ${new DateTime.now()}.\nWe hope you have a nice ride!';
  
  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}