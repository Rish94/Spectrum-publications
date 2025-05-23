import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spectrum_app/screens/home_page.dart';
import 'package:spectrum_app/screens/series_page.dart';
import 'package:spectrum_app/screens/classes_page.dart';
import 'package:spectrum_app/screens/books_page.dart';
import 'package:spectrum_app/screens/about_page.dart';
import 'package:spectrum_app/screens/contact_page.dart';
import 'package:spectrum_app/components/books/pdf_viewer.dart';
import 'dart:io';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'series',
          builder: (context, state) => const SeriesPage(),
          routes: [
            GoRoute(
              path: ':seriesId/classes',
              builder: (context, state) => ClassesPage(
                seriesId: state.pathParameters['seriesId']!,
                seriesName: state.uri.queryParameters['name'] ?? 'Series',
              ),
              routes: [
                GoRoute(
                  path: ':classId/books',
                  builder: (context, state) => BooksPage(
                    seriesId: state.pathParameters['seriesId']!,
                    seriesName:
                        state.uri.queryParameters['seriesName'] ?? 'Series',
                    classId: state.pathParameters['classId']!,
                    className:
                        state.uri.queryParameters['className'] ?? 'Class',
                  ),
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
        GoRoute(
          path: 'pdf-viewer',
          builder: (context, state) {
            final pdfFile = state.extra as File;
            return AnimatedPdfViewer(pdfFile: pdfFile);
          },
        ),
      ],
    ),
  ],
);
