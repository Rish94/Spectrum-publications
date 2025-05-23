import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/components/text_style.dart';
import 'package:spectrum_app/components/footer_card.dart';
import 'package:spectrum_app/screens/series_page.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:spectrum_app/config/theme_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> temp = [
    "assets/books.jpg",
    "assets/books2.jpg",
    "assets/books3.jpg",
    "assets/books4.jpg"
  ];
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white.withOpacity(0.95),
        endDrawer: AppDrawer(currentRoute: '/'),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: ThemeHelper.getGradient(
                              ThemeHelper.primaryGradient),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 30),
                          CarouselSlider(
                            items: temp
                                .map((item) => Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(item,
                                            fit: BoxFit.cover,
                                            width: double.infinity),
                                      ),
                                    ))
                                .toList(),
                            options: CarouselOptions(
                              height: 300,
                              autoPlay: true,
                              aspectRatio: 8 / 3,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push('/series'),
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(16),
                            decoration: ThemeHelper.getCardDecoration(
                              gradientColors: ThemeHelper.secondaryGradient,
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/books_icon.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    "E-Books",
                                    style: Text_Style.large().copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Digital Books",
                                    style: Text_Style.small(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Tap to View",
                                    style: Text_Style.small(
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          // onTap: () => context.push('/classes'),
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(16),
                            decoration: ThemeHelper.getCardDecoration(
                              gradientColors: ThemeHelper.accentGradient,
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/books_icon.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    "Classes",
                                    style: Text_Style.large().copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Digital View",
                                    style: Text_Style.small(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Tap to View",
                                    style: Text_Style.small(
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const FooterCard(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                decoration: BoxDecoration(
                  gradient:
                      ThemeHelper.getGradient(ThemeHelper.primaryGradient),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "Good Evening, Students",
                      style: Text_Style.large().copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                      child: const Icon(
                        Icons.verified_user,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
