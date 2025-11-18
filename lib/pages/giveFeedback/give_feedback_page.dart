import 'package:flutter/material.dart';
import 'package:locai/utils/colors.dart';
import 'package:locai/utils/text_styles.dart';

class GiveFeedbackPage extends StatefulWidget {
  const GiveFeedbackPage({super.key});

  @override
  State<GiveFeedbackPage> createState() => _GiveFeedbackPageState();
}

class _GiveFeedbackPageState extends State<GiveFeedbackPage> {
  final TextEditingController _feedbackCtrl = TextEditingController();
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Give Feedback",
          style: AppTextStyles.subheading.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            Text(
              "Tell us what you think about our app",
              style: AppTextStyles.heading.copyWith(
                color: AppColors.primary,
                fontSize: 50,
              ),
            ),

            const SizedBox(height: 50),

            Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _feedbackCtrl,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your feedback here.",
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Rate our app",
              style: AppTextStyles.subheading.copyWith(
                color: AppColors.secondary,
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
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 40),

            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: AppTextStyles.subheading.copyWith(
                    color: AppColors.surface,
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
