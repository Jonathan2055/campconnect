import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';

/// Single source of truth for the app. Screens read from it with
/// context.watch<AppState>() and trigger changes with context.read<AppState>().
/// Every mutation calls notifyListeners() so the UI rebuilds reactively.
class AppState extends ChangeNotifier {
  // RSVPs we pre-seed so "My RSVPs" isn't empty on first launch.
  static const _seededGoing = {'e1', 'e2', 'e4'};
  static const _seededInterested = {'e3'};

  bool isLoggedIn = false;
  AppUser currentUser = MockData.currentUser;

  final List<Post> _posts = MockData.posts();
  final List<Community> _communities = MockData.communities();
  final List<ChatThread> _chats = MockData.chats();
  final List<FeedEntry> _feedEntries = MockData.feedEntries();
  final Set<String> _going = {..._seededGoing};
  final Set<String> _interested = {..._seededInterested};

  // ---- Read-only views ----
  List<Post> get posts => List.unmodifiable(_posts);
  List<FeedEntry> get feedEntries => List.unmodifiable(_feedEntries);
  List<Post> get featured => _posts.where((p) => p.featured).toList();
  List<Post> get events =>
      _posts.where((p) => p.type == PostType.event).toList();
  List<Post> get opportunities =>
      _posts.where((p) => p.type == PostType.opportunity).toList();
  List<Community> get communities => List.unmodifiable(_communities);
  List<Community> get myCommunities =>
      _communities.where((c) => c.joined).toList();
  List<ChatThread> get chats => List.unmodifiable(_chats);
  List<Post> get goingPosts =>
      _posts.where((p) => _going.contains(p.id)).toList();
  List<Post> get interestedPosts =>
      _posts.where((p) => _interested.contains(p.id)).toList();

  int get totalUnread => _chats.fold(0, (sum, c) => sum + c.unread);

  bool isGoing(String id) => _going.contains(id);
  bool isInterested(String id) => _interested.contains(id);

  // ---- Auth ----
  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void signUp(String name) {
    currentUser = currentUser.copyWith(name: name);
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  // ---- Profile ----
  void updateProfile(String name, String campus) {
    currentUser = currentUser.copyWith(name: name, campus: campus);
    notifyListeners();
  }

  // ---- New chat ----
  void startNewChat(String name, Color color) {
    _chats.insert(
      0,
      ChatThread(
        id: 'ch${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        color: color,
        isGroup: false,
        lastMessagePreview: 'Say hello!',
        time: 'Now',
      ),
    );
    notifyListeners();
  }

  // ---- Communities ----
  void addCommunity(Community community) {
    _communities.add(community);
    notifyListeners();
  }

  // ---- RSVP / participation ----
  void toggleGoing(String id) {
    if (_going.remove(id)) {
      notifyListeners();
      return;
    }
    _going.add(id);
    _interested.remove(id); // going and interested are mutually exclusive
    notifyListeners();
  }

  void toggleInterested(String id) {
    if (_interested.remove(id)) {
      notifyListeners();
      return;
    }
    _interested.add(id);
    _going.remove(id);
    notifyListeners();
  }

  // ---- Communities ----
  void toggleJoin(String id) {
    final c = _communities.firstWhere((c) => c.id == id);
    c.joined = !c.joined;
    notifyListeners();
  }

  // ---- Posting ----
  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  // ---- Feed ----
  void addFeedEntry(FeedEntry entry) {
    _feedEntries.insert(0, entry);
    notifyListeners();
  }

  void toggleFeedLike(String id) {
    final entry = _feedEntries.firstWhere((e) => e.id == id);
    if (entry.likedByMe) {
      entry.likedByMe = false;
      entry.likes -= 1;
    } else {
      entry.likedByMe = true;
      entry.likes += 1;
    }
    notifyListeners();
  }

  void addFeedComment(String feedId, String text) {
    final entry = _feedEntries.firstWhere((e) => e.id == feedId);
    entry.comments.add(FeedComment(
      id: 'fc${DateTime.now().millisecondsSinceEpoch}',
      authorName: currentUser.name,
      authorColor: currentUser.color,
      text: text,
      timeAgo: 'Just now',
    ));
    notifyListeners();
  }

  // ---- Chat ----
  void sendMessage(String threadId, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final thread = _chats.firstWhere((c) => c.id == threadId);
    thread.messages.add(Message(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      sender: currentUser.name,
      text: trimmed,
      time: 'Now',
      isMe: true,
    ));
    thread.lastMessagePreview = 'You: $trimmed';
    thread.time = 'Now';
    notifyListeners();
  }

  void markRead(String threadId) {
    final thread = _chats.firstWhere((c) => c.id == threadId);
    if (thread.unread != 0) {
      thread.unread = 0;
      notifyListeners();
    }
  }

  // Live counts that reflect the current user's own toggle without
  // double-counting the seeded RSVPs already baked into the mock numbers.
  int displayedGoing(Post p) {
    final going = isGoing(p.id);
    final seeded = _seededGoing.contains(p.id);
    if (going && !seeded) return p.goingCount + 1;
    if (!going && seeded) return p.goingCount - 1;
    return p.goingCount;
  }

  int displayedInterested(Post p) {
    final interested = isInterested(p.id);
    final seeded = _seededInterested.contains(p.id);
    if (interested && !seeded) return p.interestedCount + 1;
    if (!interested && seeded) return p.interestedCount - 1;
    return p.interestedCount;
  }
}
