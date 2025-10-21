// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Premium chat list + conversation UI with subtle iMessage-like polish
/// - GetX for simple state management
/// - Hero transitions from list avatar to header
/// - Animated unread badges, pressed effects
/// - Message bubble animations + date separators
/// - Typing indicator bubble (three bouncing dots)
/// - Frosted glass input bar, animated send/mic
/// Replace sample data/logic with your Firebase streams when integrating backend.

class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastTimestamp;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastTimestamp,
    this.avatarUrl = '',
    this.unreadCount = 0,
    this.isOnline = false,
  });

  Chat copyWith({
    String? id,
    String? name,
    String? lastMessage,
    DateTime? lastTimestamp,
    String? avatarUrl,
    int? unreadCount,
    bool? isOnline,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTimestamp: lastTimestamp ?? this.lastTimestamp,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class Message {
  final String id;
  final String text;
  final String senderId;
  final DateTime time;
  final bool isMe;

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.time,
    required this.isMe,
  });
}

class ChatListController extends GetxController {
  final RxList<Chat> chats = <Chat>[].obs;
  final RxString query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleChats();
  }

  void _loadSampleChats() {
    chats.assignAll([
      Chat(
        id: '1',
        name: 'Aisha Thompson',
        lastMessage: 'Thanks — I will check and get back to you.',
        lastTimestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        avatarUrl: '',
        unreadCount: 2,
        isOnline: true,
      ),
      Chat(
        id: '2',
        name: 'Property Owner',
        lastMessage: 'The viewing is confirmed for tomorrow 3pm.',
        lastTimestamp: DateTime.now().subtract(
          const Duration(hours: 3, minutes: 4),
        ),
        avatarUrl: '',
        unreadCount: 0,
        isOnline: false,
      ),
      Chat(
        id: '3',
        name: 'Support',
        lastMessage: 'We have received your enquiry.',
        lastTimestamp: DateTime.now().subtract(
          const Duration(days: 1, hours: 2),
        ),
        avatarUrl: '',
        unreadCount: 0,
        isOnline: true,
      ),
      Chat(
        id: '4',
        name: 'Lettings Team',
        lastMessage: 'Please upload your documents when ready.',
        lastTimestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        avatarUrl: '',
        unreadCount: 1,
        isOnline: false,
      ),
    ]);
  }

  void markRead(String chatId) {
    final idx = chats.indexWhere((c) => c.id == chatId);
    if (idx != -1) {
      chats[idx] = chats[idx].copyWith(unreadCount: 0);
    }
  }

  List<Chat> filtered() {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return chats;
    return chats
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.lastMessage.toLowerCase().contains(q),
        )
        .toList();
  }
}

class ChatConversationController extends GetxController {
  final String chatId;
  final String chatName;

  final RxList<Message> messages = <Message>[].obs;
  final RxBool otherTyping = false.obs;
  final RxString inputText = ''.obs;
  final TextEditingController inputController = TextEditingController();

  Timer? _typingLoop;

  ChatConversationController(this.chatId, this.chatName);

  @override
  void onInit() {
    super.onInit();
    _loadSampleMessages();
    _startDemoTyping(); // remove when using real backend typing events
  }

  void _loadSampleMessages() {
    messages.assignAll([
      Message(
        id: 'm1',
        text: 'Hi, I’m interested in the 2-bedroom flat.',
        senderId: 'user_1',
        time: DateTime.now().subtract(const Duration(hours: 5, minutes: 3)),
        isMe: false,
      ),
      Message(
        id: 'm2',
        text:
            'Thanks for your message — can you share available dates for viewing?',
        senderId: 'me',
        time: DateTime.now().subtract(const Duration(hours: 4, minutes: 50)),
        isMe: true,
      ),
      Message(
        id: 'm3',
        text: 'I’m available tomorrow afternoon.',
        senderId: 'user_1',
        time: DateTime.now().subtract(const Duration(hours: 4, minutes: 35)),
        isMe: false,
      ),
    ]);
  }

  void _startDemoTyping() {
    _typingLoop?.cancel();
    _typingLoop = Timer.periodic(const Duration(seconds: 7), (_) async {
      otherTyping.value = true;
      await Future.delayed(const Duration(seconds: 2));
      otherTyping.value = false;
      // Demo incoming auto-reply
      final reply = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Sure, does 3pm work for you?',
        senderId: 'user_1',
        time: DateTime.now(),
        isMe: false,
      );
      messages.add(reply);
    });
  }

  void sendMessage() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: 'me',
      time: DateTime.now(),
      isMe: true,
    );
    messages.add(msg);
    inputController.clear();
    inputText.value = '';
    // In production, push to backend and rely on stream to update the list.
  }

  @override
  void onClose() {
    _typingLoop?.cancel();
    inputController.dispose();
    super.onClose();
  }
}

class EnquiryFirstPage extends StatelessWidget {
  EnquiryFirstPage({super.key});

  final ChatListController _chatListController = Get.put(ChatListController());

  String _formatTimestamp(DateTime ts) {
    final now = DateTime.now();
    if (now.difference(ts).inDays == 0) {
      return DateFormat('h:mm a').format(ts);
    } else if (now.difference(ts).inDays == 1) {
      return 'Yesterday';
    } else if (now.difference(ts).inDays < 7) {
      return DateFormat.E().format(ts);
    } else {
      return DateFormat.MMMd().format(ts);
    }
  }

  Widget _avatar(Chat c) {
    if (c.avatarUrl.isNotEmpty) {
      return Hero(
        tag: 'avatar_${c.id}',
        child: CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(c.avatarUrl),
        ),
      );
    }
    final initials = c.name
        .trim()
        .split(RegExp(r'\s+'))
        .map((s) => s.isNotEmpty ? s[0] : '')
        .take(2)
        .join();
    return Hero(
      tag: 'avatar_${c.id}',
      child: Stack(
        children: [
          CircleAvatar(radius: 26, child: Text(initials)),
          Positioned(
            right: 2,
            bottom: 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: c.isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: Stack(
        children: [
          // Soft gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.08),
                  theme.colorScheme.surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: _SearchField(
                  onChanged: (v) => _chatListController.query.value = v,
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = _chatListController.filtered();
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'No Enquiries',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'When someone messages you, it appears here.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 4, bottom: 24),
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 88),
                    itemBuilder: (context, i) {
                      final chat = list[i];
                      return _Pressable(
                        onTap: () {
                          _chatListController.markRead(chat.id);
                          Get.to(
                            () => ChatConversationPage(
                              chatId: chat.id,
                              chatName: chat.name,
                              isOnline: chat.isOnline,
                            ),
                            transition: Transition.cupertino,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              _avatar(chat),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chat.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTimestamp(chat.lastTimestamp),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chat.lastMessage,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: Colors.grey[700],
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        AnimatedScale(
                                          scale: chat.unreadCount > 0 ? 1 : 0.6,
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          child: AnimatedOpacity(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            opacity: chat.unreadCount > 0
                                                ? 1
                                                : 0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    theme.colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '${chat.unreadCount}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatConversationPage extends StatefulWidget {
  final String chatId;
  final String chatName;
  final bool isOnline;

  const ChatConversationPage({
    required this.chatId,
    required this.chatName,
    this.isOnline = false,
    super.key,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  late final ChatConversationController _controller;
  final ScrollController _scrollController = ScrollController();
  final Set<String> _animated = <String>{};
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      ChatConversationController(widget.chatId, widget.chatName),
      tag: widget.chatId,
    );
    // auto-scroll on new messages
    ever<List<Message>>(_controller.messages, (_) => _scrollToBottom());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = 80.0;
    final atBottom =
        _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels <
        threshold;
    if (_showScrollToBottom == atBottom) {
      setState(() => _showScrollToBottom = !atBottom);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Get.delete<ChatConversationController>(tag: widget.chatId);
    super.dispose();
  }

  Widget _dateChip(DateTime d, ThemeData theme) {
    String label;
    final now = DateTime.now();
    final diff = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(d.year, d.month, d.day)).inDays;
    if (diff == 0) {
      label = 'Today';
    } else if (diff == 1) {
      label = 'Yesterday';
    } else {
      label = DateFormat.MMMd().format(d);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
        ),
      ),
    );
  }

  Widget _messageBubble(Message m, ThemeData theme) {
    final isMe = m.isMe;
    final bg = isMe
        ? LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.85),
            ],
          )
        : null;
    final color = isMe ? Colors.white : theme.colorScheme.onSurface;
    final containerColor = isMe
        ? null
        : theme.colorScheme.surfaceVariant.withOpacity(0.7);

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.74,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: containerColor,
          gradient: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 14 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          m.text,
          style: TextStyle(color: color, fontSize: 15, height: 1.25),
        ),
      ),
    );

    // One-time slide+fade on first appearance of this message id
    final firstTime = _animated.add(m.id);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOut,
        transitionBuilder: (child, anim) {
          final offset = Tween<Offset>(
            begin: Offset(isMe ? 0.1 : -0.1, 0),
            end: Offset.zero,
          ).animate(anim);
          final fade = CurvedAnimation(parent: anim, curve: Curves.easeOut);
          return SlideTransition(
            position: offset,
            child: FadeTransition(opacity: fade, child: child),
          );
        },
        child: firstTime
            ? bubble
            : KeyedSubtree(key: ValueKey(m.id), child: bubble),
      ),
    );
  }

  Widget _typingBubble(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: const _TypingDots(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            Hero(
              tag: 'avatar_${widget.chatId}',
              child: CircleAvatar(
                radius: 18,
                child: Text(
                  widget.chatName.isNotEmpty ? widget.chatName[0] : '?',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6, top: 2),
                      decoration: BoxDecoration(
                        color: widget.isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      widget.isOnline ? 'Online' : 'Offline',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // soft top gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.06),
                  theme.colorScheme.surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: kToolbarHeight + 8),
              Expanded(
                child: Obx(() {
                  final msgs = _controller.messages;
                  final children = <Widget>[];
                  DateTime? lastDate;

                  for (var i = 0; i < msgs.length; i++) {
                    final m = msgs[i];
                    if (lastDate == null ||
                        lastDate!.year != m.time.year ||
                        lastDate!.month != m.time.month ||
                        lastDate!.day != m.time.day) {
                      children.add(_dateChip(m.time, theme));
                      lastDate = m.time;
                    }
                    children.add(_messageBubble(m, theme));
                  }

                  return ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 8, bottom: 110),
                    children: [
                      ...children,
                      Obx(
                        () => _controller.otherTyping.value
                            ? _typingBubble(theme)
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                }),
              ),
              _InputBar(controller: _controller),
            ],
          ),
          // Scroll-to-bottom
          Positioned(
            right: 16,
            bottom: 96,
            child: AnimatedSlide(
              offset: _showScrollToBottom ? Offset.zero : const Offset(0, 0.5),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: _showScrollToBottom ? 1 : 0,
                child: FloatingActionButton.small(
                  onPressed: _scrollToBottom,
                  child: const Icon(Icons.arrow_downward),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search enquiries',
            filled: true,
            fillColor: theme.colorScheme.surface.withOpacity(0.7),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _Pressable({required this.child, required this.onTap});

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
  );
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _c.forward(),
      onTapCancel: () => _c.reverse(),
      onTapUp: (_) {
        _c.reverse();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, child) {
          final scale = 1 - (_c.value * 0.02);
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.child,
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();
  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = List.generate(3, (i) {
      final curve = CurvedAnimation(
        parent: _ac,
        curve: Interval(i * 0.15, 0.6 + i * 0.15, curve: Curves.easeInOut),
      );
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1.0).animate(curve),
          child: const _Dot(),
        ),
      );
    });
    return Row(mainAxisSize: MainAxisSize.min, children: dots);
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.black54,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final ChatConversationController controller;
  const _InputBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.75),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.inputController,
                      minLines: 1,
                      maxLines: 5,
                      onChanged: (v) => controller.inputText.value = v.trim(),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: (_) => controller.sendMessage(),
                    ),
                  ),
                  Obx(() {
                    final hasText = controller.inputText.value.isNotEmpty;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: anim,
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: hasText
                          ? CircleAvatar(
                              key: const ValueKey('send'),
                              backgroundColor: theme.colorScheme.primary,
                              radius: 22,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: controller.sendMessage,
                              ),
                            )
                          : CircleAvatar(
                              key: const ValueKey('mic'),
                              backgroundColor: theme.colorScheme.surfaceVariant,
                              radius: 22,
                              child: IconButton(
                                icon: const Icon(Icons.mic_none),
                                onPressed: () {},
                              ),
                            ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
