import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:locai/utils/colors.dart';
import 'package:locai/utils/text_styles.dart';
import 'package:locai/models/bug_report.dart';
import 'package:locai/repositories/bug_reports_repository.dart';

class ReportBugPage extends StatefulWidget {
  const ReportBugPage({super.key});

  @override
  State<ReportBugPage> createState() => _ReportBugPageState();
}

class _ReportBugPageState extends State<ReportBugPage> {
  final TextEditingController _bugCtrl = TextEditingController();
  String _priority = "High";
  bool _isSubmitting = false;

  Future<void> _submitBug() async {
    if (_bugCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a bug description')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final bug = BugReport(
        id: '',
        description: _bugCtrl.text.trim(),
        priority: _priority,
        createdBy: uid,
        createdAt: DateTime.now(),
      );

      await BugReportsRepository().submitBugReport(bug);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bug report submitted successfully')),
      );

      Navigator.pop(context);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit bug report')),
      );
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
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Report Bug",
          style: AppTextStyles.subheading.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            Text(
              "Have you detected a bug? Let us know.",
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
                controller: _bugCtrl,
                maxLines: null,
                style: AppTextStyles.body.copyWith(
                  color: onSurface,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter the bug description here.",
                  hintStyle: AppTextStyles.body.copyWith(
                    color: onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              "Select priority level",
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: onSurface.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _priority,
                  isExpanded: true,
                  style: AppTextStyles.subheading.copyWith(
                    color: onSurface,
                  ),
                  items: const [
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "High", child: Text("High")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBug,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                )
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
