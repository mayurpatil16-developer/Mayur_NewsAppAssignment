import 'package:flutter/material.dart';
import 'package:mayur_news_app/footer.dart';
import 'package:mayur_news_app/providers/news_providers.dart';
import 'package:mayur_news_app/screens/category_screens.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Top Stories',
        'icon': Icons.trending_up,
        'color': const Color(0xFFE57373)
      },
      {
        'name': 'Technology',
        'icon': Icons.computer,
        'color': const Color(0xFF64B5F6)
      },
      {
        'name': 'Sports',
        'icon': Icons.sports_soccer,
        'color': const Color(0xFF81C784)
      },
      {
        'name': 'Entertainment',
        'icon': Icons.movie,
        'color': const Color(0xFFFFB74D)
      },
      {
        'name': 'Business',
        'icon': Icons.business,
        'color': const Color(0xFF9575CD)
      },
      {
        'name': 'Health',
        'icon': Icons.health_and_safety,
        'color': const Color(0xFF4DB6AC)
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(
                'News App',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return CategoryCard(
                      name: categories[index]['name'] as String,
                      icon: categories[index]['icon'] as IconData,
                      color: categories[index]['color'] as Color,
                      index: index,
                    );
                  },
                  childCount: categories.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final int index;

  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Provider.of<NewsProvider>(context, listen: false)
              .setCategory(name.toLowerCase());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryScreen(category: name),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn().scale();
  }
}
