import 'package:flutter/material.dart';

enum PostType { event, opportunity }

/// A unified model for both events and opportunities so the feed can mix them.
class Post {
  final String id;
  final PostType type;
  final String title;
  final String description;
  final String organizer;
  final String dateLabel;
  final String location;
  final String category;
  final List<String> tags;
  final List<Color> coverGradient;
  final int goingCount;
  final int interestedCount;
  final String? deadlineLabel;
  final bool featured;

  const Post({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.organizer,
    required this.dateLabel,
    required this.location,
    required this.category,
    this.tags = const [],
    required this.coverGradient,
    this.goingCount = 0,
    this.interestedCount = 0,
    this.deadlineLabel,
    this.featured = false,
  });
}

class Community {
  final String id;
  final String name;
  final int members;
  final Color color;
  bool joined;

  Community({
    required this.id,
    required this.name,
    required this.members,
    required this.color,
    this.joined = false,
  });
}

class Message {
  final String id;
  final String sender;
  final String text;
  final String time;
  final bool isMe;
  final int reactions;
  final String? reactionEmoji;
  final String? attachmentName;
  final String? attachmentSize;

  const Message({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
    this.isMe = false,
    this.reactions = 0,
    this.reactionEmoji,
    this.attachmentName,
    this.attachmentSize,
  });
}

class ChatThread {
  final String id;
  final String name;
  final bool isGroup;
  final int membersCount;
  final Color color;
  String lastMessagePreview;
  String time;
  int unread;
  final List<Message> messages;

  ChatThread({
    required this.id,
    required this.name,
    required this.color,
    this.isGroup = false,
    this.membersCount = 0,
    this.lastMessagePreview = '',
    this.time = '',
    this.unread = 0,
    List<Message>? messages,
  }) : messages = messages ?? [];
}

class AppUser {
  final String name;
  final String campus;
  final Color color;
  final int events;
  final int communities;
  final int connections;

  const AppUser({
    required this.name,
    required this.campus,
    required this.color,
    this.events = 0,
    this.communities = 0,
    this.connections = 0,
  });
}
