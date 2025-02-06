import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Data/Models/messageData.dart';
import '../Data/Services/api.dart';


class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<MessageData> messages = [];
  bool isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final int _currentEmployeId = 1;
  Timer? _refreshTimer;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadMessages(silent: true);
    });
  }

  Future<void> _loadMessages({bool silent = false}) async {
    try {
      if (!silent) setState(() => isLoading = true);
      final newMessages = await API.getMessages();

      // Comparer les nouveaux messages avec les existants
      for (var message in newMessages) {
        if (!messages.any((m) => m.idMessage == message.idMessage)) {
          messages.insert(0, message);
          if (!silent) {
            _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
          }
        }
      }

      setState(() {
        messages = newMessages;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text;
    if (content.isEmpty) return;

    try {
      final newMessage = await API.sendMessage(
        idEmploye: _currentEmployeId,
        content: content,
      );

      setState(() {
        messages.insert(0, newMessage);
        _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
        _messageController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message envoyé avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }


  Widget _buildMessageItem(BuildContext context, MessageData message, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                .chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Dismissible(
              key: Key('message_${message.idMessage}'),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            message.cuisinier?['NOM'] ?? 'Inconnu',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.greenAccent,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(message.dateMessage),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(message.content),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadMessages(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: () => _loadMessages(),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: messages.length,
                itemBuilder: (context, index, animation) {
                  return _buildMessageItem(
                    context,
                    messages[index],
                    animation,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez votre message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }
}