import 'package:doctor_point/calls/call_ended_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../constants/app_strings.dart';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorPhoto;

  const ChatScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorPhoto,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> messages = [
    {
      'text': 'Bonjour, comment puis-je vous aider aujourd’hui ?',
      'sender': 'doctor',
      'time': '10:00',
    },
    {
      'text': 'Bonjour Docteur, j’ai des maux de tête persistants depuis hier.',
      'sender': 'user',
      'time': '10:02',
    },
  ];

  String get todayDate => DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now());

  Future<void> _endChat() async {
    try {
      await _firestore.collection('notifications').add({
        'userId': _auth.currentUser!.uid,
        'title': 'Discussion terminée',
        'message': 'Votre discussion avec ${widget.doctorName} est terminée avec succès.',
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout de la notification: $e');
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CallEndedScreen(
          doctorName: widget.doctorName,
          type: 'message',
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty) return;

    final newMessage = {
      'text': _msgCtrl.text.trim(),
      'sender': 'user',
      'time': DateFormat('HH:mm').format(DateTime.now()),
    };

    setState(() {
      messages.add(newMessage);
      _msgCtrl.clear();
    });

    // Scroll automatique
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulation de réponse du médecin
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          messages.add({
            'text': 'Je comprends. Pouvez-vous me décrire la douleur plus précisément ?',
            'sender': 'doctor',
            'time': DateFormat('HH:mm').format(DateTime.now()),
          });
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.doctorPhoto.isNotEmpty ? NetworkImage(widget.doctorPhoto) : null,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: widget.doctorPhoto.isEmpty
                  ? Text(
                      widget.doctorName.isNotEmpty ? widget.doctorName[0] : '?',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctorName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'En ligne',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_rounded), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'end') _endChat();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'end',
                child: Row(
                  children: [
                    const Icon(Icons.exit_to_app, color: Colors.red, size: 20),
                    const SizedBox(width: 10),
                    Text('Terminer la discussion', style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          // Date du jour
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                todayDate,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Zone des messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['sender'] == 'user';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isUser) ...[
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: widget.doctorPhoto.isNotEmpty ? NetworkImage(widget.doctorPhoto) : null,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: widget.doctorPhoto.isEmpty
                              ? Text(widget.doctorName[0], style: const TextStyle(fontSize: 13, color: AppColors.primary))
                              : null,
                        ),
                        const SizedBox(width: 8),
                      ],

                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUser ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(6),
                              bottomRight: isUser ? const Radius.circular(6) : const Radius.circular(18),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['text'],
                                style: TextStyle(
                                  color: isUser ? Colors.white : AppColors.textPrimary,
                                  fontSize: 15.5,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                msg['time'],
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: isUser ? Colors.white.withOpacity(0.8) : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (isUser) ...[
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: const Text('U', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Barre de saisie
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded, color: AppColors.primary),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _msgCtrl,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Écrivez votre message...',
                        hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                  ),
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
    _msgCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}