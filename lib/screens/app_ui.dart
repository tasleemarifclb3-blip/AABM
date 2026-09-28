import 'package:flutter/material.dart';

import 'brand.dart';

class AppPageHeader extends StatelessWidget {

  final String title;

  final String? subtitle;

  final IconData? icon;

  final Widget? trailing;

  const AppPageHeader({

    super.key,

    required this.title,

    this.subtitle,

    this.icon,

    this.trailing,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF145A4A),
            Color(0xFF1F7A68),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: kBrandGreen.withValues(alpha: .18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BrandLogo(size: 58),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: .82),
                fontSize: 12.5,
              ),
            ),
          ],
          if (icon != null || trailing != null) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 21),
                  ),
                if (icon != null && trailing != null)
                  const SizedBox(width: 8),
                if (trailing != null) trailing!,
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class AppSectionHeader extends StatelessWidget {

  final String title;

  final String? subtitle;

  const AppSectionHeader({super.key, required this.title, this.subtitle});

  @override

  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 10, top: 4),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.end,

        children: [

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: const TextStyle(

                    color: kBrandGreen,

                    fontSize: 18,

                    fontWeight: FontWeight.w800,

                  ),

                ),

                if (subtitle != null) ...[

                  const SizedBox(height: 2),

                  Text(subtitle!, style: const TextStyle(color: Colors.black54, fontSize: 12)),

                ],

              ],

            ),

          ),

          Container(width: 42, height: 3, decoration: BoxDecoration(color: kBrandGold, borderRadius: BorderRadius.circular(3))),

        ],

      ),

    );

  }

}

class AppActionCard extends StatelessWidget {

  final String title;

  final String? subtitle;

  final IconData icon;

  final VoidCallback onTap;

  final bool destructive;

  const AppActionCard({

    super.key,

    required this.title,

    required this.icon,

    required this.onTap,

    this.subtitle,

    this.destructive = false,

  });

  @override
  Widget build(BuildContext context) {
    final accent = destructive ? const Color(0xFFB23A3A) : kBrandGreen;
    final accentSoft = destructive
        ? const Color(0x10B23A3A)
        : const Color(0x101F7A68);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color(0xFFF0F4F2),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent.withValues(alpha: .18)),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: .10),
                blurRadius: 0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentSoft,
                      accent.withValues(alpha: .16),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accent.withValues(alpha: .10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: .95),
                      blurRadius: 2,
                      offset: const Offset(-1, -1),
                    ),
                  ],
                ),
                child: Icon(icon, color: accent, size: 23),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBalanceCard extends StatelessWidget {

  final String title;

  final double amount;

  final VoidCallback? onTap;

  final bool prominent;

  final String tapHint;

  const AppBalanceCard({

    super.key,

    required this.title,

    required this.amount,

    this.onTap,

    this.prominent = false,

    this.tapHint = 'View ledger',

  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 380;
        final iconSize = prominent ? 48.0 : 42.0;
        final iconRadius = prominent ? 14.0 : 13.0;
        final amountStyle = TextStyle(
          color: kBrandGreen,
          fontSize: prominent ? 20 : 17,
          fontWeight: FontWeight.w800,
        );

        final icon = Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kBrandGreen.withValues(alpha: .12),
                kBrandGreen.withValues(alpha: .06),
              ],
            ),
            borderRadius: BorderRadius.circular(iconRadius),
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            color: kBrandGreen,
            size: prominent ? 25 : 22,
          ),
        );

        final amountAndHint = Row(
          children: [
            Flexible(
              child: Text(
                '₹${amount.toStringAsFixed(2)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: amountStyle,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black38,
                size: 22,
              ),
            ],
          ],
        );

        final Widget child;

        if (compact) {
          child = Container(
            padding: EdgeInsets.all(prominent ? 16 : 13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .96),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: kBrandGreen.withValues(alpha: .12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .055),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: prominent ? 15 : 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      amountAndHint,
                      if (onTap != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          tapHint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          child = Container(
            padding: EdgeInsets.all(prominent ? 18 : 15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .96),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: kBrandGreen.withValues(alpha: .12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .045),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: prominent ? 15 : 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(child: amountAndHint),
              ],
            ),
          );
        }

        return onTap == null
            ? child
            : InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(18),
                child: child,
              );
      },
    );
  }
}

class AppFormSection extends StatelessWidget {

  final String title;

  final IconData icon;

  final Widget child;

  const AppFormSection({super.key, required this.title, required this.icon, required this.child});

  @override

  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),

      decoration: BoxDecoration(

        color: Colors.white.withValues(alpha: .92),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: Colors.black.withValues(alpha: .06)),

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [

          Row(

            children: [

              Container(width: 30, height: 30, decoration: BoxDecoration(color: kBrandGreen.withValues(alpha: .10), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: kBrandGreen, size: 17)),

              const SizedBox(width: 8),

              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kBrandGreen)),

            ],

          ),

          const SizedBox(height: 9),

          child,

        ],

      ),

    );

  }

}



class AppDesktopShell extends StatelessWidget {

  final String selected;

  final Widget child;

  final VoidCallback? onDashboard;

  final VoidCallback? onReceive;

  final VoidCallback? onIssueQarza;

  final VoidCallback? onReports;

  final VoidCallback? onSettings;

  const AppDesktopShell({

    super.key,

    required this.selected,

    required this.child,

    this.onDashboard,

    this.onReceive,

    this.onIssueQarza,

    this.onReports,

    this.onSettings,

  });

  @override

  Widget build(BuildContext context) {

    return LayoutBuilder(

      builder: (context, constraints) {

        final wide = constraints.maxWidth >= 900;

        if (!wide) return child;

        return Row(

          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            AppDesktopSidebar(

              selected: selected,

              onDashboard: onDashboard,

              onReceive: onReceive,

              onIssueQarza: onIssueQarza,

              onReports: onReports,

              onSettings: onSettings,

            ),

            Expanded(child: child),

          ],

        );

      },

    );

  }

}

class AppCompactField extends StatelessWidget {

  final String label;

  final Widget child;

  final Color fillColor;

  final double minHeight;

  const AppCompactField({

    super.key,

    required this.label,

    required this.child,

    this.fillColor = const Color(0xFFF3F7F5),

    this.minHeight = 48,

  });

  @override

  Widget build(BuildContext context) {

    return Container(

      constraints: BoxConstraints(minHeight: minHeight),

      decoration: BoxDecoration(

        color: fillColor,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: const Color(0xFF8B9994).withValues(alpha: .45)),

      ),

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),

      child: child,

    );

  }

}

/// Compact desktop navigation panel used by form pages.
/// It intentionally stays narrow so the form remains the primary focus.
class AppDesktopSidebar extends StatelessWidget {

  final String selected;

  final VoidCallback? onDashboard;

  final VoidCallback? onReceive;

  final VoidCallback? onIssueQarza;

  final VoidCallback? onReports;

  final VoidCallback? onSettings;

  const AppDesktopSidebar({

    super.key,

    required this.selected,

    this.onDashboard,

    this.onReceive,

    this.onIssueQarza,

    this.onReports,

    this.onSettings,

  });

  @override

  Widget build(BuildContext context) {

    return Container(

      width: 78,

      margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),

      decoration: BoxDecoration(

        color: const Color(0xFFF2F7F5),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: kBrandGreen.withValues(alpha: .08)),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(alpha: .045),

            blurRadius: 12,

            offset: const Offset(2, 4),

          ),

        ],

      ),

      child: Column(

        children: [

          const SizedBox(height: 12),

          _item(context, 'Dashboard', Icons.home_outlined, onDashboard),

          _item(context, 'Receive\nPayment', Icons.account_balance_wallet_outlined, onReceive),

          _item(context, 'Issue Qarza', Icons.handshake_outlined, onIssueQarza),

          _item(context, 'Reports', Icons.bar_chart_outlined, onReports),

          const Spacer(),

          _item(context, 'Settings', Icons.settings_outlined, onSettings),

          const SizedBox(height: 12),

        ],

      ),

    );

  }

  Widget _item(BuildContext context, String label, IconData icon, VoidCallback? onTap) {

    final active = selected == label;

    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),

      child: Material(

        color: active ? kBrandGreen.withValues(alpha: .12) : Colors.transparent,

        borderRadius: BorderRadius.circular(12),

        child: InkWell(

          onTap: onTap,

          borderRadius: BorderRadius.circular(12),

          child: SizedBox(

            height: 68,

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Container(

                  width: 34,

                  height: 34,

                  decoration: BoxDecoration(

                    color: active ? kBrandGreen : Colors.transparent,

                    borderRadius: BorderRadius.circular(10),

                  ),

                  child: Icon(

                    icon,

                    size: 19,

                    color: active ? Colors.white : kBrandGreen,

                  ),

                ),

                const SizedBox(height: 4),

                Text(

                  label,

                  textAlign: TextAlign.center,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(

                    fontSize: 9.5,

                    height: 1.05,

                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,

                    color: active ? kBrandGreen : Colors.black54,

                  ),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}
