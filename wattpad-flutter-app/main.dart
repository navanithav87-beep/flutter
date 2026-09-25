import 'package:flutter/material.dart';

void main() {
  runApp(const WattpadApp());
}

const orange = Color(0xFFFF6B00);

class WattpadApp extends StatelessWidget {
  const WattpadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wattpad',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F8F6),
        colorScheme: ColorScheme.fromSeed(seedColor: orange),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 1,
          margin: EdgeInsets.zero,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// -----------------------------------------------------------------------------
// MODELS
// -----------------------------------------------------------------------------

class AppUser {
  String name;
  String username;
  String email;
  String avatar;
  String bio;

  AppUser({
    required this.name,
    required this.username,
    required this.email,
    required this.avatar,
    this.bio = 'Reading stories, discovering new worlds and sharing ideas.',
  });
}

class UserPreferences {
  List<String> interests;
  List<String> preferredGenres;
  List<String> contentTypes;

  UserPreferences({
    required this.interests,
    required this.preferredGenres,
    required this.contentTypes,
  });
}

class Story {
  final String title;
  final String author;
  final String description;
  final String genre;
  final String emoji;
  final int reads;
  int votes;
  final int chapters;
  final Color coverColor;
  bool liked;
  bool saved;

  Story({
    required this.title,
    required this.author,
    required this.description,
    required this.genre,
    required this.emoji,
    required this.reads,
    required this.votes,
    required this.chapters,
    required this.coverColor,
    this.liked = false,
    this.saved = false,
  });
}

class Creator {
  final String username;
  final String displayName;
  final String avatar;
  final int followers;
  bool followed;

  Creator({
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.followers,
    this.followed = false,
  });
}

String formatNumber(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
  }
  return '$value';
}

InputDecoration inputDecoration(
  String label,
  IconData icon, {
  Widget? suffix,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  );
}

// -----------------------------------------------------------------------------
// LOGIN
// -----------------------------------------------------------------------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WattpadHome(
            user: AppUser(
              name: emailController.text.split('@').first,
              username: emailController.text.split('@').first.toLowerCase(),
              email: emailController.text.trim(),
              avatar: '📚',
              bio: 'Reading stories, discovering new worlds and sharing ideas.',
            ),
          ),
        ),
      );
    });
  }

  Future<void> googleLogin() async {
    final account = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const GoogleAccountDialog(),
    );

    if (account == null || !mounted) return;

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WattpadHome(
          user: AppUser(
            name: account['name']!,
            username: 'storylover',
            email: account['email']!,
            avatar: '🌟',
            bio: 'Reading stories, discovering new worlds and sharing ideas.',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: orange.withValues(alpha: .12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 45,
                        color: orange,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Wattpad',
                      style: TextStyle(
                        color: orange,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Read. Write. Discover.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 45),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputDecoration(
                        'Email',
                        Icons.email_outlined,
                      ),
                      validator: (value) =>
                          value == null || !value.contains('@')
                              ? 'Enter a valid email'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: inputDecoration(
                        'Password',
                        Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(
                            () => obscurePassword = !obscurePassword,
                          ),
                        ),
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? 'Password must contain at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: loading ? null : login,
                        style: FilledButton.styleFrom(
                          backgroundColor: orange,
                        ),
                        child: loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 17),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: loading ? null : googleLogin,
                        icon: const Text(
                          'G',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        label: const Text('Continue with Google'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Demo Google login is simulated locally for DartPad.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleAccountDialog extends StatelessWidget {
  const GoogleAccountDialog({super.key});

  Widget accountTile(
    BuildContext context, {
    required String name,
    required String email,
    required String avatar,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.pop(
        context,
        {'name': name, 'email': email},
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: orange.withValues(alpha: .12),
              foregroundColor: orange,
              child: Text(
                avatar,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: const Text(
        'Choose a Google Account',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          accountTile(
            context,
            name: 'Google User',
            email: 'user@gmail.com',
            avatar: 'G',
          ),
          const SizedBox(height: 10),
          accountTile(
            context,
            name: 'Demo User',
            email: 'demo@gmail.com',
            avatar: 'D',
          ),
          const SizedBox(height: 16),
          const Text(
            'Simulated Google login for this DartPad prototype.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// REGISTER
// -----------------------------------------------------------------------------

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFFFFF0E6),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 48,
                    color: orange,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Join Wattpad',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create an account and start your reading journey.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignUpPage(),
                      ),
                    ),
                    style: FilledButton.styleFrom(backgroundColor: orange),
                    child: const Text('Create New Account'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('I Already Have an Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void createAccount() {
    if (!formKey.currentState!.validate()) return;

    final username = usernameController.text.trim();
    final email = emailController.text.trim();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => WattpadHome(
          user: AppUser(
            name: username,
            username: username.toLowerCase(),
            email: email,
            avatar: '😀',
            bio: 'Reading stories, discovering new worlds and sharing ideas.',
          ),
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tell us a little about yourself.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: usernameController,
                      decoration: inputDecoration(
                        'Username',
                        Icons.person_outline,
                      ),
                      validator: (value) =>
                          value == null || value.trim().length < 3
                              ? 'Enter at least 3 characters'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputDecoration(
                        'Email',
                        Icons.email_outlined,
                      ),
                      validator: (value) =>
                          value == null || !value.contains('@')
                              ? 'Enter a valid email'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: inputDecoration(
                        'Password',
                        Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(
                            () => obscurePassword = !obscurePassword,
                          ),
                        ),
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: createAccount,
                        style: FilledButton.styleFrom(backgroundColor: orange),
                        child: const Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN APP STATE
// -----------------------------------------------------------------------------

class WattpadHome extends StatefulWidget {
  final AppUser user;

  const WattpadHome({super.key, required this.user});

  @override
  State<WattpadHome> createState() => _WattpadHomeState();
}

class _WattpadHomeState extends State<WattpadHome> {
  int selectedIndex = 0;
  late AppUser currentUser;
  late UserPreferences preferences;
  late List<Story> stories;
  late List<Creator> creators;
  final List<Story> recentlyRead = [];
  final List<Story> myStories = [];

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;

    preferences = UserPreferences(
      interests: ['AI', 'Technology', 'Romance', 'Mystery'],
      preferredGenres: ['Romance', 'Mystery', 'Fantasy'],
      contentTypes: ['Short Stories', 'Popular Stories'],
    );

    stories = createStories();
    creators = createCreators();
    myStories.add(
      Story(
        title: 'My First Chapter',
        author: currentUser.username,
        description: 'A personal draft waiting to become a complete story.',
        genre: 'Young Adult',
        emoji: '✍️',
        reads: 12,
        votes: 3,
        chapters: 2,
        coverColor: const Color(0xFFFFCC80),
      ),
    );
  }

  List<Story> createStories() {
    return [
      Story(
        title: 'The Last Summer',
        author: 'MayaWrites',
        description:
            'Two old friends return to the beach town where their story began and discover that some feelings never really disappear.',
        genre: 'Romance',
        emoji: '🌅',
        reads: 125000,
        votes: 18200,
        chapters: 24,
        coverColor: const Color(0xFFFFB74D),
      ),
      Story(
        title: 'Beyond The Stars',
        author: 'Alex Carter',
        description:
            'An astronaut receives a mysterious transmission from beyond the edge of known space.',
        genre: 'Science Fiction',
        emoji: '🚀',
        reads: 98500,
        votes: 14300,
        chapters: 18,
        coverColor: const Color(0xFF7986CB),
      ),
      Story(
        title: 'Mystery at Midnight',
        author: 'NoirNova',
        description:
            'At exactly midnight, every clock in the city stops. One detective notices that only one person is still moving.',
        genre: 'Mystery',
        emoji: '🕵️',
        reads: 156000,
        votes: 24500,
        chapters: 31,
        coverColor: const Color(0xFF607D8B),
      ),
      Story(
        title: 'Letters We Never Sent',
        author: 'LunaPages',
        description:
            'A box of forgotten letters reconnects two families across three generations.',
        genre: 'Romance',
        emoji: '💌',
        reads: 113000,
        votes: 19900,
        chapters: 20,
        coverColor: const Color(0xFFF48FB1),
      ),
      Story(
        title: 'The Hidden City',
        author: 'AriaQuest',
        description:
            'A map hidden inside an old library book leads a young explorer to a city that does not appear on any modern map.',
        genre: 'Adventure',
        emoji: '🏛️',
        reads: 201000,
        votes: 33100,
        chapters: 42,
        coverColor: const Color(0xFF81C784),
      ),
    ];
  }

  List<Creator> createCreators() {
    return [
      Creator(
        username: 'MayaWrites',
        displayName: 'Maya',
        avatar: '🌸',
        followers: 128000,
      ),
      Creator(
        username: 'NoirNova',
        displayName: 'Nova',
        avatar: '🖤',
        followers: 96500,
      ),
    ];
  }

  List<Story> recommendedStories() {
    final selectedGenres = preferences.preferredGenres.toSet();
    final matches = stories
        .where((story) => selectedGenres.contains(story.genre))
        .toList();

    if (matches.length >= 5) {
      return matches.take(5).toList();
    }

    final fallback = [...stories];
    fallback.removeWhere(matches.contains);

    return [...matches, ...fallback].take(5).toList();
  }

  void openStory(Story story) {
    recentlyRead.remove(story);
    recentlyRead.insert(0, story);
    setState(() {});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoryDetailsPage(
          story: story,
          allStories: stories,
          onChanged: () => setState(() {}),
          onStartReading: () => openReading(story),
        ),
      ),
    );
  }

  void openReading(Story story) {
    recentlyRead.remove(story);
    recentlyRead.insert(0, story);
    setState(() {});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReadingPage(
          story: story,
          onChanged: () => setState(() {}),
        ),
      ),
    );
  }

  void toggleSave(Story story) {
    setState(() {
      story.saved = !story.saved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          story.saved
              ? '${story.title} added to Saved Stories'
              : '${story.title} removed from Saved Stories',
        ),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void toggleLike(Story story) {
    setState(() {
      story.liked = !story.liked;
    });
  }

  void toggleFollow(Creator creator) {
    setState(() {
      creator.followed = !creator.followed;
    });
  }

  void showSearchPage() {
    showSearch<Story?>(
      context: context,
      delegate: StorySearchDelegate(
        stories: stories,
        onSelect: (story) {
          if (story != null) openStory(story);
        },
      ),
    );
  }

  Future<void> editProfile() async {
    final updated = await Navigator.push<AppUser>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(user: currentUser),
      ),
    );

    if (updated != null) {
      setState(() => currentUser = updated);
    }
  }

  Future<void> editPreferences() async {
    final updated = await Navigator.push<UserPreferences>(
      context,
      MaterialPageRoute(
        builder: (_) => PreferencesPage(preferences: preferences),
      ),
    );

    if (updated != null) {
      setState(() => preferences = updated);
    }
  }

  Future<void> logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: orange),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        user: currentUser,
        stories: stories,
        recommended: recommendedStories(),
        recent: recentlyRead,
        onStoryTap: openStory,
        onSave: toggleSave,
        onLike: toggleLike,
      ),
      DiscoverPage(
        stories: stories,
        creators: creators,
        preferences: preferences,
        onStoryTap: openStory,
        onFollow: toggleFollow,
        onSave: toggleSave,
      ),
      LibraryPage(
        stories: stories,
        recentlyRead: recentlyRead,
        onStoryTap: openStory,
        onSave: toggleSave,
      ),
      ProfilePage(
        user: currentUser,
        preferences: preferences,
        myStories: myStories,
        stories: stories,
        recentlyRead: recentlyRead,
        onEditProfile: editProfile,
        onPreferences: editPreferences,
        onStoryTap: openStory,
        onLogout: logout,
        onSave: toggleSave,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ['Wattpad', 'Discover', 'Library', 'Profile'][selectedIndex],
          style: const TextStyle(
            color: orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (selectedIndex == 0 || selectedIndex == 1)
            IconButton(
              tooltip: 'Search',
              onPressed: showSearchPage,
              icon: const Icon(Icons.search),
            ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const NotificationDialog(),
            ),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HOME
// -----------------------------------------------------------------------------

class HomePage extends StatelessWidget {
  final AppUser user;
  final List<Story> stories;
  final List<Story> recommended;
  final List<Story> recent;
  final void Function(Story) onStoryTap;
  final void Function(Story) onSave;
  final void Function(Story) onLike;

  const HomePage({
    super.key,
    required this.user,
    required this.stories,
    required this.recommended,
    required this.recent,
    required this.onStoryTap,
    required this.onSave,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          'Welcome back, ${user.name} 👋',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Find your next favorite story.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 22),
        if (recent.isNotEmpty) ...[
          const SectionTitle(title: 'Continue Reading'),
          const SizedBox(height: 10),
          SizedBox(
            height: 205,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recent.length > 5 ? 5 : recent.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) => SizedBox(
                width: 185,
                child: StoryMiniCard(
                  story: recent[index],
                  onTap: () => onStoryTap(recent[index]),
                  onSave: () => onSave(recent[index]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        const SectionTitle(title: 'Recommended For You'),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recommended.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) => SizedBox(
              width: 195,
              child: StoryMiniCard(
                story: recommended[index],
                onTap: () => onStoryTap(recommended[index]),
                onSave: () => onSave(recommended[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'Trending Stories'),
        const SizedBox(height: 10),
        ...stories.take(5).map(
              (story) => StoryCard(
                story: story,
                onTap: () => onStoryTap(story),
                onSave: () => onSave(story),
                onLike: () => onLike(story),
              ),
            ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DISCOVER
// -----------------------------------------------------------------------------

class DiscoverPage extends StatefulWidget {
  final List<Story> stories;
  final List<Creator> creators;
  final UserPreferences preferences;
  final void Function(Story) onStoryTap;
  final void Function(Creator) onFollow;
  final void Function(Story) onSave;

  const DiscoverPage({
    super.key,
    required this.stories,
    required this.creators,
    required this.preferences,
    required this.onStoryTap,
    required this.onFollow,
    required this.onSave,
  });

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String? selectedGenre;

  List<Story> get filteredStories {
    if (selectedGenre == null) return widget.stories;
    return widget.stories
        .where((story) => story.genre == selectedGenre)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    const genres = [
      'Romance',
      'Fantasy',
      'Mystery',
      'Science Fiction',
      'Horror',
      'Adventure',
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          selectedGenre == null ? 'Discover' : selectedGenre!,
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 22),
        const SectionTitle(title: 'Explore Genres'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: selectedGenre == null,
              onSelected: (_) => setState(() => selectedGenre = null),
            ),
            ...genres.map(
              (genre) => ChoiceChip(
                label: Text(genre),
                selected: selectedGenre == genre,
                onSelected: (_) => setState(() => selectedGenre = genre),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        ...filteredStories.take(5).map(
              (story) => StoryCard(
                story: story,
                onTap: () => widget.onStoryTap(story),
                onSave: () => widget.onSave(story),
              ),
            ),
      ],
    );
  }
}

class CreatorCard extends StatelessWidget {
  final Creator creator;
  final VoidCallback onFollow;

  const CreatorCard({
    super.key,
    required this.creator,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: orange.withValues(alpha: .12),
            child: Text(creator.avatar),
          ),
          const SizedBox(height: 8),
          Text(
            '@${creator.username}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          FilledButton(
            onPressed: onFollow,
            style: FilledButton.styleFrom(backgroundColor: orange),
            child: Text(creator.followed ? 'Following' : 'Follow'),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// LIBRARY
// -----------------------------------------------------------------------------

class LibraryPage extends StatelessWidget {
  final List<Story> stories;
  final List<Story> recentlyRead;
  final void Function(Story) onStoryTap;
  final void Function(Story) onSave;

  const LibraryPage({
    super.key,
    required this.stories,
    required this.recentlyRead,
    required this.onStoryTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final saved = stories.where((story) => story.saved).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const SectionTitle(title: 'SAVED STORIES'),
        const SizedBox(height: 10),
        ...saved.map(
          (story) => StoryCard(
            story: story,
            onTap: () => onStoryTap(story),
            onSave: () => onSave(story),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// PROFILE
// -----------------------------------------------------------------------------

class ProfilePage extends StatelessWidget {
  final AppUser user;
  final UserPreferences preferences;
  final List<Story> myStories;
  final List<Story> stories;
  final List<Story> recentlyRead;
  final VoidCallback onEditProfile;
  final VoidCallback onPreferences;
  final void Function(Story) onStoryTap;
  final VoidCallback onLogout;
  final void Function(Story) onSave;

  const ProfilePage({
    super.key,
    required this.user,
    required this.preferences,
    required this.myStories,
    required this.stories,
    required this.recentlyRead,
    required this.onEditProfile,
    required this.onPreferences,
    required this.onStoryTap,
    required this.onLogout,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: Text(user.name, style: const TextStyle(fontSize: 24))),
        ListTile(title: const Text('Edit Profile'), onTap: onEditProfile),
        ListTile(title: const Text('Log Out'), onTap: onLogout, textColor: Colors.red),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// EDIT PROFILE
// -----------------------------------------------------------------------------

class EditProfilePage extends StatefulWidget {
  final AppUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameController),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                widget.user.name = nameController.text;
                Navigator.pop(context, widget.user);
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PREFERENCES
// -----------------------------------------------------------------------------

class PreferencesPage extends StatefulWidget {
  final UserPreferences preferences;
  const PreferencesPage({super.key, required this.preferences});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: Center(child: Text('Preferences')),
    );
  }
}

// -----------------------------------------------------------------------------
// STORY DETAILS
// -----------------------------------------------------------------------------

class StoryDetailsPage extends StatelessWidget {
  final Story story;
  final List<Story> allStories;
  final VoidCallback onChanged;
  final VoidCallback onStartReading;

  const StoryDetailsPage({
    super.key,
    required this.story,
    required this.allStories,
    required this.onChanged,
    required this.onStartReading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(story.title)),
      body: Center(child: Text(story.description)),
    );
  }
}

// -----------------------------------------------------------------------------
// READING
// -----------------------------------------------------------------------------

class ReadingPage extends StatefulWidget {
  final Story story;
  final VoidCallback onChanged;

  const ReadingPage({super.key, required this.story, required this.onChanged});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.story.title)),
      body: const Center(child: Text('Reading View')),
    );
  }
}

// -----------------------------------------------------------------------------
// SEARCH
// -----------------------------------------------------------------------------

class StorySearchDelegate extends SearchDelegate<Story?> {
  final List<Story> stories;
  final void Function(Story?) onSelect;

  StorySearchDelegate({required this.stories, required this.onSelect});

  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}

// -----------------------------------------------------------------------------
// CARDS & UTILS
// -----------------------------------------------------------------------------

class StoryCover extends StatelessWidget {
  final Story story;
  const StoryCover({super.key, required this.story});

  @override
  Widget build(BuildContext context) => Container(width: 60, height: 80, color: story.coverColor, child: Center(child: Text(story.emoji)));
}

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final VoidCallback? onSave;
  final VoidCallback? onLike;

  const StoryCard({super.key, required this.story, required this.onTap, this.onSave, this.onLike});

  @override
  Widget build(BuildContext context) => Card(child: ListTile(title: Text(story.title), onTap: onTap));
}

class StoryMiniCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const StoryMiniCard({super.key, required this.story, required this.onTap, required this.onSave});

  @override
  Widget build(BuildContext context) => Card(child: InkWell(onTap: onTap, child: Text(story.title)));
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  const EmptyState({super.key, required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) => Center(child: Text(title));
}

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context) => const AlertDialog(title: Text('Notifications'));
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) => const AlertDialog(title: Text('Settings'));
}