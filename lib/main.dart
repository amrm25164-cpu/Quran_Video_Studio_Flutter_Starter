import 'package:flutter/material.dart';

void main() {
  runApp(const QuranVideoStudioApp());
}

class QuranVideoStudioApp extends StatelessWidget {
  const QuranVideoStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Video Studio',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1018),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD8B15A),
          brightness: Brightness.dark,
          surface: const Color(0xFF151D28),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B1018),
          foregroundColor: Color(0xFFF5F1E7),
          centerTitle: false,
        ),
      ),
      home: const StudioHomePage(),
    );
  }
}

class StudioHomePage extends StatefulWidget {
  const StudioHomePage({super.key});

  @override
  State<StudioHomePage> createState() => _StudioHomePageState();
}

class _StudioHomePageState extends State<StudioHomePage> {
  final _verseController = TextEditingController(
    text: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
  );
  final _surahController = TextEditingController(text: 'سورة الشرح • الآية ٦');
  double _textOpacity = 1;
  double _backgroundDim = 0.35;
  double _fontSize = 30;
  Color _textColor = const Color(0xFFF5E6B8);
  String _reader = 'عبدالرحمن السديس';
  String _aspect = '9:16';
  String _backgroundName = 'خلفية افتراضية';
  bool _showSurahLabel = true;
  bool _showTafsir = false;
  bool _audioSelected = false;

  @override
  void dispose() {
    _verseController.dispose();
    _surahController.dispose();
    super.dispose();
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quran Video Studio', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('استوديو صناعة فيديوهات القرآن', style: TextStyle(fontSize: 12, color: Color(0xFFB8C0CC))),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'معلومات',
            onPressed: () => _message('هذه نسخة بداية. سنضيف اختيار الملفات والتصدير في الخطوات التالية.'),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('معاينة الفيديو', Icons.ondemand_video),
          const SizedBox(height: 10),
          Center(
            child: AspectRatio(
              aspectRatio: _aspect == '9:16' ? 9 / 16 : (_aspect == '1:1' ? 1 : 16 / 9),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 360, maxHeight: 520),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF253A39), Color(0xFF111824), Color(0xFF05080D)],
                  ),
                  border: Border.all(color: const Color(0xFFB99143), width: 1.2),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: _backgroundDim),
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, color: Color(0xFFD8B15A), size: 26),
                          const SizedBox(height: 22),
                          if (_showSurahLabel)
                            Text(
                              _surahController.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFFD8B15A), fontSize: 14),
                            ),
                          const SizedBox(height: 14),
                          Text(
                            _verseController.text.isEmpty ? 'اكتب نص الآية هنا' : _verseController.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: _fontSize,
                              height: 1.8,
                              color: _textColor.withValues(alpha: _textOpacity),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_showTafsir) ...[
                            const SizedBox(height: 20),
                            const Text('التفسير سيظهر هنا بعد إضافة مصدر موثوق.', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Color(0xFFB8C0CC))),
                          ],
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 12, left: 12, right: 12,
                      child: Text(_backgroundName, textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, color: Colors.white54)),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          _sectionTitle('إعدادات الفيديو', Icons.tune),
          const SizedBox(height: 10),
          _panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('مقاس الفيديو'),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  _choice('9:16', 'عمودي'),
                  _choice('16:9', 'أفقي'),
                  _choice('1:1', 'مربع'),
                ]),
                const Divider(height: 28),
                const Text('نص الآية'),
                const SizedBox(height: 8),
                TextField(
                  controller: _verseController,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'اكتب نص الآية',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('اسم السورة والآية'),
                const SizedBox(height: 8),
                TextField(
                  controller: _surahController,
                  textAlign: TextAlign.right,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('إظهار اسم السورة'),
                  value: _showSurahLabel,
                  onChanged: (v) => setState(() => _showSurahLabel = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('إظهار مساحة التفسير'),
                  value: _showTafsir,
                  onChanged: (v) => setState(() => _showTafsir = v),
                ),
                const SizedBox(height: 6),
                Text('حجم الخط: ${_fontSize.round()}'),
                Slider(value: _fontSize, min: 18, max: 44, divisions: 13,
                  onChanged: (v) => setState(() => _fontSize = v)),
                Text('شفافية النص: ${(_textOpacity * 100).round()}%'),
                Slider(value: _textOpacity, min: 0.2, max: 1, divisions: 8,
                  onChanged: (v) => setState(() => _textOpacity = v)),
                Text('تعتيم الخلفية: ${(_backgroundDim * 100).round()}%'),
                Slider(value: _backgroundDim, min: 0, max: 0.8, divisions: 8,
                  onChanged: (v) => setState(() => _backgroundDim = v)),
                const SizedBox(height: 8),
                const Text('لون النص'),
                const SizedBox(height: 8),
                Wrap(spacing: 10, children: [
                  _colorDot(const Color(0xFFF5E6B8)),
                  _colorDot(Colors.white),
                  _colorDot(const Color(0xFF9FE3D2)),
                  _colorDot(const Color(0xFFFFD0D0)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('الصوت والقارئ', Icons.graphic_eq),
          const SizedBox(height: 10),
          _panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('القارئ'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _reader,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'عبدالرحمن السديس', child: Text('عبدالرحمن السديس')),
                  DropdownMenuItem(value: 'ماهر المعيقلي', child: Text('ماهر المعيقلي')),
                  DropdownMenuItem(value: 'مشاري العفاسي', child: Text('مشاري العفاسي')),
                  DropdownMenuItem(value: 'عبدالباسط عبدالصمد', child: Text('عبدالباسط عبدالصمد')),
                  DropdownMenuItem(value: 'محمد صديق المنشاوي', child: Text('محمد صديق المنشاوي')),
                  DropdownMenuItem(value: 'محمود خليل الحصري', child: Text('محمود خليل الحصري')),
                ],
                onChanged: (v) => setState(() => _reader = v ?? _reader),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _message('اختيار ملف الصوت يحتاج إضافة صلاحية ومكتبة ملفات في الخطوة التالية.'),
                icon: const Icon(Icons.audio_file),
                label: Text(_audioSelected ? 'تم اختيار ملف صوت' : 'اختيار ملف تلاوة من الهاتف'),
              ),
              const SizedBox(height: 4),
              Text('القارئ المختار: $_reader', style: const TextStyle(color: Color(0xFFB8C0CC), fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 16),
          _sectionTitle('الخلفية والتصدير', Icons.movie_creation_outlined),
          const SizedBox(height: 10),
          _panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              OutlinedButton.icon(
                onPressed: () => _message('اختيار الصور والفيديوهات من الهاتف سيتم تفعيله في الخطوة التالية.'),
                icon: const Icon(Icons.wallpaper),
                label: const Text('اختيار صورة أو فيديو للخلفية'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _message('هذه النسخة لا تصدّر فيديو حقيقيًا بعد. سنضيف التصدير بعد إعداد المشروع وتشغيله.'),
                icon: const Icon(Icons.file_download_outlined),
                label: const Text('تصدير MP4 (غير مفعّل بعد)'),
              ),
              const SizedBox(height: 8),
              const Text(
                'تنبيه: هذه نسخة تأسيسية بواجهة تفاعلية. لا تحتوي بعد على قاعدة قرآن موثوقة أو مزامنة آيات أو تصدير فيديو حقيقي.',
                style: TextStyle(color: Color(0xFFE6C778), fontSize: 12, height: 1.5),
              ),
            ]),
          ),
          const SizedBox(height: 28),
          const Center(child: Text('Quran Video Studio • نسخة تأسيسية', style: TextStyle(color: Colors.white38, fontSize: 11))),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) => Row(
    children: [
      Icon(icon, color: const Color(0xFFD8B15A)),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ],
  );

  Widget _panel({required Widget child}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF151D28),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFF293444)),
    ),
    child: child,
  );

  Widget _choice(String value, String label) => ChoiceChip(
    label: Text('$label ($value)'),
    selected: _aspect == value,
    onSelected: (_) => setState(() => _aspect = value),
  );

  Widget _colorDot(Color color) => InkWell(
    onTap: () => setState(() => _textColor = color),
    borderRadius: BorderRadius.circular(30),
    child: Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: _textColor == color ? const Color(0xFFD8B15A) : Colors.white30, width: _textColor == color ? 3 : 1),
      ),
    ),
  );
}