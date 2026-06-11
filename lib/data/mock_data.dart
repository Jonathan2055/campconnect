import '../models/models.dart';
import '../theme/app_theme.dart';

/// Seed data. In a production build this would come from Firestore/Supabase;
/// here it lives in memory so the prototype is fully demoable offline.
class MockData {
  static const currentUser = AppUser(
    name: 'Aline Umuhoza',
    campus: 'Kigali Campus',
    color: AppColors.emerald,
    events: 23,
    communities: 5,
    connections: 87,
  );

  static List<Post> posts() => const [
        Post(
          id: 'e2',
          type: PostType.event,
          title: 'ALU Entrepreneurship Pitch Night',
          description:
              'Showcase your idea, get feedback, and connect with mentors from across the ALU network. Pitches are capped at 5 minutes followed by live Q&A.',
          organizer: 'Entrepreneurship Club',
          dateLabel: 'May 24, 2026 \u2022 6:00 PM',
          location: 'Kigali Campus \u2022 Main Auditorium',
          category: 'Startup',
          tags: ['Startup', 'Pitch'],
          coverGradient: [AppColors.purple, AppColors.blue],
          goingCount: 64,
          interestedCount: 31,
          featured: true,
        ),
        Post(
          id: 'e1',
          type: PostType.event,
          title: 'AI for Social Impact Workshop',
          description:
              'Learn how AI tools can be used to drive social impact in Africa. Hands-on session + group projects with real datasets from local NGOs.',
          organizer: 'Tech & Innovation Hub',
          dateLabel: 'June 5, 2026 \u2022 09:00 AM - 01:00 PM',
          location: 'Mauritius Campus \u2022 Innovation Lab',
          category: 'Tech',
          tags: ['Workshop', 'Tech'],
          coverGradient: [AppColors.blue, AppColors.teal],
          goingCount: 48,
          interestedCount: 12,
        ),
        Post(
          id: 'e3',
          type: PostType.event,
          title: 'Design Thinking Bootcamp',
          description:
              'A two-day intensive on human-centred design. Build empathy maps, prototype fast, and test with real users.',
          organizer: 'Design Society',
          dateLabel: 'May 30, 2026 \u2022 10:00 AM',
          location: 'Kigali Campus \u2022 Studio B',
          category: 'Workshop',
          tags: ['Design', 'Workshop'],
          coverGradient: [AppColors.pink, AppColors.purple],
          goingCount: 22,
          interestedCount: 40,
        ),
        Post(
          id: 'e4',
          type: PostType.event,
          title: 'Community Clean Up',
          description:
              'Join fellow students for a campus and neighbourhood clean-up drive. Gloves and refreshments provided.',
          organizer: 'Women in Leadership',
          dateLabel: 'May 18, 2026 \u2022 8:00 AM',
          location: 'Mauritius Campus',
          category: 'Community',
          tags: ['Community'],
          coverGradient: [AppColors.green, AppColors.teal],
          goingCount: 35,
          interestedCount: 9,
        ),
        Post(
          id: 'e5',
          type: PostType.event,
          title: 'ALU Climate Action Week',
          description:
              'A week of talks, workshops, and challenges focused on climate resilience across African campuses.',
          organizer: 'Sustainability Office',
          dateLabel: 'May 26 - 30, 2026',
          location: 'All Campuses',
          category: 'Community',
          tags: ['Climate', 'Event'],
          coverGradient: [AppColors.blue, AppColors.purple],
          goingCount: 120,
          interestedCount: 80,
        ),
        Post(
          id: 'e6',
          type: PostType.event,
          title: 'Build Your First MVP Workshop',
          description:
              'From idea to clickable prototype in one evening. Bring a laptop and a problem worth solving.',
          organizer: 'Tech & Innovation Hub',
          dateLabel: 'June 2, 2026 \u2022 5:00 PM',
          location: 'Kigali Campus \u2022 Lab 3',
          category: 'Tech',
          tags: ['Tech', 'Workshop'],
          coverGradient: [AppColors.emerald, AppColors.pink],
          goingCount: 18,
          interestedCount: 27,
        ),
        Post(
          id: 'o1',
          type: PostType.opportunity,
          title: 'Sustainable Solutions Challenge',
          description:
              'A pan-African competition to design sustainable solutions for local communities. Winning teams receive seed funding and mentorship.',
          organizer: 'ALU Ventures',
          dateLabel: 'Apply by May 20, 2026',
          location: 'Mauritius Campus',
          category: 'Competition',
          tags: ['Competition'],
          coverGradient: [AppColors.green, AppColors.blue],
          deadlineLabel: 'Apply by May 20, 2026',
        ),
        Post(
          id: 'o2',
          type: PostType.opportunity,
          title: 'Campus Ambassador Program',
          description:
              'Represent ALU, build your leadership profile, and earn a stipend. Open to all year groups across campuses.',
          organizer: 'Student Life',
          dateLabel: 'Apply by May 22, 2026',
          location: 'All Campuses',
          category: 'Opportunity',
          tags: ['Opportunity', 'Leadership'],
          coverGradient: [AppColors.purple, AppColors.pink],
          deadlineLabel: 'Apply by May 22, 2026',
        ),
        Post(
          id: 'o3',
          type: PostType.opportunity,
          title: 'Summer Internship: Fintech Kigali',
          description:
              'A 10-week paid internship with a Kigali-based fintech. Looking for students with Flutter/React or data skills.',
          organizer: 'Careers Team',
          dateLabel: 'Apply by June 1, 2026',
          location: 'Kigali',
          category: 'Internship',
          tags: ['Internship', 'Tech'],
          coverGradient: [AppColors.teal, AppColors.blue],
          deadlineLabel: 'Apply by June 1, 2026',
        ),
      ];

  static List<Community> communities() => [
        Community(
            id: 'c1',
            name: 'ALU Debate Society',
            members: 124,
            color: AppColors.emerald),
        Community(
            id: 'c2',
            name: 'Entrepreneurship Club',
            members: 250,
            color: AppColors.green,
            joined: true),
        Community(
            id: 'c3',
            name: 'Women in Leadership',
            members: 180,
            color: AppColors.purple),
        Community(
            id: 'c4',
            name: 'Tech & Innovation Hub',
            members: 210,
            color: AppColors.teal),
        Community(
            id: 'c5',
            name: 'Campus Leaders',
            members: 96,
            color: AppColors.blue),
      ];

  static List<FeedEntry> feedEntries() => [
        FeedEntry(
          id: 'f1',
          authorName: 'Kwame Asante',
          authorColor: AppColors.purple,
          content:
              'The AI Workshop yesterday was absolutely mind-blowing! We built a working poverty predictor using real NGO data in under 3 hours. If you missed it — run to the next one. Huge thanks to the Tech Hub team for organising this!',
          type: FeedEntryType.experience,
          timeAgo: '2h ago',
          likes: 34,
          comments: [
            FeedComment(
              id: 'fc1',
              authorName: 'Amara Diallo',
              authorColor: AppColors.pink,
              text: 'I was there too! Best session of the semester 🙌',
              timeAgo: '1h ago',
            ),
            FeedComment(
              id: 'fc2',
              authorName: 'David Okonkwo',
              authorColor: AppColors.blue,
              text: 'Agree! The facilitator was incredible.',
              timeAgo: '45m ago',
            ),
          ],
        ),
        FeedEntry(
          id: 'f2',
          authorName: 'Fatima Al-Hassan',
          authorColor: AppColors.teal,
          content:
              "Don't miss the Entrepreneurship Pitch Night this Friday! Last year's winner raised \$50K seed funding. This year could be YOUR turn. DM me if you need help with your deck.",
          type: FeedEntryType.promotion,
          timeAgo: '4h ago',
          linkedEventId: 'e2',
          linkedEventTitle: 'ALU Entrepreneurship Pitch Night',
          linkedEventDate: 'May 24, 2026 • 6:00 PM',
          linkedEventLocation: 'Kigali Campus • Main Auditorium',
          linkedEventGradient: [AppColors.purple, AppColors.blue],
          likes: 21,
          comments: [
            FeedComment(
              id: 'fc3',
              authorName: 'Aline Umuhoza',
              authorColor: AppColors.emerald,
              text: 'Will be there! 🔥',
              timeAgo: '3h ago',
            ),
          ],
        ),
        FeedEntry(
          id: 'f3',
          authorName: 'Jean-Paul Nkurunziza',
          authorColor: AppColors.blue,
          content:
              "Design Thinking Bootcamp day 1 done ✅ We spent 3 hours just listening to our users before writing a single line or sketching a wireframe. That patience is the real skill. #HumanCentredDesign",
          type: FeedEntryType.experience,
          timeAgo: '1d ago',
          likes: 47,
        ),
        FeedEntry(
          id: 'f4',
          authorName: 'Sarah Osei',
          authorColor: AppColors.pink,
          content:
              'Climate Action Week is coming to ALL campuses next week! We need volunteers for the tree-planting drive on Wednesday. This is your chance to make a real impact — sign up in the comments!',
          type: FeedEntryType.promotion,
          timeAgo: '1d ago',
          linkedEventId: 'e5',
          linkedEventTitle: 'ALU Climate Action Week',
          linkedEventDate: 'May 26 - 30, 2026',
          linkedEventLocation: 'All Campuses',
          linkedEventGradient: [AppColors.blue, AppColors.purple],
          likes: 58,
          comments: [
            FeedComment(
              id: 'fc4',
              authorName: 'Emmanuel Ndayizeye',
              authorColor: AppColors.green,
              text: 'Count me in! 🌳',
              timeAgo: '20h ago',
            ),
            FeedComment(
              id: 'fc5',
              authorName: 'Kwame Asante',
              authorColor: AppColors.purple,
              text: "I'll bring the whole dorm block 😂",
              timeAgo: '18h ago',
            ),
          ],
        ),
        FeedEntry(
          id: 'f5',
          authorName: 'Amara Diallo',
          authorColor: AppColors.pink,
          content:
              'Just submitted my application for the Campus Ambassador Program! Fingers crossed 🤞 If you\'re thinking about it — deadline is May 22. The experience is worth it, I heard from last year\'s cohort.',
          type: FeedEntryType.promotion,
          timeAgo: '2d ago',
          linkedEventId: 'o2',
          linkedEventTitle: 'Campus Ambassador Program',
          linkedEventDate: 'Apply by May 22, 2026',
          linkedEventLocation: 'All Campuses',
          linkedEventGradient: [AppColors.purple, AppColors.pink],
          likes: 29,
        ),
      ];

  static List<ChatThread> chats() => [
        ChatThread(
          id: 't1',
          name: 'AI Workshop Group',
          isGroup: true,
          membersCount: 32,
          color: AppColors.blue,
          lastMessagePreview: 'Fatima: Shared a file',
          time: '9:45 AM',
          unread: 2,
          messages: const [
            Message(
                id: 'm1',
                sender: 'Fatima',
                text:
                    "Hey team! Don't forget our session tomorrow at 9am. See you there!",
                time: '9:15 AM',
                reactions: 4,
                reactionEmoji: '\u2764\uFE0F'),
            Message(
                id: 'm2',
                sender: 'David',
                text: "Got it! I'll bring my laptop.",
                time: '9:18 AM',
                reactions: 2,
                reactionEmoji: '\uD83D\uDC4D'),
            Message(
                id: 'm3',
                sender: 'Aline Umuhoza',
                text: "Can't wait! \uD83D\uDD25",
                time: '9:20 AM',
                isMe: true),
            Message(
                id: 'm4',
                sender: 'Jean',
                text: 'Workshop Materials.pdf',
                time: '9:22 AM',
                attachmentName: 'Workshop Materials.pdf',
                attachmentSize: '2.4 MB \u2022 PDF'),
          ],
        ),
        ChatThread(
          id: 't2',
          name: 'Entrepreneurship Club',
          isGroup: true,
          membersCount: 250,
          color: AppColors.green,
          lastMessagePreview: "David: Don't forget the meeting",
          time: '10:30 AM',
          unread: 3,
          messages: const [
            Message(
                id: 'm5',
                sender: 'David',
                text: "Don't forget the meeting this Friday.",
                time: '10:30 AM'),
          ],
        ),
        ChatThread(
          id: 't3',
          name: 'Campus Leaders',
          isGroup: true,
          membersCount: 18,
          color: AppColors.blue,
          lastMessagePreview: 'Jean: See you there!',
          time: 'Yesterday',
          messages: const [
            Message(
                id: 'm6', sender: 'Jean', text: 'See you there!', time: 'Yesterday'),
          ],
        ),
        ChatThread(
          id: 't4',
          name: 'Travel Buddies',
          isGroup: true,
          membersCount: 7,
          color: AppColors.pink,
          lastMessagePreview: 'Sarah: Any updates?',
          time: 'Yesterday',
          messages: const [
            Message(
                id: 'm7', sender: 'Sarah', text: 'Any updates?', time: 'Yesterday'),
          ],
        ),
        ChatThread(
          id: 't5',
          name: 'ALU Debate Society',
          isGroup: true,
          membersCount: 124,
          color: AppColors.emerald,
          lastMessagePreview: 'Emmanuel: Great job!',
          time: '2d ago',
          messages: const [
            Message(
                id: 'm8',
                sender: 'Emmanuel',
                text: 'Great job everyone!',
                time: '2d ago'),
          ],
        ),
      ];
}
