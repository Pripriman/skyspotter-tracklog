import 'package:flutter/material.dart';
import '../../theme/sky_palette.dart';
import '../../theme/sky_type.dart';
import '../../widgets/aircraft_silhouette.dart';
import '../../widgets/lift_button.dart';

class _Panel {
  final IconData icon;
  final String title;
  final String body;
  final double heading;
  const _Panel(this.icon, this.title, this.body, this.heading);
}

class IntroDeck extends StatefulWidget {
  final VoidCallback onDone;
  const IntroDeck({super.key, required this.onDone});

  @override
  State<IntroDeck> createState() => _IntroDeckState();
}

class _IntroDeckState extends State<IntroDeck> {
  final _controller = PageController();
  int _index = 0;

  static const _panels = [
    _Panel(Icons.travel_explore_rounded, 'Find any flight',
        'Type a flight number and pull up a boarding-pass card with the route, live status, aircraft type and times — all on one screen.', 30),
    _Panel(Icons.my_location_rounded, 'See what is overhead',
        'Point your phone at the sky and the tracker matches your heading to nearby flights, so you know exactly which jet just flew over.', 70),
    _Panel(Icons.dvr_rounded, 'Catalogue the fleet',
        'Tell an A320 from an A321 with the built-in type guide and airline livery reference — fully offline, ready at the fence.', 110),
    _Panel(Icons.book_rounded, 'Build your logbook',
        'Save every observation with tail number, place and date, then watch your collection of unique types and airlines grow.', 150),
  ];

  bool get _last => _index == _panels.length - 1;

  void _next() {
    if (_last) {
      widget.onDone();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: SkyPalette.skyWashGradient),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, top: 4),
                  child: AnimatedOpacity(
                    opacity: _last ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: GhostLink(
                      label: 'Skip',
                      onPressed: _last ? null : widget.onDone,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _panels.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final p = _panels[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.65),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: SkyPalette.skyDeep
                                      .withValues(alpha: 0.14),
                                  blurRadius: 30,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AircraftSilhouette(
                                  size: 72,
                                  heading: p.heading,
                                  color:
                                      SkyPalette.sky.withValues(alpha: 0.25),
                                ),
                                Icon(p.icon,
                                    size: 56, color: SkyPalette.skyDeep),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(p.title,
                              style: SkyType.title(),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 14),
                          Text(p.body,
                              style: SkyType.body(),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_panels.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? SkyPalette.sky : SkyPalette.hairline,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 28),
                child: LiftButton(
                  label: _last ? 'Start tracking' : 'Next',
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
