import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camp_connect/main.dart';
import 'package:camp_connect/models/models.dart';
import 'package:camp_connect/state/app_state.dart';

void main() {
  group('AuthGate routing', () {
    testWidgets('shows LoginScreen when not logged in', (tester) async {
      await tester.pumpWidget(const ALUConnectApp());
      await tester.pump();
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Connect. Collaborate. Lead together.'), findsOneWidget);
    });

    testWidgets('shows MainShell after login', (tester) async {
      await tester.pumpWidget(const ALUConnectApp());
      await tester.pump();

      // Fill in valid credentials
      await tester.enterText(
          find.widgetWithText(TextField, 'Email address'), 'test@alu.edu');
      await tester.enterText(
          find.widgetWithText(TextField, 'Password'), 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Bottom nav should be visible
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Feed'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
    });
  });

  group('LoginScreen validation', () {
    testWidgets('rejects empty email', (tester) async {
      await tester.pumpWidget(const ALUConnectApp());
      await tester.pump();

      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Please enter a valid email address.'), findsOneWidget);
    });

    testWidgets('rejects invalid email (no @)', (tester) async {
      await tester.pumpWidget(const ALUConnectApp());
      await tester.pump();

      await tester.enterText(
          find.widgetWithText(TextField, 'Email address'), 'notanemail');
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Please enter a valid email address.'), findsOneWidget);
    });

    testWidgets('rejects short password', (tester) async {
      await tester.pumpWidget(const ALUConnectApp());
      await tester.pump();

      await tester.enterText(
          find.widgetWithText(TextField, 'Email address'), 'user@alu.edu');
      await tester.enterText(
          find.widgetWithText(TextField, 'Password'), '123');
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters.'), findsOneWidget);
    });

    testWidgets('sign-up mode requires full name', (tester) async {
      await tester.pumpWidget(const ALUConnectApp());
      await tester.pump();

      // Switch to sign-up
      await tester.tap(find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('Create account')));
      await tester.pump();

      expect(find.text('Create Account'), findsWidgets);

      // Submit without name
      await tester.enterText(
          find.widgetWithText(TextField, 'Email address'), 'user@alu.edu');
      await tester.enterText(
          find.widgetWithText(TextField, 'Password'), 'password123');
      await tester.tap(find.text('Create Account').last);
      await tester.pump();

      expect(find.text('Please enter your full name.'), findsOneWidget);
    });

    testWidgets('toggling sign-up clears error', (tester) async {
      await tester.pumpWidget(const ALUConnectApp());
      await tester.pump();

      // Trigger an error
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      expect(find.text('Please enter a valid email address.'), findsOneWidget);

      // Toggle to sign-up; error should clear
      await tester.tap(find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('Create account')));
      await tester.pump();
      expect(find.text('Please enter a valid email address.'), findsNothing);
    });
  });

  group('AppState unit tests', () {
    test('login sets isLoggedIn to true', () {
      final state = AppState();
      expect(state.isLoggedIn, isFalse);
      state.login();
      expect(state.isLoggedIn, isTrue);
    });

    test('logout sets isLoggedIn to false', () {
      final state = AppState();
      state.login();
      state.logout();
      expect(state.isLoggedIn, isFalse);
    });

    test('signUp updates name and logs in', () {
      final state = AppState();
      state.signUp('Test User');
      expect(state.isLoggedIn, isTrue);
      expect(state.currentUser.name, 'Test User');
    });

    test('toggleGoing adds and removes correctly', () {
      final state = AppState();
      const id = 'e6'; // not pre-seeded
      expect(state.isGoing(id), isFalse);
      state.toggleGoing(id);
      expect(state.isGoing(id), isTrue);
      state.toggleGoing(id);
      expect(state.isGoing(id), isFalse);
    });

    test('toggleInterested and toggleGoing are mutually exclusive', () {
      final state = AppState();
      const id = 'e6';
      state.toggleInterested(id);
      expect(state.isInterested(id), isTrue);
      state.toggleGoing(id);
      expect(state.isGoing(id), isTrue);
      expect(state.isInterested(id), isFalse);
    });

    test('toggleFeedLike increments and decrements likes', () {
      final state = AppState();
      final entry = state.feedEntries.first;
      final initialLikes = entry.likes;

      state.toggleFeedLike(entry.id);
      expect(state.feedEntries.first.likes, initialLikes + 1);
      expect(state.feedEntries.first.likedByMe, isTrue);

      state.toggleFeedLike(entry.id);
      expect(state.feedEntries.first.likes, initialLikes);
      expect(state.feedEntries.first.likedByMe, isFalse);
    });

    test('addFeedComment appends comment', () {
      final state = AppState();
      state.login();
      final entryId = state.feedEntries.first.id;
      final initialCount = state.feedEntries.first.comments.length;

      state.addFeedComment(entryId, 'Great post!');
      expect(state.feedEntries.first.comments.length, initialCount + 1);
      expect(state.feedEntries.first.comments.last.text, 'Great post!');
    });

    test('sendMessage trims whitespace and appends', () {
      final state = AppState();
      final threadId = state.chats.first.id;
      final initialCount = state.chats.first.messages.length;

      state.sendMessage(threadId, '  Hello  ');
      expect(state.chats.first.messages.length, initialCount + 1);
      expect(state.chats.first.messages.last.text, 'Hello');
    });

    test('sendMessage ignores blank text', () {
      final state = AppState();
      final threadId = state.chats.first.id;
      final initialCount = state.chats.first.messages.length;

      state.sendMessage(threadId, '   ');
      expect(state.chats.first.messages.length, initialCount);
    });

    test('markRead clears unread count', () {
      final state = AppState();
      final thread = state.chats.firstWhere((c) => c.unread > 0);
      expect(thread.unread, greaterThan(0));
      state.markRead(thread.id);
      expect(state.chats.firstWhere((c) => c.id == thread.id).unread, 0);
    });

    test('toggleJoin flips joined flag', () {
      final state = AppState();
      final community = state.communities.first;
      final before = community.joined;
      state.toggleJoin(community.id);
      expect(state.communities.first.joined, !before);
    });

    test('displayedGoing adjusts count for non-seeded toggle', () {
      final state = AppState();
      final post = state.posts.firstWhere((p) => p.id == 'e6');
      final base = post.goingCount;
      expect(state.displayedGoing(post), base);
      state.toggleGoing(post.id);
      expect(state.displayedGoing(post), base + 1);
    });

    test('updateProfile changes name and campus', () {
      final state = AppState();
      state.updateProfile('New Name', 'Mauritius Campus');
      expect(state.currentUser.name, 'New Name');
      expect(state.currentUser.campus, 'Mauritius Campus');
    });

    test('startNewChat inserts at front of chats list', () {
      final state = AppState();
      final before = state.chats.length;
      state.startNewChat('Alice', const Color(0xFF059669));
      expect(state.chats.length, before + 1);
      expect(state.chats.first.name, 'Alice');
    });

    test('addPost inserts at front', () {
      final state = AppState();
      final before = state.posts.length;
      state.addPost(const Post(
        id: 'test1',
        type: PostType.event,
        title: 'Test Event',
        description: 'desc',
        organizer: 'Me',
        dateLabel: 'Tomorrow',
        location: 'Kigali',
        category: 'Tech',
        coverGradient: [Color(0xFF059669), Color(0xFF0EA5E9)],
      ));
      expect(state.posts.length, before + 1);
      expect(state.posts.first.id, 'test1');
    });

    test('goingPosts and interestedPosts reflect seeded state', () {
      final state = AppState();
      // e1, e2, e4 are seeded going
      expect(state.goingPosts.map((p) => p.id), containsAll(['e1', 'e2', 'e4']));
      // e3 is seeded interested
      expect(state.interestedPosts.map((p) => p.id), contains('e3'));
    });

    test('totalUnread sums all chat unread counts', () {
      final state = AppState();
      final expected = state.chats.fold(0, (s, c) => s + c.unread);
      expect(state.totalUnread, expected);
    });
  });
}
