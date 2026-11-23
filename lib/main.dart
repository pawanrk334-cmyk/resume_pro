import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const ResumeProApp());
}

// ==========================================
// THEME & CONFIGURATION
// ==========================================
class ResumeProApp extends StatelessWidget {
  const ResumeProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResumePro - ATS Resume Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E293B), // Slate 800
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFF2563EB),
          surface: Colors.white,
          surfaceContainerLowest: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
          ),
          labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
      ),
      home: const ResumeEditorScreen(),
    );
  }
}

// ==========================================
// DATA MODELS
// ==========================================
enum ResumeTemplateType { classicSerif, modernSans, cleanMinimal }

class ExperienceItem {
  String id;
  String company;
  String role;
  String location;
  String startDate;
  String endDate;
  bool isCurrent;
  List<String> bullets;

  ExperienceItem({
    required this.id,
    this.company = '',
    this.role = '',
    this.location = '',
    this.startDate = '',
    this.endDate = '',
    this.isCurrent = false,
    List<String>? bullets,
  }) : bullets = bullets ?? [''];
}

class EducationItem {
  String id;
  String institution;
  String degree;
  String location;
  String graduationYear;
  String gpaOrHonors;

  EducationItem({
    required this.id,
    this.institution = '',
    this.degree = '',
    this.location = '',
    this.graduationYear = '',
    this.gpaOrHonors = '',
  });
}

class ProjectItem {
  String id;
  String name;
  String techStack;
  String link;
  String description;

  ProjectItem({
    required this.id,
    this.name = '',
    this.techStack = '',
    this.link = '',
    this.description = '',
  });
}

class ResumeData {
  String fullName;
  String professionalTitle;
  String email;
  String phone;
  String location;
  String linkedin;
  String githubOrPortfolio;
  String summary;

  List<ExperienceItem> experiences;
  List<EducationItem> educations;
  List<ProjectItem> projects;
  List<String> skills;
  List<String> certifications;

  ResumeData({
    this.fullName = '',
    this.professionalTitle = '',
    this.email = '',
    this.phone = '',
    this.location = '',
    this.linkedin = '',
    this.githubOrPortfolio = '',
    this.summary = '',
    List<ExperienceItem>? experiences,
    List<EducationItem>? educations,
    List<ProjectItem>? projects,
    List<String>? skills,
    List<String>? certifications,
  })  : experiences = experiences ?? [],
        educations = educations ?? [],
        projects = projects ?? [],
        skills = skills ?? [],
        certifications = certifications ?? [];

  static ResumeData getSampleData() {
    return ResumeData(
      fullName: 'Alexander Wright',
      professionalTitle: 'Lead Software Engineer | Cloud Architecture',
      email: 'alex.wright@email.com',
      phone: '+1 (555) 234-5678',
      location: 'Austin, TX',
      linkedin: 'linkedin.com/in/alexanderwright',
      githubOrPortfolio: 'github.com/awright-dev',
      summary:
          'Performance-driven Senior Software Engineer with 7+ years of experience in designing scalable microservices, cloud migrations, and distributed systems. Boosted infrastructure uptime to 99.99% and spearheaded multi-region AWS deployments that cut cloud operational expenses by 28%.',
      experiences: [
        ExperienceItem(
          id: '1',
          company: 'Apex Cloud Solutions',
          role: 'Lead Cloud Software Engineer',
          location: 'Austin, TX',
          startDate: '04/2022',
          endDate: 'Present',
          isCurrent: true,
          bullets: [
            'Architected resilient microservices ecosystem processing 45M+ daily requests using Go, Docker, and Kubernetes.',
            'Refactored legacy database queries and caching layers, decreasing P99 latency from 450ms to 75ms.',
            'Mentored 8 junior and mid-level developers through structured code reviews and CI/CD best practice workshops.',
          ],
        ),
        ExperienceItem(
          id: '2',
          company: 'Nova Digital Labs',
          role: 'Full Stack Software Engineer',
          location: 'Dallas, TX',
          startDate: '08/2019',
          endDate: '03/2022',
          isCurrent: false,
          bullets: [
            'Engineered automated payment pipeline integrating Stripe and Plaid APIs, supporting \$12M+ in monthly throughput.',
            'Automated staging deployment workflows using GitHub Actions, cutting release overhead by 40%.',
            'Implemented automated unit and end-to-end testing coverage from 38% to 91% across critical payment modules.',
          ],
        ),
      ],
      educations: [
        EducationItem(
          id: '1',
          institution: 'University of Texas at Austin',
          degree: 'Bachelor of Science in Computer Science',
          location: 'Austin, TX',
          graduationYear: '2019',
          gpaOrHonors: 'GPA: 3.85 / 4.0 | Magna Cum Laude',
        ),
      ],
      projects: [
        ProjectItem(
          id: '1',
          name: 'Distributed Task Queue (Open Source)',
          techStack: 'Go, Redis, gRPC, Prometheus',
          link: 'github.com/awright-dev/distrib-queue',
          description:
              'High-throughput asynchronous job processing engine with automated backoff strategies and real-time telemetry metrics.',
        ),
      ],
      skills: [
        'Go / Golang',
        'Python',
        'TypeScript',
        'Docker',
        'Kubernetes',
        'AWS (ECS, S3, RDS)',
        'PostgreSQL',
        'Redis',
        'CI/CD Pipelines',
        'REST & gRPC APIs',
        'System Architecture',
      ],
      certifications: [
        'AWS Certified Solutions Architect – Associate (2023)',
        'Certified Kubernetes Administrator - CKA (2024)',
      ],
    );
  }
}

// ==========================================
// MAIN EDITOR SCREEN
// ==========================================
class ResumeEditorScreen extends StatefulWidget {
  const ResumeEditorScreen({super.key});

  @override
  State<ResumeEditorScreen> createState() => _ResumeEditorScreenState();
}

class _ResumeEditorScreenState extends State<ResumeEditorScreen> with SingleTickerProviderStateMixin {
  late ResumeData _resumeData;
  ResumeTemplateType _currentTemplate = ResumeTemplateType.classicSerif;
  late TabController _tabController;
  final TextEditingController _skillInputController = TextEditingController();
  final TextEditingController _certInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resumeData = ResumeData.getSampleData();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _skillInputController.dispose();
    _certInputController.dispose();
    super.dispose();
  }

  void _loadSampleData() {
    setState(() {
      _resumeData = ResumeData.getSampleData();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sample ATS-friendly resume loaded')),
    );
  }

  void _clearData() {
    setState(() {
      _resumeData = ResumeData();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Editor cleared')),
    );
  }

  // ATS Score Evaluation logic
  Map<String, dynamic> _calculateAtsScore() {
    int score = 0;
    final List<Map<String, dynamic>> criteria = [];

    // 1. Contact Information Check
    bool hasContact = _resumeData.fullName.isNotEmpty &&
        _resumeData.email.contains('@') &&
        _resumeData.phone.isNotEmpty &&
        _resumeData.location.isNotEmpty;
    if (hasContact) score += 20;
    criteria.add({
      'title': 'Essential Contact Info',
      'subtitle': 'Full Name, valid Email, Phone, and City/State',
      'passed': hasContact,
      'pts': 20,
    });

    // 2. Summary depth check
    int wordCount = _resumeData.summary.trim().split(RegExp(r'\s+')).length;
    bool hasValidSummary = _resumeData.summary.isNotEmpty && wordCount >= 20;
    if (hasValidSummary) score += 15;
    criteria.add({
      'title': 'Professional Summary',
      'subtitle': 'Targeted summary with at least 20 words (current: ${wordCount > 1 ? wordCount : 0})',
      'passed': hasValidSummary,
      'pts': 15,
    });

    // 3. Work Experience with Measurable Impact
    bool hasExp = _resumeData.experiences.isNotEmpty;
    bool hasMetrics = _resumeData.experiences.any(
      (e) => e.bullets.any((b) => RegExp(r'(\d+%|\$\d+|\d+M|\d+k|\d+\+)', caseSensitive: false).hasMatch(b)),
    );
    if (hasExp && hasMetrics) {
      score += 25;
    } else if (hasExp) {
      score += 15;
    }
    criteria.add({
      'title': 'Quantified Work Achievements',
      'subtitle': 'Includes metrics, numbers, percentages, or scale indicators',
      'passed': hasExp && hasMetrics,
      'pts': 25,
    });

    // 4. Keyword Skills Presence
    bool hasSkills = _resumeData.skills.length >= 6;
    if (hasSkills) {
      score += 20;
    } else if (_resumeData.skills.isNotEmpty) {
      score += 10;
    }
    criteria.add({
      'title': 'Targeted Skills Keywords',
      'subtitle': 'At least 6 clear skill keywords (current: ${_resumeData.skills.length})',
      'passed': hasSkills,
      'pts': 20,
    });

    // 5. Education Entry
    bool hasEdu = _resumeData.educations.isNotEmpty && _resumeData.educations.first.degree.isNotEmpty;
    if (hasEdu) score += 10;
    criteria.add({
      'title': 'Education Section',
      'subtitle': 'Standard degree and university entries',
      'passed': hasEdu,
      'pts': 10,
    });

    // 6. ATS Parser Structure
    score += 10;
    criteria.add({
      'title': 'ATS Machine Parsable Layout',
      'subtitle': 'Single-column structure, standard typography, no parser-breaking tables or icons',
      'passed': true,
      'pts': 10,
    });

    return {'score': score, 'criteria': criteria};
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'ATS',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'ResumePro',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
        actions: [
          DropdownButton<ResumeTemplateType>(
            value: _currentTemplate,
            underline: const SizedBox(),
            icon: const Icon(Icons.palette_outlined, size: 20),
            items: const [
              DropdownMenuItem(
                value: ResumeTemplateType.classicSerif,
                child: Text('ATS Classic (Times)'),
              ),
              DropdownMenuItem(
                value: ResumeTemplateType.modernSans,
                child: Text('ATS Modern (Helvetica)'),
              ),
              DropdownMenuItem(
                value: ResumeTemplateType.cleanMinimal,
                child: Text('ATS Minimalist'),
              ),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _currentTemplate = val);
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Load Sample Data',
            icon: const Icon(Icons.auto_fix_high),
            onPressed: _loadSampleData,
          ),
          IconButton(
            tooltip: 'Clear Editor',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: _clearData,
          ),
          IconButton(
            tooltip: 'ATS Audit Report',
            icon: const Icon(Icons.verified_outlined),
            onPressed: () => _showAtsDialog(context),
          ),
          const SizedBox(width: 12),
        ],
        bottom: isDesktop
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: const Color(0xFF2563EB),
                unselectedLabelColor: const Color(0xFF64748B),
                indicatorColor: const Color(0xFF2563EB),
                tabs: const [
                  Tab(text: 'Personal'),
                  Tab(text: 'Experience'),
                  Tab(text: 'Education'),
                  Tab(text: 'Skills & Extras'),
                  Tab(text: 'Preview PDF'),
                ],
              ),
      ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  // Desktop Side-by-side layout (Form on left, Live PDF preview on right)
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF2563EB),
                  unselectedLabelColor: const Color(0xFF64748B),
                  indicatorColor: const Color(0xFF2563EB),
                  tabs: const [
                    Tab(text: 'Personal'),
                    Tab(text: 'Experience'),
                    Tab(text: 'Education'),
                    Tab(text: 'Skills & Extras'),
                    Tab(text: 'ATS Audit'),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPersonalTab(),
                    _buildExperienceTab(),
                    _buildEducationTab(),
                    _buildSkillsAndExtrasTab(),
                    _buildAtsAuditView(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFCBD5E1)),
        Expanded(
          flex: 6,
          child: Container(
            color: const Color(0xFF475569),
            child: _buildPdfViewer(),
          ),
        ),
      ],
    );
  }

  // Mobile single column layout
  Widget _buildMobileLayout() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildPersonalTab(),
        _buildExperienceTab(),
        _buildEducationTab(),
        _buildSkillsAndExtrasTab(),
        Container(
          color: const Color(0xFF475569),
          child: _buildPdfViewer(),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 1: PERSONAL INFORMATION
  // ==========================================
  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Contact Information', 'Standard ATS contact lines'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _resumeData.fullName,
                    decoration: const InputDecoration(labelText: 'Full Name *'),
                    onChanged: (val) => setState(() => _resumeData.fullName = val),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _resumeData.professionalTitle,
                    decoration: const InputDecoration(
                      labelText: 'Professional Title / Target Role *',
                      hintText: 'e.g. Senior Software Engineer',
                    ),
                    onChanged: (val) => setState(() => _resumeData.professionalTitle = val),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _resumeData.email,
                          decoration: const InputDecoration(labelText: 'Email Address *'),
                          onChanged: (val) => setState(() => _resumeData.email = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: _resumeData.phone,
                          decoration: const InputDecoration(labelText: 'Phone Number *'),
                          onChanged: (val) => setState(() => _resumeData.phone = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _resumeData.location,
                          decoration: const InputDecoration(
                            labelText: 'Location *',
                            hintText: 'City, State (or Remote)',
                          ),
                          onChanged: (val) => setState(() => _resumeData.location = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: _resumeData.linkedin,
                          decoration: const InputDecoration(
                            labelText: 'LinkedIn URL / Handle',
                            hintText: 'linkedin.com/in/username',
                          ),
                          onChanged: (val) => setState(() => _resumeData.linkedin = val),
                        ),
                      ),
