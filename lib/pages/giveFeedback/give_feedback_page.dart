import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:locai/providers/auth_provider.dart' as app_auth;
import 'package:locai/utils/text_styles.dart';
import 'package:locai/models/user_feedback.dart';
import 'package:locai/repositories/feedback_repository.dart';

class GiveFeedbackPage extends StatefulWidget {
  const GiveFeedbackPage({super.key});

  @override
  State<GiveFeedbackPage> createState() => _GiveFeedbackPageState();
}

class _GiveFeedbackPageState extends State<GiveFeedbackPage> {
  final TextEditingController _feedbackCtrl = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  Future<bool> _submitFeedback() async {
    if (_feedbackCtrl.text.trim().isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter feedback and rating')),
      );
      return false;
    }

    setState(() => _isSubmitting = true);

    try {
      final auth = context.read<app_auth.AuthProvider>();
      final user = auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be signed in to submit feedback')),
        );
        return false;
      }

      final feedback = UserFeedback(
        id: '',
        message: _feedbackCtrl.text.trim(),
        rating: _rating,
        createdBy: user.uid,
        createdAt: DateTime.now(),
      );

      await FeedbackRepository().submitFeedback(feedback);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );

      return true;
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit feedback')),
      );
      return false;
    } finally {
      setState(() => _isSubmitting = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Give Feedback",
          style: AppTextStyles.subheading.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Text(
              "Tell us what you think about our app",
              style: AppTextStyles.heading.copyWith(
                fontSize: 36,
                color: onSurface,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _feedbackCtrl,
                maxLines: null,
                style: AppTextStyles.body.copyWith(
                  color: onSurface,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your feedback here.",
                  hintStyle: AppTextStyles.body.copyWith(
                    color: onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              "Rate our app",
              style: AppTextStyles.subheading.copyWith(
                color: onSurface.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = i;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                            () {
                          if (_rating >= i) {
                            return Icons.star;
                          } else {
                            return Icons.star_border;
                          }
                        }(),
                        size: 32,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                  final success = await _submitFeedback();
                  if (success) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary)
                    : Text(
                  "Submit",
                  style: AppTextStyles.subheading.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
