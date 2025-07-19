import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      home: const InteractiveCatWrapper(child: LandingPage()),
    );
  }
}

class InteractiveCatWrapper extends StatefulWidget {
  final Widget child;
  
  const InteractiveCatWrapper({super.key, required this.child});

  @override
  State<InteractiveCatWrapper> createState() => _InteractiveCatWrapperState();
}

class _InteractiveCatWrapperState extends State<InteractiveCatWrapper>
    with TickerProviderStateMixin {
  Offset? lastClickPosition;
  late AnimationController _eyeController;
  late Animation<double> _leftEyeX;
  late Animation<double> _leftEyeY;
  late Animation<double> _rightEyeX;
  late Animation<double> _rightEyeY;

  @override
  void initState() {
    super.initState();
    _eyeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _leftEyeX = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _eyeController, curve: Curves.easeOut),
    );
    _leftEyeY = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _eyeController, curve: Curves.easeOut),
    );
    _rightEyeX = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _eyeController, curve: Curves.easeOut),
    );
    _rightEyeY = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _eyeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _eyeController.dispose();
    super.dispose();
  }

  void _updateEyePosition(Offset clickPosition, Size screenSize) {
    const double catX = 50; // Cat's head X position from right edge
    const double catY = 120; // Cat's head Y position from bottom
    
    // Calculate cat's actual position on screen
    final double catScreenX = screenSize.width - catX;
    final double catScreenY = screenSize.height - catY;
    
    // Calculate direction from cat to click
    final double deltaX = clickPosition.dx - catScreenX;
    final double deltaY = clickPosition.dy - catScreenY;
    
    // Calculate angle and limit eye movement
    final double distance = math.sqrt(deltaX * deltaX + deltaY * deltaY);
    const double maxEyeMovement = 3.0; // Maximum pixels the pupils can move
    
    double eyeX = 0;
    double eyeY = 0;
    
    if (distance > 0) {
      eyeX = (deltaX / distance) * maxEyeMovement;
      eyeY = (deltaY / distance) * maxEyeMovement;
      
      // Clamp the values
      eyeX = eyeX.clamp(-maxEyeMovement, maxEyeMovement);
      eyeY = eyeY.clamp(-maxEyeMovement, maxEyeMovement);
    }
    
    // Update animation targets
    _leftEyeX = Tween<double>(
      begin: _leftEyeX.value,
      end: eyeX,
    ).animate(CurvedAnimation(parent: _eyeController, curve: Curves.easeOut));
    
    _leftEyeY = Tween<double>(
      begin: _leftEyeY.value,
      end: eyeY,
    ).animate(CurvedAnimation(parent: _eyeController, curve: Curves.easeOut));
    
    _rightEyeX = Tween<double>(
      begin: _rightEyeX.value,
      end: eyeX,
    ).animate(CurvedAnimation(parent: _eyeController, curve: Curves.easeOut));
    
    _rightEyeY = Tween<double>(
      begin: _rightEyeY.value,
      end: eyeY,
    ).animate(CurvedAnimation(parent: _eyeController, curve: Curves.easeOut));
    
    _eyeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          setState(() {
            lastClickPosition = details.globalPosition;
          });
          _updateEyePosition(details.globalPosition, MediaQuery.of(context).size);
        },
        child: Stack(
          children: [
            // Main content
            widget.child,
            
            // Interactive cat in bottom-right corner
            Positioned(
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: _eyeController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(100, 150),
                    painter: InteractiveCatPainter(
                      leftEyeOffset: Offset(_leftEyeX.value, _leftEyeY.value),
                      rightEyeOffset: Offset(_rightEyeX.value, _rightEyeY.value),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InteractiveCatPainter extends CustomPainter {
  final Offset leftEyeOffset;
  final Offset rightEyeOffset;
  
  InteractiveCatPainter({
    required this.leftEyeOffset,
    required this.rightEyeOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint catPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final Paint eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final Paint pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final Paint nosePaint = Paint()
      ..color = Colors.pink.shade300
      ..style = PaintingStyle.fill;

    // Cat head (partial, peeking from corner)
    final Path catHead = Path();
    catHead.moveTo(size.width * 0.3, size.height); // Start from bottom
    catHead.lineTo(size.width * 0.2, size.height * 0.7); // Left side
    catHead.quadraticBezierTo(
      size.width * 0.1, size.height * 0.5,
      size.width * 0.3, size.height * 0.4,
    ); // Left ear curve
    catHead.lineTo(size.width * 0.4, size.height * 0.2); // Left ear tip
    catHead.lineTo(size.width * 0.5, size.height * 0.4); // Between ears
    catHead.lineTo(size.width * 0.6, size.height * 0.2); // Right ear tip
    catHead.lineTo(size.width * 0.8, size.height * 0.4); // Right ear
    catHead.quadraticBezierTo(
      size.width * 0.9, size.height * 0.5,
      size.width * 0.85, size.height * 0.7,
    ); // Right side curve
    catHead.lineTo(size.width, size.height); // To bottom-right corner
    catHead.close();
    
    canvas.drawPath(catHead, catPaint);
    
    // Eyes (white part)
    final double leftEyeCenterX = size.width * 0.4;
    final double leftEyeCenterY = size.height * 0.55;
    final double rightEyeCenterX = size.width * 0.6;
    final double rightEyeCenterY = size.height * 0.55;
    final double eyeRadius = size.width * 0.05;
    
    canvas.drawCircle(
      Offset(leftEyeCenterX, leftEyeCenterY),
      eyeRadius,
      eyeWhitePaint,
    );
    canvas.drawCircle(
      Offset(rightEyeCenterX, rightEyeCenterY),
      eyeRadius,
      eyeWhitePaint,
    );
    
    // Pupils (following the click)
    final double pupilRadius = eyeRadius * 0.6;
    canvas.drawCircle(
      Offset(leftEyeCenterX + leftEyeOffset.dx, leftEyeCenterY + leftEyeOffset.dy),
      pupilRadius,
      pupilPaint,
    );
    canvas.drawCircle(
      Offset(rightEyeCenterX + rightEyeOffset.dx, rightEyeCenterY + rightEyeOffset.dy),
      pupilRadius,
      pupilPaint,
    );
    
    // Nose
    final Path nose = Path();
    final double noseCenterX = size.width * 0.5;
    final double noseCenterY = size.height * 0.7;
    nose.moveTo(noseCenterX, noseCenterY - 3);
    nose.lineTo(noseCenterX - 4, noseCenterY + 2);
    nose.lineTo(noseCenterX + 4, noseCenterY + 2);
    nose.close();
    canvas.drawPath(nose, nosePaint);
    
    // Whiskers
    final Paint whiskerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    // Left whiskers
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.65),
      Offset(size.width * 0.35, size.height * 0.68),
      whiskerPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.75),
      Offset(size.width * 0.38, size.height * 0.75),
      whiskerPaint,
    );
    
    // Right whiskers
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.68),
      Offset(size.width * 0.9, size.height * 0.65),
      whiskerPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.62, size.height * 0.75),
      Offset(size.width * 0.85, size.height * 0.75),
      whiskerPaint,
    );
  }

  @override
  bool shouldRepaint(InteractiveCatPainter oldDelegate) {
    return leftEyeOffset != oldDelegate.leftEyeOffset ||
           rightEyeOffset != oldDelegate.rightEyeOffset;
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
                      builder: (context) => const InteractiveCatWrapper(child: MainMenuPage()),
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
