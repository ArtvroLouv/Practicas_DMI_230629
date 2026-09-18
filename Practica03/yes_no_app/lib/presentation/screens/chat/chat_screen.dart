import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding( 
          padding: const EdgeInsets.all(4.0), 
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://media.licdn.com/dms/image/v2/D5635AQFQys97zp75yw/profile-framedphoto-shrink_400_400/B56ZkIJZuwHAAc-/0/1756778306849?e=1790373600&v=beta&t=sM7bpiLfOHHvo4KZRNdRze3bT7_aWj0Vx68oEbiCEQ8'),
          ), 
        ), 
        title: const Text('Mi amor ♥️'),
        centerTitle: false,
      ), 
      body: _ChatView(),
    ); 
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return const MyMessageBubble();
                }
              )
            ),
            Text('Mundo')
          ],
        ),
      ),
    );
  }
}