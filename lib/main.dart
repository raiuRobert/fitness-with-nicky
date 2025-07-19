import 'package:flutter/material.dart';

void main() {
  runApp(const FitnessWithNickyApp());
}

class FitnessWithNickyApp extends StatelessWidget {
  const FitnessWithNickyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness with Nicky',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Title
              const Text(
                'Fitness with Nicky',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 182, 16, 16),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              
              // Subtitle
              const Text(
                'Your Feline Fitness Coach',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 60),
              
              // Black Cat Avatar (using emoji for now)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color.fromARGB(255, 36, 74, 155), width: 3),
                ),
                child: const Center(
                  child: Text(
                    '🐈‍⬛',
                    style: TextStyle(fontSize: 100),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Start Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainMenuPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 8,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fitness_center, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Start Training',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              
              // Footer text
              const Text(
                'Tap to begin your fitness journey!',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  String? selectedWorkout;
  
  final List<WorkoutCategory> workoutCategories = [
    WorkoutCategory(
      name: 'Cardio',
      icon: Icons.directions_run,
      workouts: ['Running', 'Cycling', 'Jump Rope', 'HIIT'],
    ),
    WorkoutCategory(
      name: 'Strength',
      icon: Icons.fitness_center,
      workouts: ['Push-ups', 'Pull-ups', 'Squats', 'Deadlifts'],
    ),
    WorkoutCategory(
      name: 'Flexibility',
      icon: Icons.self_improvement,
      workouts: ['Yoga', 'Stretching', 'Pilates', 'Meditation'],
    ),
    WorkoutCategory(
      name: 'Core',
      icon: Icons.center_focus_strong,
      workouts: ['Planks', 'Crunches', 'Russian Twists', 'Mountain Climbers'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Text('🐱'),
            SizedBox(width: 10),
            Text('Nicky\'s Gym'),
          ],
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nicky is ready to help you get fit! 💪',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              
              // Workout Categories
              const Text(
                'Choose Your Workout:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: workoutCategories.length,
                  itemBuilder: (context, index) {
                    final category = workoutCategories[index];
                    return WorkoutCategoryCard(
                      category: category,
                      onTap: () => _showWorkoutOptions(context, category),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkoutOptions(BuildContext context, WorkoutCategory category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D44),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(category.icon, color: Colors.purple.shade300, size: 30),
                const SizedBox(width: 10),
                Text(
                  '${category.name} Workouts',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...category.workouts.map(
              (workout) => ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.purple),
                title: Text(
                  workout,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _startWorkout(workout);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startWorkout(String workout) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting $workout workout! 🐱💪'),
        backgroundColor: Colors.purple.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class WorkoutCategory {
  final String name;
  final IconData icon;
  final List<String> workouts;

  WorkoutCategory({
    required this.name,
    required this.icon,
    required this.workouts,
  });
}

class WorkoutCategoryCard extends StatelessWidget {
  final WorkoutCategory category;
  final VoidCallback onTap;

  const WorkoutCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade600,
              Colors.purple.shade800,
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.shade900.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${category.workouts.length} exercises',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
