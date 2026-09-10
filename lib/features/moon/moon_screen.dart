import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/services/moon_calculator.dart';
import '../../core/services/moon_phases_service.dart';
import '../../core/services/moon_sighting_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/wirdi_scenic_background.dart';

class MoonScreen extends StatefulWidget {
  const MoonScreen({super.key});
  @override
  State<MoonScreen> createState() => _MoonScreenState();
}

class _MoonScreenState extends State<MoonScreen> {
  MoonSightingInfo? _sighting;
  List<MoonPhase> _monthPhases = [];
  bool _loading = true;
  String? _loadedForLanguageCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_loadedForLanguageCode != languageCode) {
      _loadedForLanguageCode = languageCode;
      _load(languageCode);
    }
  }

  Future<void> _load(String languageCode) async {
    final now = DateTime.now();
    final isAr = languageCode == 'ar';
    final sighting = await MoonSightingService.getMoonSightingInfo(arabic: isAr);
    final phases = await MoonPhasesService.getMoonPhasesForMonth(now.month, now.year, arabic: isAr);
    if (!mounted) return;
    setState(() { _sighting = sighting; _monthPhases = phases; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final sighting = _sighting;
    return Scaffold(
      appBar: AppBar(title: Text(isAr ? 'القمر وأطواره' : 'Moon Phase'), centerTitle: true),
      body: WirdiScenicBackground(
        asset: 'assets/images/ui/moon_night.jpg',
        height: 300,
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryEmerald, const Color(0xFF115E56)]), borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    Text(isAr ? 'طور القمر اليوم' : "Today's Moon Phase", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 10),
                    if (sighting != null)
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: MoonPhaseIcon(ageDays: sighting.ageDays, illumination: sighting.illumination, isWaxing: sighting.isWaxing),
                      ),
                    const SizedBox(height: 10),
                    Text(sighting?.description ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15)),
                  ]),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.goldAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                  child: Text(
                    isAr ? 'ملاحظة: ده تقدير فلكي حسابي فقط، مش إعلان رسمي من لجنة رؤية الهلال.' : 'Note: this is a calculated astronomical estimate only, not an official moon-sighting committee announcement.',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),
                Text(isAr ? 'أطوار القمر هذا الشهر' : 'Moon Phases This Month', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 10),
                for (final p in _monthPhases)
                  if (p.date.endsWith('-01') || p.date.endsWith('-08') || p.date.endsWith('-15') || p.date.endsWith('-22') || p.date.endsWith('-29'))
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SizedBox(
                        width: 44,
                        height: 44,
                        child: MoonPhaseIcon(ageDays: p.ageDays, illumination: p.illumination, isWaxing: p.isWaxing),
                      ),
                      title: Text(p.date),
                      subtitle: Text('${p.phase} -- ${(p.illumination * 100).round()}%'),
                    ),
              ],
            ),
      ),
    );
  }
}

/// Shows a real, photorealistic (AI-generated, telescope/NASA-style --
/// not a copyrighted third-party photo) image for the given moon phase,
/// selected by [ageDays] via MoonCalculator.phaseImageAsset() (same
/// boundaries as the text phase name, so they always agree). Falls back
/// to the previous procedurally-drawn icon if the image asset is ever
/// missing or fails to decode, so this can never render blank.
class MoonPhaseIcon extends StatelessWidget {
  final double ageDays;
  final double illumination;
  final bool isWaxing;
  const MoonPhaseIcon({super.key, required this.ageDays, required this.illumination, required this.isWaxing});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        MoonCalculator.phaseImageAsset(ageDays),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => CustomPaint(
          painter: _MoonPhasePainter(
            illumination: illumination.clamp(0.0, 1.0),
            isWaxing: isWaxing,
          ),
        ),
      ),
    );
  }
}

class _MoonPhasePainter extends CustomPainter {
  final double illumination;
  final bool isWaxing;
  _MoonPhasePainter({required this.illumination, required this.isWaxing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;

    final darkPaint = Paint()..color = const Color(0xFF0B3D34);
    final lightPaint = Paint()..color = AppColors.goldAccent;
    final outlinePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, darkPaint);

    final f = illumination;
    if (f <= 0.01) {
      canvas.drawCircle(center, radius, outlinePaint);
      return;
    }
    if (f >= 0.99) {
      canvas.drawCircle(center, radius, lightPaint);
      canvas.drawCircle(center, radius, outlinePaint);
      return;
    }

    final litOnRight = isWaxing;
    final termRadiusX = radius * (1 - 2 * f).abs();

    final path = Path()..moveTo(center.dx, center.dy - radius);
    path.arcToPoint(
      Offset(center.dx, center.dy + radius),
      radius: Radius.circular(radius),
      clockwise: litOnRight,
    );
    final terminatorClockwise = f <= 0.5 ? !litOnRight : litOnRight;
    path.arcToPoint(
      Offset(center.dx, center.dy - radius),
      radius: Radius.elliptical(termRadiusX, radius),
      clockwise: terminatorClockwise,
    );
    path.close();

    canvas.drawPath(path, lightPaint);
    canvas.drawCircle(center, radius, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant _MoonPhasePainter oldDelegate) =>
      oldDelegate.illumination != illumination || oldDelegate.isWaxing != isWaxing;
}
