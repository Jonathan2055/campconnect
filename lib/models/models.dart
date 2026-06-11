import 'package:flutter/material.dart';

enum PostType { event, opportunity }

enum FeedEntryType { experience, promotion }

class FeedComment {
  final String id;
  final String authorName;
  final Color authorColor;
  final String text;
  final String timeAgo;

  FeedComment({
    required this.id,
    required this.authorName,
    required this.authorColor,
    required this.text,
    required this.timeAgo,
  });
}

class FeedEntry {
  final String id;
  final String authorName;
  final Color authorColor;
  final String content;
  final FeedEntryType type;
  final String timeAgo;
  final String? linkedEventId;
  final String? linkedEventTitle;
  final String? linkedEventDate;
  final String? linkedEventLocation;
  final List<Color>? linkedEventGradient;
  int likes;
  bool likedByMe;
  final List<FeedComment> comments;

  FeedEntry({
    required this.id,
    required this.authorName,
    required this.authorColor,
    required this.content,
    required this.type,
    required this.timeAgo,
    this.linkedEventId,
    this.linkedEventTitle,
    this.linkedEventDate,
    this.linkedEventLocation,
    this.linkedEventGradient,
    this.likes = 0,
    this.likedByMe = false,
    List<FeedComment>? comments,
  }) : comments = comments ?? [];
}

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

  AppUser copyWith({
    String? name,
    String? campus,
    Color? color,
    int? events,
    int? communities,
    int? connections,
  }) {
    return AppUser(
      name: name ?? this.name,
      campus: campus ?? this.campus,
      color: color ?? this.color,
      events: events ?? this.events,
      communities: communities ?? this.communities,
      connections: connections ?? this.connections,
    );
  }
}
