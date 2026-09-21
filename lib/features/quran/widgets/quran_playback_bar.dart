import 'package:flutter/material.dart';
import '../../../core/services/quran_audio_service.dart';
import '../../../core/theme/app_theme.dart';

class QuranPlaybackBar extends StatelessWidget {
  const QuranPlaybackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: quranAudio,
      builder: (context, _) {
        final currentAyah = quranAudio.playingAyah;
        if (currentAyah == null) return const SizedBox.shrink();

        // Surah-wide progress: how far through the whole surah (or active
        // range) playback is, not just the current ayah. Each ayah
        // occupies one unit on the slider; the fractional part comes
        // from how far into that ayah's own audio we are, so the bar
        // still animates smoothly as it plays instead of jumping once
        // per ayah.
        final start = quranAudio.rangeStartAyah;
        final end = quranAudio.rangeEndAyah;
        final totalInRange = (end - start + 1) < 1 ? 1 : (end - start + 1);
        final position = quranAudio.position;
        final duration = quranAudio.duration;
        final withinAyahFraction = duration.inMilliseconds > 0
            ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0).toDouble()
            : 0.0;
        final ayahIndexInRange = (currentAyah - start).clamp(0, totalInRange - 1).toInt();
        final value = (ayahIndexInRange + withinAyahFraction).clamp(0.0, totalInRange.toDouble()).toDouble();

        final isAr = Localizations.localeOf(context).languageCode == 'ar';
        final surahName = quranAudio.currentSurahName ?? (isAr ? 'سورة' : 'Surah');
        return Material(
          elevation: 10,
          color: AppColors.primaryEmerald,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: value,
                  min: 0,
                  max: totalInRange.toDouble(),
                  onChanged: (v) {
                    final targetAyah = start + v.floor();
                    quranAudio.seekToAyah(targetAyah);
                  },
                  activeColor: AppColors.goldAccent,
                  inactiveColor: Colors.white24,
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isAr ? '$surahName • آية $currentAyah من $end' : '$surahName • Ayah $currentAyah of $end',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      tooltip: quranAudio.isPaused ? (isAr ? 'استكمال' : 'Resume') : (isAr ? 'إيقاف مؤقت' : 'Pause'),
                      icon: Icon(quranAudio.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded, color: Colors.white),
                      onPressed: () => quranAudio.isPaused ? quranAudio.resume() : quranAudio.pause(),
                    ),
                    IconButton(
                      tooltip: isAr ? 'إيقاف' : 'Stop',
                      icon: const Icon(Icons.stop_rounded, color: Colors.white70),
                      onPressed: quranAudio.stop,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
