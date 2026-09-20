import 'package:flutter/material.dart';
import '../radio/radio_screen.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/mosaic_background.dart';
import '../achievements/achievements_screen.dart';
import '../asma_ul_husna/asma_ul_husna_screen.dart';
import '../bookmarks/bookmarks_screen.dart';
import '../duas/my_duas_screen.dart';
import '../duas/dua_library_screen.dart';
import '../quran/surah_comparison_screen.dart';
import '../quran/reciter_comparison_screen.dart';
import '../quran/study_plan_screen.dart';
import '../quran/memorization_game_screen.dart';
import '../prayer/qada_tracker_screen.dart';
import '../prayer/congregation_tracker_screen.dart';
import '../quran/recitation_mistake_log_screen.dart';
import '../hadith/hadith_memorization_screen.dart';
import '../quran/quranic_arabic_lessons_screen.dart';
import '../prayer/sajda_sahw_guide_screen.dart';
import '../prayer/janazah_guide_screen.dart';
import '../prayer/travel_prayer_guide_screen.dart';
import 'islamic_etiquette_screen.dart';
import '../sadaqah/sadaqah_jariyah_ideas_screen.dart';
import 'islamic_will_guide_screen.dart';
import '../prophet/prophet_stories_screen.dart';
import '../asma_ul_husna/asma_ul_husna_quiz_screen.dart';
import '../insights/muhasabah_journal_screen.dart';
import '../zakat/zakat_trade_goods_screen.dart';
import '../prophet/sahaba_quiz_screen.dart';
import '../history/islamic_history_quiz_screen.dart';
import '../prayer/prayer_calendar_export_screen.dart';
import '../prayer/other_city_prayer_times_screen.dart';
import '../quran/sajda_tilawah_guide_screen.dart';
import '../quran/sajdah_verses_screen.dart';
import '../azkar/ruqyah_screen.dart';
import '../prayer/monthly_prayer_calendar_screen.dart';
import '../zakat/zakat_fitr_calculator_screen.dart';
import '../zakat/qurbani_calculator_screen.dart';
import '../prayer/fasting_countdown_screen.dart';
import '../ramadan/sunnah_fasting_calendar_screen.dart';
import '../hadeeth_enc/hadeeth_hub_screen.dart';
import '../insights/wirdi_insights_screen.dart';
import '../khatma/khatma_tracker_screen.dart';
import '../mosque_finder/mosque_finder_screen.dart';
import '../qibla/qibla_screen.dart';
import '../qibla/advanced_qibla_screen.dart';
import '../quran/mushaf_reader_screen.dart';
import '../quran/hifz_screen.dart';
import '../azkar/custom_azkar_screen.dart';
import '../search/global_search_screen.dart';
import '../quiz/quiz_screen.dart';
import '../sadaqah/sadaqah_screen.dart';
import '../ramadan/ramadan_companion_screen.dart';
import '../insights/activity_heatmap_screen.dart';
import '../quran/hifz_revision_screen.dart';
import '../wird/my_wirdi_screen.dart';
import '../zakat/zakat_calculator_screen.dart';
import '../hajj/hajj_umrah_guide_screen.dart';
import '../prophet/prophet_biography_screen.dart';
import '../history/islamic_history_screen.dart';
import 'hijri_converter_screen.dart';
import '../history/islamic_events_screen.dart';
import '../fatwa/fatwa_screen.dart';
import '../articles/articles_screen.dart';
import '../moon/moon_screen.dart';

/// Logical grouping for the tools grid/list so related tools sit
/// together instead of one long flat list. Purely a display grouping;
/// it does not change any tool's screen, builder, or behavior.
enum _ToolCategory {
  quran,
  hadithSeerah,
  azkarDuas,
  prayerQibla,
  fastingRamadan,
  zakatCharity,
  quizzes,
  knowledgeGuides,
  personalGrowth,
  utilities,
}

extension on _ToolCategory {
  IconData get icon {
    switch (this) {
      case _ToolCategory.quran:
        return Icons.menu_book_rounded;
      case _ToolCategory.hadithSeerah:
        return Icons.history_edu;
      case _ToolCategory.azkarDuas:
        return Icons.auto_stories_outlined;
      case _ToolCategory.prayerQibla:
        return Icons.mosque_outlined;
      case _ToolCategory.fastingRamadan:
        return Icons.nightlight_round;
      case _ToolCategory.zakatCharity:
        return Icons.volunteer_activism_outlined;
      case _ToolCategory.quizzes:
        return Icons.quiz_outlined;
      case _ToolCategory.knowledgeGuides:
        return Icons.menu_book_outlined;
      case _ToolCategory.personalGrowth:
        return Icons.insights_outlined;
      case _ToolCategory.utilities:
        return Icons.grid_view_rounded;
    }
  }

  String titleFor(AppLocalizations l10n) {
    final ar = l10n.localeName == 'ar';
    switch (this) {
      case _ToolCategory.quran:
        return ar ? 'القرآن الكريم' : 'The Quran';
      case _ToolCategory.hadithSeerah:
        return ar ? 'الحديث والسيرة والتاريخ' : 'Hadith, Seerah & History';
      case _ToolCategory.azkarDuas:
        return ar ? 'الأذكار والأدعية' : 'Azkar & Duas';
      case _ToolCategory.prayerQibla:
        return ar ? 'الصلاة والقبلة' : 'Prayer & Qibla';
      case _ToolCategory.fastingRamadan:
        return ar ? 'الصيام ورمضان' : 'Fasting & Ramadan';
      case _ToolCategory.zakatCharity:
        return ar ? 'الزكاة والصدقة' : 'Zakat & Charity';
      case _ToolCategory.quizzes:
        return ar ? 'الاختبارات والتحديات' : 'Quizzes & Challenges';
      case _ToolCategory.knowledgeGuides:
        return ar ? 'المعرفة والأحكام' : 'Knowledge & Guides';
      case _ToolCategory.personalGrowth:
        return ar ? 'متابعتي الشخصية' : 'My Personal Progress';
      case _ToolCategory.utilities:
        return ar ? 'أدوات عامة' : 'General Utilities';
    }
  }
}

class _ToolEntry {
  final IconData icon;
  final _ToolCategory category;
  final String Function(AppLocalizations) titleFor;
  final String Function(AppLocalizations) subtitleFor;
  final WidgetBuilder builder;
  const _ToolEntry({
    required this.icon,
    required this.category,
    required this.titleFor,
    required this.subtitleFor,
    required this.builder,
  });
}

class IslamicToolsScreen extends StatelessWidget {
  const IslamicToolsScreen({super.key});

  static final List<_ToolEntry> _tools = [
    _ToolEntry(
      icon: Icons.menu_book_rounded,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'قارئ القرآن' : 'Quran Reader',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'اقرأ واستمع وأضف إشارة مرجعية لكل السور الـ114' : 'Read, listen and bookmark all 114 surahs',
      builder: (_) => const MushafReaderScreen(),
    ),
    _ToolEntry(
      icon: Icons.school_outlined,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'وضع الحفظ' : 'Hifz Mode',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'تدرّب على حفظ القرآن بإخفاء الكلمات' : 'Practice memorization by hiding words',
      builder: (_) => const HifzScreen(),
    ),
    _ToolEntry(
      icon: Icons.repeat_rounded,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? '\u0645\u0631\u0627\u062c\u0639\u0629 \u0627\u0644\u062d\u0641\u0638' : 'Hifz Revision',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? '\u0631\u0627\u062c\u0639 \u0645\u0627 \u062d\u0641\u0638\u062a\u0647 \u0633\u0627\u0628\u0642\u064b\u0627' : 'Revise what you memorized before',
      builder: (_) => const HifzRevisionScreen(),
    ),
    _ToolEntry(
      icon: Icons.event_available,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'خطة الحفظ' : 'Study Plan',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'خطة يومية محسوبة لحفظ أي سورة' : 'A computed daily pace to memorize any surah',
      builder: (_) => const StudyPlanScreen(),
    ),
    _ToolEntry(
      icon: Icons.videogame_asset_outlined,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'اختبار الحفظ' : 'Memorization Test',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'خمّن الكلمة الناقصة من الآية' : 'Guess the missing word from the verse',
      builder: (_) => const MemorizationGameScreen(),
    ),
    _ToolEntry(
      icon: Icons.compare_arrows,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'معلومات عن السور' : 'Surah Information',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'قارن بين سورتين في عدد الآيات وطولها' : 'Compare two surahs by verse count and length',
      builder: (_) => const SurahComparisonScreen(),
    ),
    _ToolEntry(
      icon: Icons.record_voice_over_outlined,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'معلومات عن القراء' : 'Reciter Info',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'تعرّف على أسلوب كل قارئ قبل الاختيار' : 'Learn each reciter\'s style before choosing',
      builder: (_) => const ReciterComparisonScreen(),
    ),
    _ToolEntry(
      icon: Icons.translate,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'دروس عربية القرآن' : 'Quranic Arabic Lessons',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'أهم الكلمات المتكررة في القرآن ومعانيها' : 'The most common Quranic words and their meanings',
      builder: (_) => const QuranicArabicLessonsScreen(),
    ),
    _ToolEntry(
      icon: Icons.filter_hdr,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'دليل سجود التلاوة' : 'Sujud al-Tilawah Guide',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'متى وكيف تُؤدى سجدة التلاوة' : 'When and how to perform the recitation prostration',
      builder: (_) => const SajdaTilawahGuideScreen(),
    ),
    _ToolEntry(
      icon: Icons.bookmark_border,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'آيات السجدة' : 'Sajdah Verses',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'قائمة مواضع آيات السجدة الخمس عشرة' : 'A list of the 15 sajdah-verse locations',
      builder: (_) => const SajdahVersesScreen(),
    ),
    _ToolEntry(
      icon: Icons.fact_check_outlined,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'سجل أخطاء التلاوة' : 'Recitation Mistake Log',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'دوّن الأخطاء المتكررة لتركّز عليها' : 'Note recurring mistakes so you can focus on them',
      builder: (_) => const RecitationMistakeLogScreen(),
    ),
    _ToolEntry(
      icon: Icons.timeline_outlined,
      category: _ToolCategory.quran,
      titleFor: (l10n) => l10n.toolKhatmaTitle,
      subtitleFor: (l10n) => l10n.toolKhatmaSubtitle,
      builder: (_) => const KhatmaTrackerScreen(),
    ),
    _ToolEntry(
      icon: Icons.menu_book_outlined,
      category: _ToolCategory.hadithSeerah,
      titleFor: (l10n) => l10n.toolHadithTitle,
      subtitleFor: (l10n) => l10n.toolHadithSubtitle,
      builder: (_) => const HadeethHubScreen(),
    ),
    _ToolEntry(
      icon: Icons.menu_book,
      category: _ToolCategory.hadithSeerah,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'حفظ الأحاديث' : 'Hadith Memorization',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'احفظ الأربعين النووية بلعبة تخمين الكلمة' : 'Memorize the 40 Hadith of an-Nawawi with a word-guessing game',
      builder: (_) => const HadithMemorizationScreen(),
    ),
    _ToolEntry(
      icon: Icons.quiz_outlined,
      category: _ToolCategory.quizzes,
      titleFor: (l10n) => l10n.localeName == 'ar' ? '\u0645\u0633\u0627\u0628\u0642\u0629 \u0645\u0639\u0644\u0648\u0645\u0627\u062a' : 'Islamic Quiz',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? '\u0627\u062e\u062a\u0628\u0631 \u0645\u0639\u0644\u0648\u0645\u0627\u062a\u0643 \u0639\u0646 \u0627\u0644\u0642\u0631\u0622\u0646 \u0648\u0627\u0644\u0633\u064a\u0631\u0629' : 'Test your knowledge of Quran and Seerah',
      builder: (_) => const QuizScreen(),
    ),
    _ToolEntry(
      icon: Icons.quiz_outlined,
      category: _ToolCategory.quizzes,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'اختبار الأسماء الحسنى' : 'Names of Allah Quiz',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'اختبر حفظك لأسماء الله الحسنى ومعانيها' : 'Test your memorization of the 99 Names and their meanings',
      builder: (_) => const AsmaUlHusnaQuizScreen(),
    ),
    _ToolEntry(
      icon: Icons.groups_2_outlined,
      category: _ToolCategory.quizzes,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'اختبار عن الصحابة' : 'Sahaba Quiz',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'أسئلة عن حياة وفضائل الصحابة رضي الله عنهم' : 'Questions about the lives and virtues of the companions',
      builder: (_) => const SahabaQuizScreen(),
    ),
    _ToolEntry(
      icon: Icons.school_outlined,
      category: _ToolCategory.quizzes,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'اختبار التاريخ الإسلامي' : 'Islamic History Quiz',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'أسئلة عن الأحداث الكبرى في التاريخ الإسلامي' : 'Questions about major events in Islamic history',
      builder: (_) => const IslamicHistoryQuizScreen(),
    ),
    _ToolEntry(
      icon: Icons.explore_outlined,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.toolQiblaTitle,
      subtitleFor: (l10n) => l10n.toolQiblaSubtitle,
      builder: (_) => const QiblaScreen(),
    ),
    _ToolEntry(
      icon: Icons.explore,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.toolPrecisionQiblaTitle,
      subtitleFor: (l10n) => l10n.toolPrecisionQiblaSubtitle,
      builder: (_) => const AdvancedQiblaScreen(),
    ),
    _ToolEntry(
      icon: Icons.event_busy_outlined,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'قضاء الصلوات الفائتة' : 'Missed Prayers (Qada)',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'سجّل وتابع الصلوات التي عليك قضاؤها' : 'Track and log the prayers you owe',
      builder: (_) => const QadaTrackerScreen(),
    ),
    _ToolEntry(
      icon: Icons.groups_outlined,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'صلاة الجماعة' : 'Congregation Prayer',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'سجّل الصلوات التي أديتها في جماعة' : 'Track prayers performed in congregation',
      builder: (_) => const CongregationTrackerScreen(),
    ),
    _ToolEntry(
      icon: Icons.self_improvement_outlined,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'دليل سجود السهو' : 'Sujud al-Sahw Guide',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'ماذا تفعل عند النسيان في الصلاة' : 'What to do when you forget something in prayer',
      builder: (_) => const SajdaSahwGuideScreen(),
    ),
    _ToolEntry(
      icon: Icons.mosque,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'دليل صلاة الجنازة' : 'Janazah Prayer Guide',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'التكبيرات الأربع وما يُقال في كل واحدة' : 'The four Takbirs and what to say in each',
      builder: (_) => const JanazahGuideScreen(),
    ),
    _ToolEntry(
      icon: Icons.flight_takeoff_outlined,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'دليل الجمع والقصر للمسافر' : "Travel Prayer Guide (Jam' & Qasr)",
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'أحكام تقصير وجمع الصلاة في السفر' : 'Rules for shortening and combining prayers while traveling',
      builder: (_) => const TravelPrayerGuideScreen(),
    ),
    _ToolEntry(
      icon: Icons.location_city_outlined,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'مواقيت مدينة أخرى' : 'Prayer Times in Another City',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'اطّلع على مواقيت الصلاة في أي مدينة بدون تغيير موقعك' : 'Check prayer times in any city without changing your own location',
      builder: (_) => const OtherCityPrayerTimesScreen(),
    ),
    _ToolEntry(
      icon: Icons.calendar_month,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'تصدير المواقيت للتقويم' : 'Export Prayer Times to Calendar',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'ملف تقويم حقيقي (.ics) لمواقيت اليوم' : "A real calendar file (.ics) for today's prayer times",
      builder: (_) => const PrayerCalendarExportScreen(),
    ),
    _ToolEntry(
      icon: Icons.table_chart_outlined,
      category: _ToolCategory.prayerQibla,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'جدول الشهر لمواقيت الصلاة' : 'Monthly Prayer Times Table',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'كل مواقيت الشهر في جدول واحد' : "The whole month's prayer times in one table",
      builder: (_) => const MonthlyPrayerCalendarScreen(),
    ),
    _ToolEntry(
      icon: Icons.timer_outlined,
      category: _ToolCategory.fastingRamadan,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'عداد الإفطار والسحور' : 'Iftar & Suhoor Countdown',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'عد تنازلي حي لوقت الإفطار ونهاية السحور' : 'Live countdown to Iftar time and end of Suhoor',
      builder: (_) => const FastingCountdownScreen(),
    ),
    _ToolEntry(
      icon: Icons.calendar_month_outlined,
      category: _ToolCategory.fastingRamadan,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'تقويم الصيام المستحب' : 'Sunnah Fasting Calendar',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'الإثنين والخميس والأيام البيض القادمة' : 'Upcoming Mondays, Thursdays, and White Days',
      builder: (_) => const SunnahFastingCalendarScreen(),
    ),
    _ToolEntry(
      icon: Icons.nightlight_outlined,
      category: _ToolCategory.fastingRamadan,
      titleFor: (l10n) => l10n.toolRamadanTitle,
      subtitleFor: (l10n) => l10n.toolRamadanSubtitle,
      builder: (_) => const RamadanCompanionScreen(),
    ),
    _ToolEntry(
      icon: Icons.calculate_outlined,
      category: _ToolCategory.zakatCharity,
      titleFor: (l10n) => l10n.toolZakatTitle,
      subtitleFor: (l10n) => l10n.toolZakatSubtitle,
      builder: (_) => const ZakatCalculatorScreen(),
    ),
    _ToolEntry(
      icon: Icons.volunteer_activism_outlined,
      category: _ToolCategory.zakatCharity,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'حاسبة زكاة الفطر' : 'Zakat al-Fitr Calculator',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'احسب زكاة الفطر لأفراد أسرتك' : 'Calculate Zakat al-Fitr for your household',
      builder: (_) => const ZakatFitrCalculatorScreen(),
    ),
    _ToolEntry(
      icon: Icons.pets_outlined,
      category: _ToolCategory.zakatCharity,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'الأضحية والعقيقة' : 'Qurbani & Aqiqah',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'معلومات وحاسبة أنصبة الأضحية والعقيقة' : 'Info and share calculator for Qurbani & Aqiqah',
      builder: (_) => const QurbaniCalculatorScreen(),
    ),
    _ToolEntry(
      icon: Icons.storefront_outlined,
      category: _ToolCategory.zakatCharity,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'زكاة عروض التجارة' : 'Zakat on Trade Goods',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'حاسبة منفصلة لأصحاب التجارة والمحلات' : 'A separate calculator for business owners',
      builder: (_) => const ZakatTradeGoodsScreen(),
    ),
    _ToolEntry(
      icon: Icons.volunteer_activism_outlined,
      category: _ToolCategory.zakatCharity,
      titleFor: (l10n) => l10n.localeName == 'ar' ? '\u0645\u062a\u062a\u0628\u0651\u0639 \u0627\u0644\u0635\u062f\u0642\u0629' : 'Sadaqah Tracker',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? '\u0633\u062c\u0651\u0644 \u0635\u062f\u0642\u0627\u062a\u0643' : 'Log your charity',
      builder: (_) => const SadaqahScreen(),
    ),
    _ToolEntry(
      icon: Icons.eco_outlined,
      category: _ToolCategory.zakatCharity,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'أفكار صدقة جارية' : 'Sadaqah Jariyah Ideas',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'اقتراحات حقيقية للصدقة المستمرة' : 'Real suggestions for ongoing charity',
      builder: (_) => const SadaqahJariyahIdeasScreen(),
    ),
    _ToolEntry(
      icon: Icons.repeat_rounded,
      category: _ToolCategory.azkarDuas,
      titleFor: (l10n) => l10n.localeName == 'ar' ? '\u0623\u0630\u0643\u0627\u0631\u064a \u0627\u0644\u062e\u0627\u0635\u0629' : 'My Custom Azkar',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? '\u0623\u0646\u0634\u0626 \u0630\u0643\u0631\u064b\u0627 \u062e\u0627\u0635\u064b\u0627 \u0628\u0639\u062f\u0651\u0627\u062f \u0647\u062f\u0641' : 'Create your own dhikr with a target count',
      builder: (_) => const CustomAzkarScreen(),
    ),
    _ToolEntry(
      icon: Icons.menu_book_outlined,
      category: _ToolCategory.azkarDuas,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'مكتبة الأدعية' : 'Dua Library',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'أدعية مأثورة لكل مناسبة مع فوائدها' : 'Authentic duas for every occasion, with benefits',
      builder: (_) => const DuaLibraryScreen(),
    ),
    _ToolEntry(
      icon: Icons.auto_stories_outlined,
      category: _ToolCategory.azkarDuas,
      titleFor: (l10n) => l10n.toolDuasTitle,
      subtitleFor: (l10n) => l10n.toolDuasSubtitle,
      builder: (_) => const MyDuasScreen(),
    ),
    _ToolEntry(
      icon: Icons.healing_outlined,
      category: _ToolCategory.azkarDuas,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'الرقية الشرعية' : 'Ruqyah (Spiritual Healing)',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'آيات وأدعية ثابتة للرقية الشرعية' : 'Authentic verses and supplications for spiritual healing',
      builder: (_) => const RuqyahScreen(),
    ),
    _ToolEntry(
      icon: Icons.auto_awesome_outlined,
      category: _ToolCategory.azkarDuas,
      titleFor: (l10n) => l10n.toolAsmaTitle,
      subtitleFor: (l10n) => l10n.toolAsmaSubtitle,
      builder: (_) => const AsmaUlHusnaScreen(),
    ),
    _ToolEntry(
      icon: Icons.auto_stories,
      category: _ToolCategory.hadithSeerah,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'سيرة النبي صلى الله عليه وسلم' : "Prophet's Biography",
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'أهم أحداث حياته الكريمة' : 'Key events of his life',
      builder: (_) => const ProphetBiographyScreen(),
    ),
    _ToolEntry(
      icon: Icons.auto_stories,
      category: _ToolCategory.hadithSeerah,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'قصص الأنبياء' : 'Stories of the Prophets',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'قصص موجزة لعدد من الأنبياء عليهم السلام' : 'Brief stories of several prophets, peace be upon them',
      builder: (_) => const ProphetStoriesScreen(),
    ),
    _ToolEntry(
      icon: Icons.history_edu,
      category: _ToolCategory.hadithSeerah,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'التاريخ الإسلامي' : 'Islamic History',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'خط زمني بأهم الأحداث الإسلامية' : 'Timeline of major Islamic events',
      builder: (_) => const IslamicHistoryScreen(),
    ),
    _ToolEntry(icon: Icons.event_outlined, category: _ToolCategory.hadithSeerah, titleFor: (l10n) => l10n.localeName == 'ar' ? 'المناسبات الإسلامية' : 'Islamic Events', subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'عاشوراء والهجرة وغيرها' : 'Ashura, Hijra, and more', builder: (_) => const IslamicEventsScreen()),
    _ToolEntry(
      icon: Icons.date_range,
      category: _ToolCategory.knowledgeGuides,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'محول التاريخ الهجري' : 'Hijri Converter',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'حوّل بين التاريخ الميلادي والهجري' : 'Convert between Gregorian and Hijri dates',
      builder: (_) => const HijriConverterScreen(),
    ),
    _ToolEntry(icon: Icons.brightness_2_outlined, category: _ToolCategory.knowledgeGuides, titleFor: (l10n) => l10n.localeName == 'ar' ? 'القمر وطوره' : 'Moon Phase', subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'طور القمر الحالي (تقدير فلكي)' : 'Current moon phase (astronomical estimate)', builder: (_) => const MoonScreen()),
    _ToolEntry(icon: Icons.article_outlined, category: _ToolCategory.knowledgeGuides, titleFor: (l10n) => l10n.localeName == 'ar' ? 'مقالات إسلامية' : 'Islamic Articles', subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'مقالات معرفية قصيرة' : 'Short educational articles', builder: (_) => const ArticlesScreen()),
    _ToolEntry(icon: Icons.gavel_outlined, category: _ToolCategory.knowledgeGuides, titleFor: (l10n) => l10n.localeName == 'ar' ? 'أحكام فقهية عامة' : 'General Rulings', subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'أسئلة شائعة متفق عليها' : 'Common, widely-agreed questions', builder: (_) => const FatwaScreen()),
    _ToolEntry(
      icon: Icons.mosque,
      category: _ToolCategory.knowledgeGuides,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'دليل الحج والعمرة' : 'Hajj & Umrah Guide',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'خطوات الحج بالترتيب مع الأدعية' : 'Step-by-step guide with duas',
      builder: (_) => const HajjUmrahGuideScreen(),
    ),
    _ToolEntry(
      icon: Icons.handshake_outlined,
      category: _ToolCategory.knowledgeGuides,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'آداب إسلامية عامة' : 'Islamic Etiquette (Adab)',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'آداب الطعام والنوم والسلام والعطاس' : 'Etiquette of eating, sleeping, greeting, and sneezing',
      builder: (_) => const IslamicEtiquetteScreen(),
    ),
    _ToolEntry(
      icon: Icons.description_outlined,
      category: _ToolCategory.knowledgeGuides,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'دليل كتابة الوصية' : 'Islamic Will Guide',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'إرشادات عامة لكتابة وصية إسلامية' : 'General guidance for writing an Islamic will',
      builder: (_) => const IslamicWillGuideScreen(),
    ),
    _ToolEntry(
      icon: Icons.grid_view_rounded,
      category: _ToolCategory.personalGrowth,
      titleFor: (l10n) => l10n.localeName == 'ar' ? '\u062e\u0631\u064a\u0637\u0629 \u0627\u0644\u0646\u0634\u0627\u0637' : 'Activity Heatmap',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? '\u0634\u0627\u0647\u062f \u0646\u0634\u0627\u0637\u0643 \u0639\u0644\u0649 \u0645\u062f\u0627\u0631 \u0627\u0644\u0623\u0633\u0627\u0628\u064a\u0639' : 'See your activity over the weeks',
      builder: (_) => const ActivityHeatmapScreen(),
    ),
    _ToolEntry(
      icon: Icons.insights_outlined,
      category: _ToolCategory.personalGrowth,
      titleFor: (l10n) => l10n.toolInsightsTitle,
      subtitleFor: (l10n) => l10n.toolInsightsSubtitle,
      builder: (_) => const WirdiInsightsScreen(),
    ),
    _ToolEntry(
      icon: Icons.self_improvement,
      category: _ToolCategory.personalGrowth,
      titleFor: (l10n) => l10n.localeName == 'ar' ? 'محاسبة النفس' : 'Self-Accountability Journal',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? 'مفكرة يومية بسيطة للتأمل والتحسين' : 'A simple daily journal for reflection and self-improvement',
      builder: (_) => const MuhasabahJournalScreen(),
    ),
    _ToolEntry(
      icon: Icons.military_tech_outlined,
      category: _ToolCategory.personalGrowth,
      titleFor: (l10n) => l10n.toolAchievementsTitle,
      subtitleFor: (l10n) => l10n.toolAchievementsSubtitle,
      builder: (_) => const AchievementsScreen(),
    ),
    _ToolEntry(
      icon: Icons.bookmark_add_outlined,
      category: _ToolCategory.personalGrowth,
      titleFor: (l10n) => l10n.toolBookmarksTitle,
      subtitleFor: (l10n) => l10n.toolBookmarksSubtitle,
      builder: (_) => const BookmarksScreen(),
    ),
    _ToolEntry(
      icon: Icons.checklist_rtl_outlined,
      category: _ToolCategory.personalGrowth,
      titleFor: (l10n) => l10n.toolMyWirdiTitle,
      subtitleFor: (l10n) => l10n.toolMyWirdiSubtitle,
      builder: (_) => const MyWirdiScreen(),
    ),
    _ToolEntry(
      icon: Icons.search,
      category: _ToolCategory.utilities,
      titleFor: (l10n) => l10n.localeName == 'ar' ? '\u0628\u062d\u062b \u0634\u0627\u0645\u0644' : 'Global Search',
      subtitleFor: (l10n) => l10n.localeName == 'ar' ? '\u0627\u0628\u062d\u062b \u0641\u064a \u0643\u0644 \u0634\u064a\u0621 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629' : 'Search everything at once',
      builder: (_) => const GlobalSearchScreen(),
    ),
    _ToolEntry(
      icon: Icons.mosque_outlined,
      category: _ToolCategory.utilities,
      titleFor: (l10n) => l10n.toolMosqueTitle,
      subtitleFor: (l10n) => l10n.toolMosqueSubtitle,
      builder: (_) => const MosqueFinderScreen(),
    ),
    _ToolEntry(
      icon: Icons.radio_rounded,
      category: _ToolCategory.utilities,
      titleFor: (l10n) => l10n.radioTitle,
      subtitleFor: (l10n) => l10n.radioSubtitle,
      builder: (_) => const RadioScreen(),
    ),
  ];

  /// Tools grouped by [_ToolCategory], in the category's declared enum
  /// order, preserving each tool's original relative order within its
  /// group. Purely a display-time grouping over the existing [_tools]
  /// list -- no tool, builder, or import is added, removed, or moved.
  static Map<_ToolCategory, List<_ToolEntry>> get _groupedTools {
    final map = <_ToolCategory, List<_ToolEntry>>{};
    for (final tool in _tools) {
      map.putIfAbsent(tool.category, () => []).add(tool);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final grouped = _groupedTools;

    // Flatten into a single list of either a _ToolCategory (rendered as
    // a section header) or a _ToolEntry (rendered as a card), so the
    // whole screen stays one smoothly-scrolling ListView.
    final items = <Object>[];
    for (final category in _ToolCategory.values) {
      final tools = grouped[category];
      if (tools == null || tools.isEmpty) continue;
      items.add(category);
      items.addAll(tools);
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        flexibleSpace: const MosaicBackground(col: 1, row: 0, opacity: 0.35),
        title: Text(l10n.toolsTitle),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          if (item is _ToolCategory) {
            return Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 22, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryEmerald,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.titleFor(l10n),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(start: 10),
                      height: 1.5,
                      color: AppColors.goldAccent.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            );
          }

          final tool = item as _ToolEntry;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: ListTile(
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primaryEmerald.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(tool.icon, color: AppColors.primaryEmerald),
                ),
                title: Text(tool.titleFor(l10n), style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(tool.subtitleFor(l10n), style: const TextStyle(fontSize: 12)),
                trailing: Icon(Icons.chevron_left, color: Colors.grey.shade400, size: 20),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: tool.builder)),
              ),
            ),
          );
        },
      ),
    );
  }
}
