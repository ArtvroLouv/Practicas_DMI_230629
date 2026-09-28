import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yes_no_app/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();

  final List<Message> messageList = [
    Message(
      text: 'Holaa',
      fromWho: FromWho.me,
    ),
    Message(
      text: 'Ya regresaste?',
      fromWho: FromWho.me,
    ),
  ];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      text: text.trim(),
      fromWho: FromWho.me,
      time: DateTime.now(),
    );

    messageList.add(newMessage);

    notifyListeners();
    moveScrollToBottom();

    try {
      final answer = _getRandomAnswer();

      final url = Uri.parse(
        'https://yesno.wtf/api?force=$answer',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Error al consultar la API');
      }

      final data = jsonDecode(response.body);
      //print('RESPUESTA: $data');
      //print('GIF: ${data['image']}');
      String responseText;

      switch (data['answer']) {
        case 'yes':
          responseText = 'Sí';
          break;

        case 'no':
          responseText = 'No';
          break;

        case 'maybe':
          responseText = 'Tal vez';
          break;

        default:
          responseText = 'No sé';
      }

      final responseMessage = Message(
        text: responseText,
        imageUrl: data['image'],
        fromWho: FromWho.hers,
        time: DateTime.now(),
      );

      messageList.add(responseMessage);

      notifyListeners();
      moveScrollToBottom();
    } catch (e) {
      final errorMessage = Message(
        text: 'No pude responder en este momento.',
        fromWho: FromWho.hers,
        time: DateTime.now(),
      );

      messageList.add(errorMessage);

      notifyListeners();
      moveScrollToBottom();
    }
  }

  String _getRandomAnswer() {
    final random = Random().nextInt(100);

    if (random < 20) {
      return 'maybe';
    }

    if (random < 60) {
      return 'yes';
    }

    return 'no';
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
    );

    if (!chatScrollController.hasClients) return;

    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    chatScrollController.dispose();
    super.dispose();
  }
}