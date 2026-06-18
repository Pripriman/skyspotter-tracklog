import 'package:flutter/material.dart';

import '../../runtime/backend_link.dart';
import '../../runtime/signal_relay.dart';
import '../../theme/sky_palette.dart';
import '../../theme/sky_type.dart';
import '../access/access_screen.dart';
import 'airport_board_view.dart';
import 'fleet_guide_view.dart';
import 'flight_search_view.dart';
import 'overhead_now_view.dart';
import 'spotting_log_view.dart';

class SpotterHomeShell extends StatefulWidget {
  const SpotterHomeShell({super.key});

  @override
  State<SpotterHomeShell> createState() => _SpotterHomeShellState();
}

class _SpotterHomeShellState extends State<SpotterHomeShell> {
  int _tab = 0;

  static const _titles = [
    'Find a flight',
    'Overhead now',
    'Airport board',
    'Fleet guide',
    'Spotting log',
  ];

  void _openAccount() {
    final signedIn = BackendLink.signedIn;
    showModalBottomSheet(
      context: context,
      backgroundColor: SkyPalette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account', style: SkyType.heading()),
                const SizedBox(height: 6),
                Text(
                  signedIn
                      ? (BackendLink.currentUser?.email ?? 'Signed in')
                      : 'You are tracking as a guest.',
                  style: SkyType.body(),
                ),
                const SizedBox(height: 16),
                if (signedIn)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout_rounded,
                        color: SkyPalette.sunsetDeep),
                    title: Text('Sign out',
                        style: SkyType.bodyStrong(
                            color: SkyPalette.sunsetDeep)),
                    onTap: () async {
                      await SignalRelay.unbindUser();
                      await BackendLink.signOut();
                      if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                      if (mounted) setState(() {});
                    },
                  )
                else
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.login_rounded,
                        color: SkyPalette.skyDeep),
                    title: Text('Sign in or create account',
                        style:
                            SkyType.bodyStrong(color: SkyPalette.skyDeep)),
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AccessScreen(
                            onDone: () {
                              Navigator.of(context).maybePop();
                              if (mounted) setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    switch (_tab) {
      case 0:
        body = const FlightSearchView();
        break;
      case 1:
        body = const OverheadNowView();
        break;
      case 2:
        body = const AirportBoardView();
        break;
      case 3:
        body = const FleetGuideView();
        break;
      case 4:
        body = const SpottingLogView();
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: SkyPalette.paper,
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(_titles[_tab], style: SkyType.title()),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            color: SkyPalette.ink,
            onPressed: _openAccount,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: body,
      bottomNavigationBar: _BottomBar(
        index: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomBar({required this.index, required this.onChanged});

  static const _items = [
    (Icons.search_rounded, 'Search'),
    (Icons.my_location_rounded, 'Overhead'),
    (Icons.dvr_rounded, 'Board'),
    (Icons.flight_rounded, 'Fleet'),
    (Icons.menu_book_rounded, 'Log'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: SkyPalette.card,
        border: Border(top: BorderSide(color: SkyPalette.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = i == index;
              final item = _items[i];
              return Expanded(
                child: InkResponse(
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.$1,
                        size: 23,
                        color: selected
                            ? SkyPalette.skyDeep
                            : SkyPalette.inkFaint,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$2,
                        style: SkyType.caption(
                          color: selected
                              ? SkyPalette.skyDeep
                              : SkyPalette.inkFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
