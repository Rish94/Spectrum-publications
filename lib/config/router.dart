import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spectrum_app/screens/home_page.dart';
import 'package:spectrum_app/screens/series_page.dart';
import 'package:spectrum_app/screens/series_options_page.dart';
import 'package:spectrum_app/screens/subjects_page.dart';
import 'package:spectrum_app/screens/classes_page.dart';
import 'package:spectrum_app/screens/books_page.dart';
import 'package:spectrum_app/screens/about_page.dart';
import 'package:spectrum_app/screens/contact_page.dart';
import 'package:spectrum_app/components/books/pdf_viewer.dart';
import 'package:spectrum_app/components/books/video_player.dart';
import 'package:spectrum_app/screens/splash_screen.dart';
import 'dart:io';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'series',
          builder: (context, state) {
            final language = state.uri.queryParameters['language'];
            return SeriesPage(initialLanguage: language);
          },
          routes: [
            GoRoute(
              path: ':seriesId/options',
              builder: (context, state) {
                final isHindi = state.uri.queryParameters['isHindi'] == 'true';
                return SeriesOptionsPage(
                  seriesId: state.pathParameters['seriesId']!,
                  seriesName: state.uri.queryParameters['name'] ?? 'Series',
                  isHindi: isHindi,
                );
              },
            ),
            GoRoute(
              path: ':seriesId/classes',
              builder: (context, state) {
                final isHindi = state.uri.queryParameters['isHindi'] == 'true';
                final contentType =
                    state.uri.queryParameters['contentType'] ?? 'ebooks';
                return ClassesPage(
                  seriesId: state.pathParameters['seriesId']!,
                  seriesName: state.uri.queryParameters['name'] ?? 'Series',
                  contentType: contentType,
                  isHindi: isHindi,
                  typeId: state.uri.queryParameters['typeId'] ?? '1',
                );
              },
              routes: [
                GoRoute(
                  path: ':classId/subjects',
                  builder: (context, state) {
                    final isHindi =
                        state.uri.queryParameters['isHindi'] == 'true';
                    final contentType =
                        state.uri.queryParameters['contentType'] ?? 'ebooks';
                    return SubjectsPage(
                      seriesId: state.pathParameters['seriesId']!,
                      seriesName: state.uri.queryParameters['name'] ?? 'Series',
                      classId: state.pathParameters['classId']!,
                      className:
                          state.uri.queryParameters['className'] ?? 'Class',
                      contentType: contentType,
                      isHindi: isHindi,
                      typeId: state.uri.queryParameters['typeId'] ?? '1',
                    );
                  },
                  routes: [
                    GoRoute(
                      path: ':subjectId/books',
                      builder: (context, state) => BooksPage(
                        seriesId: state.pathParameters['seriesId']!,
                        seriesName:
                            state.uri.queryParameters['name'] ?? 'Series',
                        classId: state.pathParameters['classId']!,
                        className:
                            state.uri.queryParameters['className'] ?? 'Class',
                        subjectId: state.pathParameters['subjectId']!,
                        subjectName: state.uri.queryParameters['subjectName'] ??
                            'Subject',
                        contentType: state.uri.queryParameters['contentType'] ??
                            'ebooks',
                        typeId: state.uri.queryParameters['typeId'] ?? '1',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'about',
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          path: 'contact',
          builder: (context, state) => const ContactPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/pdf-viewer',
      builder: (context, state) {
        final pdfUrl = state.extra as String;
        return PdfViewer(pdfUrl: pdfUrl);
      },
    ),
    GoRoute(
      path: '/video-player',
      builder: (context, state) {
        final videoUrl = state.extra as String;
        return VideoPlayerPage(videoUrl: videoUrl);
      },
    ),
  ],
);
