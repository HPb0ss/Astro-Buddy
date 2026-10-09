import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/astro_theme.dart';
import '../../core/theme/theme_provider.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? referencedObject;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.referencedObject,
  });
}

class AiCompanionScreen extends ConsumerStatefulWidget {
  const AiCompanionScreen({super.key});

  @override
  ConsumerState<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends ConsumerState<AiCompanionScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Clear skies tonight! With your 10×50 binoculars, Saturn is sitting at 48° altitude in the southeast. You can easily resolve it as an elongated oval rather than a point.\n\nWhat would you like to explore tonight?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = text.trim();
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: userMsg,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();

    // Context-aware simulated assistant response grounded in live context
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      String response = '';
      if (userMsg.toLowerCase().contains('saturn')) {
        response =
            'Saturn is currently at azimuth 145° (SE) and 48° altitude. Under your Bortle 4 skies and low 4% cloud cover, you will see its gold-amber hue clearly. With 10x magnification, use a tripod or lean against a car roof to see the rings as distinct extensions on either side of the globe!';
      } else if (userMsg.toLowerCase().contains('pleiades') || userMsg.toLowerCase().contains('seven sisters')) {
        response =
            'The Pleiades (M45) is rising at 62° altitude in Taurus. Through your 10×50 binoculars, the field of view (~6.5°) will frame the entire cluster beautifully, revealing dozens of diamond-like stars instead of just the 6 visible to the naked eye.';
      } else if (userMsg.toLowerCase().contains('plan') || userMsg.toLowerCase().contains('session')) {
        response =
            'Here is your 30-minute observing itinerary for tonight:\n\n1. 10:00 PM: Start with Saturn in the southeast while it reaches peak altitude.\n2. 10:15 PM: Swing north-east to the Pleiades (M45) for wide-field star clustering.\n3. 10:25 PM: Catch the Andromeda Galaxy (M31) near zenith using averted vision!';
      } else {
        response =
            'Based on your live conditions (Bortle 4, 4% clouds, 10×50 binoculars), this target is well within reach tonight! Look for stable seeing between 10:30 PM and 1:30 AM.';
      }

      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRed = ref.watch(isRedLightModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AstroBuddy AI Companion'),
        actions: [
          IconButton(
            tooltip: 'Toggle Field Red-Light Mode',
            icon: Icon(
              Icons.remove_red_eye_rounded,
              color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
            ),
            onPressed: () => ref.read(isRedLightModeProvider.notifier).toggle(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Live Sky Context Banner (Context Bus visual indicator)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: (isRed ? AstroColors.redLightSurfaceElevated : AstroColors.cosmosSurfaceElevated).withValues(alpha: 0.7),
            child: Row(
              children: [
                Icon(
                  Icons.sensors_rounded,
                  size: 16,
                  color: isRed ? AstroColors.redLightPrimary : AstroColors.auroralEmerald,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Live Context: Bortle 4 • Clear 4% • Gear: 10×50 Binos • 28 Objects above horizon',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isRed ? AstroColors.redLightTextMuted : AstroColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Message Thread
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.82,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? (isRed
                                ? AstroColors.redLightPrimary.withValues(alpha: 0.25)
                                : AstroColors.starlightCyan.withValues(alpha: 0.2))
                            : (isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurface),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: msg.isUser
                              ? (isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan)
                              : (isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!msg.isUser) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 13,
                                  color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'AstroBuddy (Context-Grounded)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                          ],
                          Text(
                            msg.text,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.45,
                              color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Suggested Context Prompt Chips
          Container(
            height: 38,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPromptChip('How should I observe Saturn tonight?'),
                const SizedBox(width: 8),
                _buildPromptChip('Plan a 30-min observing session'),
                const SizedBox(width: 8),
                _buildPromptChip('Can I see the Pleiades with my binoculars?'),
              ],
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            color: isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurface,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isRed ? AstroColors.redLightSurfaceElevated : AstroColors.cosmosSurfaceElevated,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder,
                      ),
                    ),
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _handleSendMessage,
                      style: TextStyle(
                        color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Ask AstroBuddy about tonight’s sky...',
                        hintStyle: TextStyle(
                          color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_upward_rounded,
                      color: isRed ? Colors.black : Colors.white,
                    ),
                    onPressed: () => _handleSendMessage(_textController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    final isRed = ref.watch(isRedLightModeProvider);
    return GestureDetector(
      onTap: () => _handleSendMessage(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: (isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurfaceElevated).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isRed ? AstroColors.redLightText : AstroColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
