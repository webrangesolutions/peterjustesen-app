import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PaymentService {
  static createPaymentMethod(card) async {
    var m = {};

    var data = {
      'type': 'card',
      'card[number]': card['number'],
      'card[exp_month]': card['exp_month'],
      'card[exp_year]': '${card['exp_year']}',
      'card[cvc]': card['cvc']
    };

    try {
      var msg = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_methods'),
          headers: {
            "Authorization":
                "Bearer sk_test_51MT9qbGedbODhUB1zxkrdboU8vNrZcEXfKQS2URKOemdGYGEH6HP736xGOTlBdPMVWJF4ypby0rrMw9FRliUaQ7s00opaZBg72"
          },
          body: data);

      if (msg.statusCode == 200) {
        var x = jsonDecode(msg.body);
        m.addAll({'success': true, 'id': x['id']});
      } else {
        m.addAll({'success': false});
      }
    } on HttpException catch (e) {
      print(e.message);
      m.addAll({'success': false});
    }

    return m;
  }

  static sendPayment(card) async {
    var m = {};

    var paymentId = await createPaymentMethod(card);

    if (paymentId['success'] == true) {
      var data = {
        'payment_method': paymentId['id'],
        'amount': card['amount'],
        'currency': 'usd',
        'payment_method_types[]': 'card',
        'confirmation_method': "automatic",
        'confirm': 'true'
      };

      try {
        var msg = await http.post(
            Uri.parse('https://api.stripe.com/v1/payment_intents'),
            headers: {
              "Authorization":
                  "Bearer sk_test_51MT9qbGedbODhUB1zxkrdboU8vNrZcEXfKQS2URKOemdGYGEH6HP736xGOTlBdPMVWJF4ypby0rrMw9FRliUaQ7s00opaZBg72"
            },
            body: data);

        if (msg.statusCode == 200) {
          var x = jsonDecode(msg.body);
          m.addAll({'success': true, 'payment': x['id']});
        } else {
          m.addAll({'success': false});
        }
      } on HttpException catch (e) {
        print(e.message);
        m.addAll({'success': false});
      }
    } else {
      m.addAll({'success': false});
    }

    return m;
  }
}
