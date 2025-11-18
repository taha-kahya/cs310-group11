import 'package:flutter/material.dart';
import 'package:locai/utils/colors.dart';
import 'package:locai/utils/text_styles.dart';

class ReportBugPage extends StatefulWidget {
  const ReportBugPage({super.key});

  @override
  State<ReportBugPage> createState() => _ReportBugPageState();
}

class _ReportBugPageState extends State<ReportBugPage> {
  final TextEditingController _bugCtrl = TextEditingController();
  String _priority = "High";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Report Bug",
          style: AppTextStyles.subheading.copyWith(
            color: AppColors.primary,
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
                fontSize: 50,
                color: AppColors.primary,
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
                controller: _bugCtrl,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter the bug description here.",
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Select priority level",
              style: AppTextStyles.body.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _priority,
                  isExpanded: true,
                  style: AppTextStyles.subheading.copyWith(
                    color: AppColors.primary,
                  ),
                  items: [
                    "Low",
                    "Medium",
                    "High",
                  ].map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                ),
              ),
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
                    borderRadius: BorderRadius.circular(14),
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
