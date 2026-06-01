// ============================================================
//  MORTGAGE CALCULATOR · Flutter / Material 3
//  Requires: shared_preferences (flutter pub add shared_preferences)
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MortgageApp());

// ══════════════════════════════════════════════════════════════
// 1. LOCALIZATION
// ══════════════════════════════════════════════════════════════

const _l = <String, Map<String, String>>{
  'en': {
    'app': 'Mortgage Calculator',
    'calc': 'Calculator', 'tbl': 'Schedule', 'pie': 'Summary',
    'bar': 'Timeline',    'rev': 'Reverse',
    'propVal': 'Property Value',
    'rate': 'Annual Rate (%)', 'loanAmt': 'Loan Amount', 'loanPct': 'LTV %',
    'yrs': 'Years', 'mo': 'Months',
    'fixedPmt': 'Fixed Monthly Fee',
    'fixed': 'Fixed',
    'fixedPmtInfo':
      'A fixed monthly fee is an additional recurring charge paid each month '
      'alongside your mortgage payment.\n\n'
      'Examples: life insurance, property insurance, account maintenance fees '
      'or other bank charges.\n\n'
      'This amount does NOT reduce your loan balance, but increases your total '
      'monthly outgoing and is included in the APR calculation.',
    'fixedTotal': 'Fixed Fees Total',
    'monthly': 'Base Monthly Payment', 'totalMonthly': 'Total Monthly (incl. fees)',
    'totalPd': 'Total Paid', 'totalInt': 'Total Interest',
    'totalCost': 'Total Cost (interest + fees)',
    'totalAll': 'Grand Total (incl. fees)',
    'withoutFixed': 'Without fixed fee', 'withFixed': 'Including fixed fee',
    'feePer': '/mo',
    'rpmnShort': 'APR', 'rpmnFull': 'Annual Percentage Rate',
    'rpmnInfo':
      'The APR represents the total annual cost of your loan as a percentage.\n\n'
      'Unlike the nominal rate, it includes all recurring fees, allowing fair '
      'comparison between loan offers.\n\nWith no fixed fees, APR = nominal rate.',
    'prin': 'Principal', 'int': 'Interest',
    'bal': 'Remaining Balance', 'cumP': 'Σ Principal', 'cumI': 'Σ Interest',
    'totalLbl': 'Total Paid',
    'payIn': 'Monthly Payment', 'payNo': 'Payment',
    'solveFor': 'Solve For', 'sRate': 'Interest Rate',
    'sDur': 'Duration',       'sLoan': 'Loan Amount',
    'calcBtn': 'Calculate', 'send': 'Send to Calculator', 'result': 'Result',
    'noData': 'Enter values in the Calculator tab to see results.',
    'errPos': 'Must be greater than zero',
    'errLoan': 'Loan exceeds property value',
    'errPayLow': 'Payment cannot cover the monthly interest',
    'errNone': 'No valid solution found',
    'rR': 'Interest Rate', 'dR': 'Duration', 'lR': 'Loan Amount',
    'totalPdR': 'Total Paid', 'totalIR': 'Total Interest',
    'save': 'Save', 'restore': 'Restore',
    'saved': 'Values saved ✓', 'restored': 'Values restored ✓',
    'tapHint': 'Tap a bar for details',
  },
  'sk': {
    'app': 'Hypotekárna Kalkulačka',
    'calc': 'Kalkulačka', 'tbl': 'Prehľad', 'pie': 'Súhrn',
    'bar': 'Priebeh',    'rev': 'Reverzný',
    'propVal': 'Hodnota Nehnuteľnosti',
    'rate': 'Ročná Sadzba (%)', 'loanAmt': 'Výška Hypotéky', 'loanPct': 'LTV %',
    'yrs': 'Roky', 'mo': 'Mesiace',
    'fixedPmt': 'Fixný mesačný poplatok',
    'fixed': 'Fixné',
    'fixedPmtInfo':
      'Fixný mesačný poplatok je dodatočný pravidelný poplatok platený každý '
      'mesiac spolu so splátkou hypotéky.\n\n'
      'Príklady: životné poistenie, poistenie nehnuteľnosti, poplatky za '
      'vedenie účtu alebo iné bankové poplatky.\n\n'
      'Táto suma NIE JE súčasťou splácania úveru, ale zvyšuje celkovú mesačnú '
      'platbu a ovplyvňuje RPMN.',
    'fixedTotal': 'Celkové fixné poplatky',
    'monthly': 'Základná mesačná splátka', 'totalMonthly': 'Celková mesačná platba',
    'totalPd': 'Celkovo zaplatené', 'totalInt': 'Celkové úroky',
    'totalCost': 'Celkové náklady (úroky + popl.)',
    'totalAll': 'Celkové náklady (vr. poplatkov)',
    'withoutFixed': 'Bez fixného poplatku', 'withFixed': 'Vrátane fixného poplatku',
    'feePer': '/mes',
    'rpmnShort': 'RPMN', 'rpmnFull': 'Ročná percentuálna miera nákladov',
    'rpmnInfo':
      'RPMN vyjadruje celkové ročné náklady na úver ako percento.\n\n'
      'Na rozdiel od nominálnej sadzby zahŕňa všetky poplatky, čo umožňuje '
      'porovnávať ponuky úverov za rovnakých podmienok.\n\n'
      'Bez fixných poplatkov sa RPMN rovná nominálnej sadzbe.',
    'prin': 'Istina', 'int': 'Úrok',
    'bal': 'Zostatok hypotéky', 'cumP': 'Σ Istina', 'cumI': 'Σ Úroky',
    'totalLbl': 'Spolu zaplatené',
    'payIn': 'Mesačná Splátka', 'payNo': 'Splátka',
    'solveFor': 'Vypočítať', 'sRate': 'Úrokovú Sadzbu',
    'sDur': 'Dobu Splácania', 'sLoan': 'Výšku Hypotéky',
    'calcBtn': 'Vypočítať', 'send': 'Poslať do Kalkulačky', 'result': 'Výsledok',
    'noData': 'Zadajte hodnoty v záložke Kalkulačka.',
    'errPos': 'Musí byť väčšie ako nula',
    'errLoan': 'Hypotéka presahuje hodnotu nehnuteľnosti',
    'errPayLow': 'Splátka nepokrýva mesačný úrok',
    'errNone': 'Riešenie sa nenašlo',
    'rR': 'Úroková Sadzba', 'dR': 'Doba Splácania', 'lR': 'Výška Hypotéky',
    'totalPdR': 'Celkovo Zaplatené', 'totalIR': 'Celkové Úroky',
    'save': 'Uložiť', 'restore': 'Obnoviť',
    'saved': 'Hodnoty uložené ✓', 'restored': 'Hodnoty obnovené ✓',
    'tapHint': 'Klepnutím na stĺpec zobrazíte detaily',
  },
};
String _s(String lc, String k) => _l[lc]?[k] ?? k;

// ══════════════════════════════════════════════════════════════
// 2. DATA MODEL
// ══════════════════════════════════════════════════════════════

class MonthlyEntry {
  final int    id;
  final double principalPmt, interestPmt, balance;
  final double cumPrincipal, cumInterest, cumTotal;
  const MonthlyEntry({
    required this.id,
    required this.principalPmt, required this.interestPmt, required this.balance,
    required this.cumPrincipal, required this.cumInterest, required this.cumTotal,
  });
}

class CalcResult {
  final double monthlyPayment, totalPaid, totalInterest, totalPrincipal;
  final List<MonthlyEntry> schedule;
  const CalcResult({
    required this.monthlyPayment, required this.totalPaid,
    required this.totalInterest,  required this.totalPrincipal,
    required this.schedule,
  });
}

// ══════════════════════════════════════════════════════════════
// 3. ENGINE
// ══════════════════════════════════════════════════════════════

class Engine {
  static double? payment({required double principal, required double annualPct, required int months}) {
    if (principal <= 0 || months <= 0) return null;
    if (annualPct <= 0) return principal / months;
    final r = annualPct / 1200.0, cpd = pow(1 + r, months).toDouble();
    final m = principal * r * cpd / (cpd - 1);
    return (m.isFinite && m > 0) ? m : null;
  }

  static CalcResult? calc({required double principal, required double annualPct, required int months}) {
    final m = payment(principal: principal, annualPct: annualPct, months: months);
    if (m == null) return null;
    final r = annualPct > 0 ? annualPct / 1200.0 : 0.0;
    double debt = principal, cumP = 0, cumI = 0, cumT = 0;
    final sched = <MonthlyEntry>[];
    for (var i = 1; i <= months; i++) {
      final iAmt = debt * r;
      final pAmt = (i == months) ? debt : m - iAmt;
      final iA   = (i == months) ? (m - pAmt).abs() : iAmt;
      debt -= pAmt; if (debt < 0.005) debt = 0;
      cumP += pAmt; cumI += iA; cumT += pAmt + iA;
      sched.add(MonthlyEntry(id: i, principalPmt: pAmt, interestPmt: iA, balance: debt,
          cumPrincipal: cumP, cumInterest: cumI, cumTotal: cumT));
    }
    return CalcResult(monthlyPayment: m, totalPaid: cumT,
        totalInterest: cumI, totalPrincipal: cumP, schedule: sched);
  }

  static double? revLoan({required double pmt, required double annualPct, required int months}) {
    if (pmt <= 0 || months <= 0) return null;
    if (annualPct <= 0) return pmt * months;
    final r = annualPct / 1200.0, cpd = pow(1 + r, months).toDouble();
    final v = pmt * (cpd - 1) / (r * cpd);
    return (v.isFinite && v > 0) ? v : null;
  }

  static int? revMonths({required double pmt, required double annualPct, required double principal}) {
    if (pmt <= 0 || principal <= 0) return null;
    if (annualPct <= 0) return (principal / pmt).ceil();
    final r = annualPct / 1200.0;
    if (pmt <= principal * r) return null;
    final n = -log(1 - principal * r / pmt) / log(1 + r);
    return (n.isFinite && n > 0) ? n.ceil() : null;
  }

  static double? revRate({required double pmt, required double principal, required int months}) {
    if (pmt <= 0 || principal <= 0 || months <= 0) return null;
    if (pmt < principal / months - 0.001) return null;
    if ((pmt - principal / months).abs() < 0.001) return 0.0;
    double lo = 0.0, hi = 100.0;
    for (var i = 0; i < 300; i++) {
      final mid = (lo + hi) / 2;
      final p = payment(principal: principal, annualPct: mid, months: months);
      if (p == null) { lo = mid; continue; }
      if ((p - pmt).abs() < 0.00005) return mid;
      (p < pmt) ? lo = mid : hi = mid;
    }
    final res = (lo + hi) / 2;
    return res.isFinite ? res : null;
  }
}

// ══════════════════════════════════════════════════════════════
// 4. UTILITIES
// ══════════════════════════════════════════════════════════════

String fmtC(double v, {int dec = 2}) {
  if (!v.isFinite) return '0.${'0' * dec}';
  final neg = v < 0, abs = v.abs(), ip = abs.truncate();
  final dp  = ((abs - ip) * pow(10, dec)).round().toString().padLeft(dec, '0');
  final s = ip.toString(); final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('\u2009');
    buf.write(s[i]);
  }
  return '${neg ? '-' : ''}$buf.$dp';
}

String fmtP(double v) => v.toStringAsFixed(2);
double? pd(String s) {
  if (s.trim().isEmpty) return null;
  return double.tryParse(s.replaceAll(',', '.').replaceAll(RegExp(r'[\s\u2009\u202F]'), ''));
}
int? pInt(String s) => s.trim().isEmpty ? null : int.tryParse(s.trim());

// ══════════════════════════════════════════════════════════════
// 5. DESIGN TOKENS
// ══════════════════════════════════════════════════════════════

const kBg    = Color(0xFFF8FAFC);
const kP     = Color(0xFF4F46E5);
const kP2    = Color(0xFF3730A3);
const kG     = Color(0xFF16A34A);   // principal — green
const kO     = Color(0xFFF97316);   // interest  — orange
const kFixed = Color(0xFF7C3AED);   // fixed fee — violet
const kE     = Color(0xFFDC2626);
const kTxt   = Color(0xFF0F172A);
const kSub   = Color(0xFF64748B);
const kBdr   = Color(0xFFE2E8F0);

const _kBreak = 600.0;
bool _wide(BuildContext ctx) => MediaQuery.of(ctx).size.width >= _kBreak;

ThemeData _theme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: kP).copyWith(primary: kP, secondary: kG, surface: kBg),
  scaffoldBackgroundColor: kBg,
  appBarTheme: const AppBarTheme(backgroundColor: kP, foregroundColor: Colors.white, elevation: 0),
  cardTheme: CardThemeData(color: Colors.white, elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: kBdr))),
  inputDecorationTheme: InputDecorationTheme(
    filled: true, fillColor: kBg,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBdr)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBdr)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kP, width: 2)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kE)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    errorStyle: const TextStyle(fontSize: 10, height: 1.2),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: kP, thumbColor: kP,
    inactiveTrackColor: kP.withOpacity(0.15),
    overlayColor: kP.withOpacity(0.1), trackHeight: 4,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
    backgroundColor: kP, foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), elevation: 0)),
);

// ══════════════════════════════════════════════════════════════
// 6. APP ROOT
// ══════════════════════════════════════════════════════════════

class MortgageApp extends StatefulWidget {
  const MortgageApp({super.key});
  @override State<MortgageApp> createState() => _MortgageAppState();
}
class _MortgageAppState extends State<MortgageApp> {
  String _lc = 'en';
  @override
  Widget build(BuildContext ctx) => MaterialApp(
    title: _s(_lc, 'app'), debugShowCheckedModeBanner: false, theme: _theme(),
    home: _Root(lc: _lc, onLc: (l) => setState(() => _lc = l)));
}

class _Xfer {
  final double? rate, amount; final int? months;
  const _Xfer({this.rate, this.amount, this.months});
}

class _Root extends StatefulWidget {
  final String lc; final ValueChanged<String> onLc;
  const _Root({required this.lc, required this.onLc});
  @override State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> with SingleTickerProviderStateMixin {
  late final _tc    = TabController(length: 5, vsync: this);
  final _calcKey    = GlobalKey<_CalcTabState>();
  CalcResult? _res;
  double      _fixedFee = 0;
  _Xfer?      _xfer;

  @override void dispose() { _tc.dispose(); super.dispose(); }
  String s(String k) => _s(widget.lc, k);

  void _save()    => _calcKey.currentState?._saveValues();
  void _restore() => _calcKey.currentState?._restoreValues();

  @override
  Widget build(BuildContext ctx) => Scaffold(
    backgroundColor: kBg,
    appBar: AppBar(
      toolbarHeight: 62,
      title: Text(s('app'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end, children: [
            _LangToggle(lc: widget.lc, onChanged: widget.onLc),
            const SizedBox(height: 4),
            Row(mainAxisSize: MainAxisSize.min, children: [
              _MiniBtn(Icons.save_outlined,            s('save'),    _save),
              const SizedBox(width: 5),
              _MiniBtn(Icons.settings_backup_restore,  s('restore'), _restore),
            ]),
          ]),
        ),
      ],
      bottom: TabBar(
        controller: _tc, isScrollable: true, tabAlignment: TabAlignment.start,
        labelColor: Colors.white, unselectedLabelColor: Colors.white60,
        indicatorColor: kO, indicatorWeight: 3, dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        tabs: [
          _tab(Icons.calculate_outlined,   s('calc')),
          _tab(Icons.table_rows_outlined,  s('tbl')),
          _tab(Icons.donut_large_outlined, s('pie')),
          _tab(Icons.bar_chart_outlined,   s('bar')),
          _tab(Icons.swap_horiz_outlined,  s('rev')),
        ],
      ),
    ),
    body: TabBarView(controller: _tc, children: [
      _CalcTab(key: _calcKey, lc: widget.lc,
        onResult: (r) => setState(() => _res = r),
        onFixed:  (f) => setState(() => _fixedFee = f),
        xfer: _xfer, onXferDone: () => setState(() => _xfer = null)),
      _TableTab(lc: widget.lc, result: _res, fixed: _fixedFee),
      _PieTab(lc: widget.lc,   result: _res, fixed: _fixedFee),
      _BarTab(lc: widget.lc,   result: _res, fixed: _fixedFee),
      _RevTab(lc: widget.lc, onSend: (x) { setState(() => _xfer = x); _tc.animateTo(0); }),
    ]),
  );

  Tab _tab(IconData icon, String text) =>
      Tab(icon: Icon(icon, size: 16), text: text, iconMargin: const EdgeInsets.only(bottom: 2));
}

// ── Compact language toggle ───────────────────────────────────
class _LangToggle extends StatelessWidget {
  final String lc; final ValueChanged<String> onChanged;
  const _LangToggle({required this.lc, required this.onChanged});
  @override
  Widget build(BuildContext ctx) => Row(mainAxisSize: MainAxisSize.min, children: [
    _pill('SK', lc == 'sk'), const SizedBox(width: 4), _pill('EN', lc == 'en'),
  ]);
  Widget _pill(String lang, bool active) => GestureDetector(
    onTap: () => onChanged(lang.toLowerCase()),
    child: AnimatedContainer(duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: active ? kO : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6)),
      child: Text(lang, style: TextStyle(
        color: active ? kP2 : Colors.white,
        fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5))));
}

// ── Save/Restore mini button  (BUG FIX: no const on BoxDecoration) ──────────
class _MiniBtn extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _MiniBtn(this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(   // no const — withOpacity is a runtime call
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: Colors.white.withOpacity(0.80)),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(
            color: Colors.white.withOpacity(0.80), fontSize: 10, fontWeight: FontWeight.w500)),
      ]),
    ),
  );
}

// ══════════════════════════════════════════════════════════════
// 7. CALCULATOR TAB
// ══════════════════════════════════════════════════════════════

const _kPrefProp = 'prop', _kPrefRate = 'rate', _kPrefLoan = 'loan',
      _kPrefMo = 'mo', _kPrefFixed = 'fixed', _kPrefHasSaved = 'hasSaved';

class _CalcTab extends StatefulWidget {
  final String lc;
  final ValueChanged<CalcResult?> onResult;
  final ValueChanged<double>       onFixed;
  final _Xfer? xfer;
  final VoidCallback onXferDone;
  const _CalcTab({super.key, required this.lc, required this.onResult,
    required this.onFixed, this.xfer, required this.onXferDone});
  @override State<_CalcTab> createState() => _CalcTabState();
}

class _CalcTabState extends State<_CalcTab> {
  final _pC = TextEditingController(text: '100000');
  final _rC = TextEditingController(text: '1.59');
  final _lC = TextEditingController(text: '90000');
  final _lpC= TextEditingController(text: '90.00');
  final _yC = TextEditingController(text: '20');
  final _mC = TextEditingController(text: '240');
  final _fC = TextEditingController(text: '0.00');

  double _prop = 100000, _rate = 1.59, _loan = 90000, _fixed = 0.0;
  int    _mo   = 240;
  bool   _sL = false, _sT = false;
  CalcResult? _res;
  double?     _rpmn;
  String?     _loanErr;

  @override void initState() { super.initState(); _loadSaved(); }
  @override void dispose() {
    for (final c in [_pC,_rC,_lC,_lpC,_yC,_mC,_fC]) c.dispose(); super.dispose();
  }

  @override
  void didUpdateWidget(_CalcTab old) {
    super.didUpdateWidget(old);
    final x = widget.xfer; if (x == null) return;
    if (x.rate   != null) { _rate = x.rate!;  _rC.text = fmtP(_rate); }
    if (x.amount != null) { _loan = x.amount!; _lC.text='${_loan.round()}'; _syncPct(); }
    if (x.months != null) { _mo   = x.months!; _mC.text='$_mo'; _syncYrs(); }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { widget.onXferDone(); _run(); }
    });
  }

  String s(String k) => _s(widget.lc, k);

  Future<void> _loadSaved() async {
    final p = await SharedPreferences.getInstance();
    if (p.getBool(_kPrefHasSaved) == true) {
      _prop  = p.getDouble(_kPrefProp)  ?? 100000;
      _rate  = p.getDouble(_kPrefRate)  ?? 1.59;
      _loan  = p.getDouble(_kPrefLoan)  ?? 90000;
      _mo    = p.getInt(_kPrefMo)       ?? 240;
      _fixed = p.getDouble(_kPrefFixed) ?? 0.0;
      _pC.text='${_prop.round()}'; _rC.text=fmtP(_rate);
      _lC.text='${_loan.round()}'; _mC.text='$_mo'; _fC.text=fmtP(_fixed);
      _syncPct(); _syncYrs();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _run(); });
  }

  Future<void> _saveValues() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kPrefHasSaved, true);
    await p.setDouble(_kPrefProp,  _prop);
    await p.setDouble(_kPrefRate,  _rate);
    await p.setDouble(_kPrefLoan,  _loan);
    await p.setInt   (_kPrefMo,    _mo);
    await p.setDouble(_kPrefFixed, _fixed);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s('saved')), duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating));
  }

  Future<void> _restoreValues() async {
    final p = await SharedPreferences.getInstance();
    if (p.getBool(_kPrefHasSaved) != true) return;
    setState(() {
      _prop  = p.getDouble(_kPrefProp)  ?? 100000;
      _rate  = p.getDouble(_kPrefRate)  ?? 1.59;
      _loan  = p.getDouble(_kPrefLoan)  ?? 90000;
      _mo    = p.getInt(_kPrefMo)       ?? 240;
      _fixed = p.getDouble(_kPrefFixed) ?? 0.0;
      _pC.text='${_prop.round()}'; _rC.text=fmtP(_rate);
      _lC.text='${_loan.round()}'; _mC.text='$_mo'; _fC.text=fmtP(_fixed);
    });
    _syncPct(); _syncYrs(); _run();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s('restored')), duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating));
  }

  void _syncPct() {
    if (_sL) return; _sL = true;
    _lpC.text = _prop > 0 ? fmtP((_loan / _prop * 100).clamp(0.0, 999.0)) : '0.00';
    _sL = false;
  }
  void _fromPct(double pct) {
    if (_sL) return; _sL = true;
    _loan = _prop * pct / 100; _lC.text = '${_loan.round()}'; _sL = false;
  }
  void _syncYrs() { if (_sT) return; _sT=true; _yC.text='${_mo~/12}'; _sT=false; }
  void _fromYrs(int y) { if (_sT) return; _sT=true; _mo=y*12; _mC.text='$_mo'; _sT=false; }

  void _run() {
    _loanErr = (_loan > _prop && _prop > 0) ? s('errLoan') : null;
    final r  = Engine.calc(principal: _loan, annualPct: _rate, months: _mo);
    double? rpmn;
    if (r != null) {
      rpmn = _fixed > 0
          ? (Engine.revRate(pmt: r.monthlyPayment + _fixed, principal: _loan, months: _mo) ?? _rate)
          : _rate;
    }
    setState(() { _res = r; _rpmn = rpmn; });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { widget.onResult(r); widget.onFixed(_fixed); }
    });
  }

  void _showInfo(BuildContext bCtx, String title, String body) => showDialog(
    context: bCtx,
    builder: (dCtx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: SingleChildScrollView(child: Text(body, style: const TextStyle(fontSize: 14, height: 1.5))),
      actions: [TextButton(onPressed: () => Navigator.of(dCtx).pop(), child: const Text('OK'))],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))));

  @override
  Widget build(BuildContext ctx) => LayoutBuilder(builder: (ctx, con) {
    final wide = con.maxWidth >= _kBreak;
    final cards = _inputCards();
    final result = _res != null
        ? _ResultCard(lc: widget.lc, res: _res!, fixed: _fixed,
            rpmn: _rpmn ?? _rate, principal: _loan,
            onRpmnInfo: (bCtx) => _showInfo(bCtx, s('rpmnShort'), s('rpmnInfo')))
        : null;

    if (!wide) {
      return ListView(primary: false, padding: const EdgeInsets.fromLTRB(12,8,12,32),
        children: [...cards, if (result != null) result]);
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 3,
        child: ListView(primary: false, padding: const EdgeInsets.fromLTRB(16,8,8,32), children: cards)),
      Container(width: 1, color: kBdr),
      Expanded(flex: 2,
        child: result != null
          ? SingleChildScrollView(primary: false, padding: const EdgeInsets.fromLTRB(8,16,16,32),
              child: result)
          : _Empty(s('noData'))),
    ]);
  });

  List<Widget> _inputCards() => [
    _card(s('propVal'), Icons.home_outlined, [
      _fRow(_pC, null,
        onVal: (v) { _prop=v??0; _syncPct(); _run(); },
        onM: () { _prop=(_prop-1000).clamp(1,10e6); _pC.text='${_prop.round()}'; _syncPct(); _run(); },
        onP: () { _prop+=1000; _pC.text='${_prop.round()}'; _syncPct(); _run(); }),
      _sl(_prop.clamp(0,1e6), 0, 1e6, 1000,
        (v) { _prop=(v/1000).round()*1000; _pC.text='${_prop.round()}'; _syncPct(); _run(); }),
    ]),
    _card(s('rate'), Icons.percent_outlined, [
      _fRow(_rC, '%', decimal: true,
        onVal: (v) { _rate=v??_rate; _run(); },
        onM: () { _rate=(_rate-0.01).clamp(0.01,50); _rC.text=fmtP(_rate); _run(); },
        onP: () { _rate=(_rate+0.01).clamp(0.01,50); _rC.text=fmtP(_rate); _run(); }),
      _sl(_rate.clamp(0.01,20), 0.01, 20, 1999,
        (v) { _rate=(v*100).round()/100; _rC.text=fmtP(_rate); _run(); }),
    ]),
    _card(s('loanAmt'), Icons.account_balance_outlined, [
      _fRow(_lC, null, error: _loanErr,
        onVal: (v) { _loan=v??0; _syncPct(); _run(); },
        onM: () { _loan=(_loan-1000).clamp(0,10e6); _lC.text='${_loan.round()}'; _syncPct(); _run(); },
        onP: () { _loan+=1000; _lC.text='${_loan.round()}'; _syncPct(); _run(); }),
      _sl(_loan.clamp(0,1e6), 0, 1e6, 1000,
        (v) { _loan=(v/1000).round()*1000; _lC.text='${_loan.round()}'; _syncPct(); _run(); }),
      const SizedBox(height: 4),
      Row(children: [
        SizedBox(width: 100, child: _Fld(ctrl: _lpC, suffix: '%', decimal: true,
          onVal: (v) { if (v!=null&&!_sL) { _fromPct(v.clamp(0,999)); _run(); } })),
        const SizedBox(width: 6),
        _Btn(Icons.remove, () { final p=(pd(_lpC.text)??90)-1; _lpC.text=fmtP(p.clamp(0,200)); _fromPct(p.clamp(0,200)); _run(); }, size: 32),
        const SizedBox(width: 4),
        _Btn(Icons.add,    () { final p=(pd(_lpC.text)??90)+1; _lpC.text=fmtP(p.clamp(0,200)); _fromPct(p.clamp(0,200)); _run(); }, size: 32),
        const SizedBox(width: 8),
        Text(s('loanPct'), style: const TextStyle(fontSize: 12, color: kSub)),
      ]),
    ]),
    _card('${s('yrs')} / ${s('mo')}', Icons.schedule_outlined, [
      Row(children: [
        Expanded(child: _dCol(s('yrs'), _yC,
          onM: () { final y=((pInt(_yC.text)??20)-1).clamp(1,50); _yC.text='$y'; _fromYrs(y); _run(); },
          onP: () { final y=((pInt(_yC.text)??20)+1).clamp(1,50); _yC.text='$y'; _fromYrs(y); _run(); },
          onVal: (v) { if(v!=null) { _fromYrs(v.toInt()); _run(); } })),
        const SizedBox(width: 12),
        Expanded(child: _dCol(s('mo'), _mC,
          onM: () { _mo=(_mo-1).clamp(1,600); _mC.text='$_mo'; _syncYrs(); _run(); },
          onP: () { _mo=(_mo+1).clamp(1,600); _mC.text='$_mo'; _syncYrs(); _run(); },
          onVal: (v) { _mo=v?.toInt()??_mo; _syncYrs(); _run(); })),
      ]),
      _sl((_mo/12).clamp(1,50), 1, 50, 49,
        (v) { final y=v.round(); _yC.text='$y'; _fromYrs(y); _run(); }),
    ]),
    _card(s('fixedPmt'), Icons.receipt_long_outlined, [
      _fRow(_fC, null, decimal: true,
        onVal: (v) { _fixed=(v??0).clamp(0,double.infinity); _run(); },
        onM: () { _fixed=(_fixed-5).clamp(0,10000); _fC.text=fmtP(_fixed); _run(); },
        onP: () { _fixed=(_fixed+5).clamp(0,10000); _fC.text=fmtP(_fixed); _run(); }),
      _sl(_fixed.clamp(0,500), 0, 500, 100,
        (v) { _fixed=(v/5).round()*5; _fC.text=fmtP(_fixed); _run(); }),
    ], infoTitle: s('fixedPmt'), infoBody: s('fixedPmtInfo')),
  ];

  Widget _card(String label, IconData icon, List<Widget> children,
      {String? infoTitle, String? infoBody}) =>
    Card(margin: const EdgeInsets.only(bottom: 10),
      child: Padding(padding: const EdgeInsets.fromLTRB(14,12,14,8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 15, color: kP), const SizedBox(width: 6),
            Expanded(child: Text(label, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kP, letterSpacing: 0.3))),
            if (infoBody != null)
              Builder(builder: (bCtx) => GestureDetector(
                onTap: () => _showInfo(bCtx, infoTitle ?? label, infoBody),
                child: Container(padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.info_outline_rounded, size: 17, color: kSub)))),
          ]),
          const SizedBox(height: 10),
          ...children,
        ])));

  Widget _fRow(TextEditingController ctrl, String? suffix, {
    String? error, bool decimal = false,
    required ValueChanged<double?> onVal, required VoidCallback onM, required VoidCallback onP,
  }) => Row(children: [
    Expanded(child: _Fld(ctrl: ctrl, suffix: suffix, error: error, decimal: decimal, onVal: onVal)),
    const SizedBox(width: 8),
    _Btn(Icons.remove, onM), const SizedBox(width: 4), _Btn(Icons.add, onP),
  ]);

  Widget _sl(double val, double min, double max, int? div, ValueChanged<double> cb) =>
      SizedBox(height: 32, child: Slider(value: val, min: min, max: max, divisions: div, onChanged: cb));

  Widget _dCol(String label, TextEditingController ctrl, {
    required VoidCallback onM, required VoidCallback onP, required ValueChanged<double?> onVal,
  }) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 11, color: kSub)), const SizedBox(height: 4),
    Row(children: [
      Expanded(child: _Fld(ctrl: ctrl, integer: true, onVal: onVal)),
      const SizedBox(width: 4),
      _Btn(Icons.remove, onM, size: 34), const SizedBox(width: 3), _Btn(Icons.add, onP, size: 34),
    ]),
  ]);
}

// ══════════════════════════════════════════════════════════════
// 8. RESULT CARD
// ══════════════════════════════════════════════════════════════

class _ResultCard extends StatelessWidget {
  final String lc; final CalcResult res;
  final double fixed, rpmn, principal;
  final void Function(BuildContext) onRpmnInfo;
  const _ResultCard({required this.lc, required this.res,
    required this.fixed, required this.rpmn, required this.principal,
    required this.onRpmnInfo});
  String s(String k) => _s(lc, k);

  @override
  Widget build(BuildContext ctx) {
    final months      = res.schedule.length;
    final totalMo     = res.monthlyPayment + fixed;
    final totalWithFee = totalMo * months;
    final costWithFee  = totalWithFee - principal;
    final prinRatio    = (res.totalPrincipal / res.totalPaid).clamp(0.0, 1.0);
    final hasFixed     = fixed > 0.001;

    return Card(margin: const EdgeInsets.only(bottom: 10), clipBehavior: Clip.hardEdge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(color: kP,
          padding: EdgeInsets.fromLTRB(16, 18, 16, hasFixed ? 10 : 18),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s('monthly'), style: TextStyle(
                  color: Colors.white.withOpacity(0.75), fontSize: 11, letterSpacing: 0.3)),
              const SizedBox(height: 4),
              Text(fmtC(res.monthlyPayment), style: const TextStyle(
                  color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -1)),
            ])),
            const SizedBox(width: 12),
            Builder(builder: (bCtx) => GestureDetector(
              onTap: () => onRpmnInfo(bCtx),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(color: kP2, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.15))),
                child: SizedBox(width: 112, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(child: Text(s('rpmnShort'), overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white.withOpacity(0.75),
                          fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3))),
                    const SizedBox(width: 4),
                    Icon(Icons.info_outline_rounded, size: 13, color: Colors.white.withOpacity(0.5)),
                  ]),
                  const SizedBox(height: 3),
                  Text('${fmtP(rpmn)} %', style: const TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(s('rpmnFull'), textAlign: TextAlign.center,
                    maxLines: 3, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 9, height: 1.3)),
                ])),
              ))),
          ])),
        if (hasFixed)
          Container(color: kP2,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(children: [
              Icon(Icons.add_circle_outline, size: 14, color: Colors.white.withOpacity(0.6)),
              const SizedBox(width: 6),
              Flexible(flex: 2, child: Text('+${fmtC(fixed)}${s('feePer')}  →',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12))),
              const SizedBox(width: 6),
              Flexible(flex: 3, child: Text('${fmtC(totalMo)}  ${s('totalMonthly')}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700))),
            ])),
        Padding(padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (hasFixed) _chip(s('withoutFixed'), kG),
            if (hasFixed) const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _StatTile(s('totalPd'),  fmtC(res.totalPaid),     kP)),
              const SizedBox(width: 10),
              Expanded(child: _StatTile(s('totalInt'), fmtC(res.totalInterest), kO)),
            ]),
            if (hasFixed) ...[
              const SizedBox(height: 12),
              Container(height: 1, color: kBdr), const SizedBox(height: 12),
              _chip('${s('withFixed')} +${fmtC(fixed)}${s('feePer')}', kO),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _StatTile(s('totalPd'),   fmtC(totalWithFee), kP2)),
                const SizedBox(width: 10),
                Expanded(child: _StatTile(s('totalCost'), fmtC(costWithFee),  kO)),
              ]),
            ],
            const SizedBox(height: 14),
            Container(height: 1, color: kBdr), const SizedBox(height: 10),
            ClipRRect(borderRadius: BorderRadius.circular(6),
              child: Stack(children: [
                Container(height: 10, color: kO.withOpacity(0.2)),
                FractionallySizedBox(widthFactor: prinRatio,
                  child: Container(height: 10, color: kG)),
              ])),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _dotLbl(kG, '${s('prin')} ${(prinRatio*100).toStringAsFixed(1)}%'),
              _dotLbl(kO, '${s('int')} ${((1-prinRatio)*100).toStringAsFixed(1)}%'),
            ]),
          ])),
      ]));
  }

  Widget _chip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.25))),
    child: Text(label, overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)));

  Widget _dotLbl(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
    const SizedBox(width: 4),
    Flexible(child: Text(t, overflow: TextOverflow.ellipsis,
      style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600))),
  ]);
}

class _StatTile extends StatelessWidget {
  final String label, value; final Color color;
  const _StatTile(this.label, this.value, this.color);
  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.15))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, overflow: TextOverflow.ellipsis, maxLines: 2,
        style: TextStyle(fontSize: 10, color: color.withOpacity(0.8), fontWeight: FontWeight.w600)),
      const SizedBox(height: 3),
      Text(value, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w800)),
    ]));
}

// ══════════════════════════════════════════════════════════════
// 9. TABLE TAB  — new Fixed column when fee > 0
// ══════════════════════════════════════════════════════════════

class _TableTab extends StatelessWidget {
  final String lc; final CalcResult? result; final double fixed;
  const _TableTab({required this.lc, this.result, required this.fixed});

  @override
  Widget build(BuildContext ctx) {
    if (result == null) return _Empty(_s(lc, 'noData'));
    final showFixed = fixed > 0.001;
    // Column widths: #, Principal, Interest, [Fixed], Balance, ΣPrin, ΣInt
    final cw = showFixed
        ? [28.0, 70.0, 62.0, 58.0, 78.0, 72.0, 68.0]
        : [32.0, 80.0, 72.0, 88.0, 88.0, 80.0];
    final hdrs = [
      '#', _s(lc,'prin'), _s(lc,'int'),
      if (showFixed) _s(lc,'fixed'),
      _s(lc,'bal'), _s(lc,'cumP'), _s(lc,'cumI'),
    ];

    return LayoutBuilder(builder: (ctx, con) {
      final total = cw.fold(0.0, (a, b) => a + b) + 16;
      final scale = con.maxWidth >= total ? con.maxWidth / total : 1.0;
      final cwS   = cw.map((w) => w * scale).toList();
      final tableW= con.maxWidth >= total ? con.maxWidth : total;

      Widget buildTable() => Column(children: [
        Container(color: kP, height: 40, padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(children: List.generate(hdrs.length, (i) => SizedBox(width: cwS[i],
            child: Text(hdrs[i], textAlign: TextAlign.right, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))))),
        Expanded(child: ListView.builder(
          itemCount: result!.schedule.length,
          itemBuilder: (ctx, i) {
            final e = result!.schedule[i];
            final cols = [
              '${e.id}', fmtC(e.principalPmt), fmtC(e.interestPmt),
              if (showFixed) fmtC(fixed),
              fmtC(e.balance), fmtC(e.cumPrincipal), fmtC(e.cumInterest),
            ];
            final colors = [
              null, null, kO,
              if (showFixed) kFixed,
              null, null, kO,
            ];
            return Container(
              color: i.isOdd ? kP.withOpacity(0.04) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(children: List.generate(cols.length, (j) =>
                _Td(cols[j], cwS[j], color: colors[j]))));
          })),
      ]);

      if (con.maxWidth >= total) return buildTable();
      return SingleChildScrollView(scrollDirection: Axis.horizontal,
        child: SizedBox(width: tableW, height: con.maxHeight, child: buildTable()));
    });
  }
}

class _Td extends StatelessWidget {
  final String t; final double w; final Color? color;
  const _Td(this.t, this.w, {this.color});
  @override
  Widget build(BuildContext ctx) => SizedBox(width: w,
    child: Text(t, textAlign: TextAlign.right, overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color ?? kTxt, fontSize: 11, fontWeight: FontWeight.w500)));
}

// ══════════════════════════════════════════════════════════════
// 10. PIE CHART TAB  — 3 segments including fixed fees total
// ══════════════════════════════════════════════════════════════

class _PieTab extends StatelessWidget {
  final String lc; final CalcResult? result; final double fixed;
  const _PieTab({required this.lc, this.result, required this.fixed});
  String s(String k) => _s(lc, k);

  @override
  Widget build(BuildContext ctx) {
    if (result == null) return _Empty(s('noData'));
    final months     = result!.schedule.length;
    final totalFixed = fixed * months;
    final prin       = result!.totalPrincipal;
    final intr       = result!.totalInterest;
    final totalAll   = result!.totalPaid + totalFixed;
    final hasFixed   = fixed > 0.001;
    final prR  = prin / totalAll;
    final intR = intr / totalAll;
    final fixR = totalFixed / totalAll;

    return ListView(primary: false, padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        Text(hasFixed ? s('totalAll') : s('totalLbl'),
          style: const TextStyle(fontSize: 12, color: kSub, letterSpacing: 0.3)),
        const SizedBox(height: 4),
        Text(fmtC(totalAll),
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: kTxt)),
        const SizedBox(height: 20),
        SizedBox(height: _wide(ctx) ? 260 : 200,
          child: CustomPaint(
            painter: _PiePainter(prR: prR, intR: intR, fixR: fixR),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('${(prR*100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kP)),
              Text(s('prin'), style: const TextStyle(fontSize: 11, color: kSub)),
            ])))),
        const SizedBox(height: 20),
        Wrap(alignment: WrapAlignment.center, spacing: 20, runSpacing: 10, children: [
          _LegDot(kG, s('prin'), fmtC(prin)),
          _LegDot(kO, s('int'),  fmtC(intr)),
          if (hasFixed) _LegDot(kFixed, s('fixedTotal'), fmtC(totalFixed)),
        ]),
      ]))),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _StatTile(s('monthly'),  fmtC(result!.monthlyPayment), kP)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(s('totalInt'), fmtC(intr), kO)),
        if (hasFixed) ...[
          const SizedBox(width: 10),
          Expanded(child: _StatTile(s('fixedTotal'), fmtC(totalFixed), kFixed)),
        ],
      ]),
    ]);
  }
}

/// Donut painter — 3 segments: principal (green), interest (orange), fixed fees (violet).
class _PiePainter extends CustomPainter {
  final double prR, intR, fixR;
  const _PiePainter({required this.prR, required this.intR, required this.fixR});
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width/2, cy = size.height/2;
    final r  = size.shortestSide/2*0.9, ir = r*0.55;
    final rect  = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final start = -pi / 2;
    final s1 = prR  * 2 * pi;
    final s2 = intR * 2 * pi;
    final s3 = fixR * 2 * pi;
    if (s1 > 0.001) canvas.drawArc(rect, start,       s1, true, Paint()..color=kG..style=PaintingStyle.fill);
    if (s2 > 0.001) canvas.drawArc(rect, start+s1,    s2, true, Paint()..color=kO..style=PaintingStyle.fill);
    if (s3 > 0.001) canvas.drawArc(rect, start+s1+s2, s3, true, Paint()..color=kFixed..style=PaintingStyle.fill);
    canvas.drawCircle(Offset(cx,cy), r,  Paint()..color=Colors.white..strokeWidth=3..style=PaintingStyle.stroke);
    canvas.drawCircle(Offset(cx,cy), ir, Paint()..color=Colors.white..style=PaintingStyle.fill);
  }
  @override bool shouldRepaint(_PiePainter o) =>
      o.prR != prR || o.intR != intR || o.fixR != fixR;
}

class _LegDot extends StatelessWidget {
  final Color color; final String label, value;
  const _LegDot(this.color, this.label, this.value);
  @override
  Widget build(BuildContext ctx) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 11, height: 11, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    const SizedBox(width: 6),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: kSub)),
      if (value.isNotEmpty)
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kTxt)),
    ]),
  ]);
}

// ══════════════════════════════════════════════════════════════
// 11. BAR CHART TAB — fit to window, 3 segments, interactive tap
// ══════════════════════════════════════════════════════════════

class _BarTab extends StatefulWidget {
  final String lc; final CalcResult? result; final double fixed;
  const _BarTab({required this.lc, this.result, required this.fixed});
  @override State<_BarTab> createState() => _BarTabState();
}

class _BarTabState extends State<_BarTab> {
  int?    _sel;     // selected month index (0-based)
  String s(String k) => _s(widget.lc, k);

  int _labelStep(int years) {
    if (years <= 5)  return 1;
    if (years <= 10) return 2;
    if (years <= 20) return 5;
    return 10;
  }

  @override
  Widget build(BuildContext ctx) {
    if (widget.result == null) return _Empty(s('noData'));
    final sched  = widget.result!.schedule;
    final maxPmt = widget.result!.monthlyPayment + widget.fixed;
    final n      = sched.length;
    final years  = (n / 12).ceil();
    final step   = _labelStep(years);
    final hasFixed = widget.fixed > 0.001;

    return Column(children: [
      // ── Legend ──────────────────────────────────────────────
      Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Wrap(alignment: WrapAlignment.center, spacing: 16, runSpacing: 4, children: [
          _LegDot(kG, s('prin'), ''),
          _LegDot(kO, s('int'), ''),
          if (hasFixed) _LegDot(kFixed, s('fixed'), ''),
        ])),

// ── Chart fills all available space — no horizontal scroll ─
      Expanded(child: LayoutBuilder(builder: (ctx, con) {
        final chartW = con.maxWidth;
        final bw     = chartW / n;
        
        // Lokálna referencia na overlay, aby sme ho vedeli zavrieť odkiaľkoľvek
        OverlayEntry? localOverlay;

        return GestureDetector(
          onTapDown: (d) {
            final idx = (d.localPosition.dx / bw).floor().clamp(0, n - 1);
            
            // 1. Ak už nejaká bublina svieti, zavrieme ju
            if (localOverlay != null) {
              localOverlay!.remove();
              localOverlay = null;
              setState(() => _sel = null);
              return;
            }

            setState(() => _sel = idx);

            // 2. Prepočet pozície kliku na globálne súradnice
            final renderBox = ctx.findRenderObject() as RenderBox;
            final globalOffset = renderBox.localToGlobal(d.localPosition);


            // 3. Vytvorenie overlay prvku (neovplyvňuje widgety pod ním)
            localOverlay = OverlayEntry(
              builder: (overlayCtx) => GestureDetector(
                // Ak klikne používateľ mimo bubliny, zavrie sa
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  localOverlay?.remove();
                  localOverlay = null;
                  setState(() => _sel = null);
                },
                child: Stack(
                  children: [
                    Positioned(
                      // .clamp nepustí bublinu mimo obrazovky vľavo (min 12px) ani vpravo (max šírka displeja - 332px)
                      left: (globalOffset.dx - 160).clamp(12.0, (MediaQuery.of(ctx).size.width - 332).clamp(12.0, double.infinity)),
                      top: globalOffset.dy - 110,  
                      width: 320,                  
                      child: GestureDetector(
                        onTap: () {}, 
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 6, 12), 
                            child: _MonthDetail(
                              lc: widget.lc,
                              entry: sched[idx],
                              fixed: widget.fixed,
                              onClose: () {
                                localOverlay?.remove();
                                localOverlay = null;
                                setState(() => _sel = null);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            // 4. Vloženie do globálneho Overlay systému
            Overlay.of(ctx).insert(localOverlay!);
          },
          child: CustomPaint(
            size: Size(chartW, con.maxHeight),
            painter: _BarPainter(
              schedule: sched, maxPayment: maxPmt,
              fixed: widget.fixed, selectedIdx: _sel),
          ),
        );
      })),

      // ── Year labels ──────────────────────────────────────────
      SizedBox(height: 18,
        child: LayoutBuilder(builder: (ctx, con) {
          final yearPx = con.maxWidth / years;
          return Stack(children: [
            for (var y = step; y <= years; y += step)
              Positioned(
                left: (y * yearPx - 20).clamp(0.0, con.maxWidth - 40),
                child: SizedBox(width: 40,
                  child: Text('$y', textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 9, color: kSub)))),
          ]);
        })),

      // ── STARÝ DETAIL (ClipRect a AnimatedContainer) BOL ODSTRÁNENÝ ──

      // Tap hint (shown only when no selection)
      SizedBox(
        height: 22, // Zafixuje priestor pod grafom, aby sa nenaťahoval
        child: _sel == null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(s('tapHint'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: kSub)),
              )
            : const SizedBox.shrink(), // Ak je vybrané, miesto zostane prázdne, ale zachová si výšku
      ),
    ]);
  }
}

/// Stacked bar painter: green (principal) · orange (interest) · violet (fixed fee).
/// Highlights the selected bar with a translucent overlay.
class _BarPainter extends CustomPainter {
  final List<MonthlyEntry> schedule;
  final double maxPayment, fixed;
  final int?   selectedIdx;
  _BarPainter({required this.schedule, required this.maxPayment,
    required this.fixed, this.selectedIdx});

  @override
  void paint(Canvas canvas, Size size) {
    if (schedule.isEmpty || maxPayment <= 0) return;
    final n  = schedule.length;
    final bw = size.width / n;          // bar slot width
    final ch = size.height - 2;         // chart height (tiny bottom margin)
    final selPaint = Paint()..color = kP.withOpacity(0.12);

    // Axis line
    canvas.drawLine(Offset(0, ch), Offset(size.width, ch),
      Paint()..color = kBdr..strokeWidth = 1);

    for (var i = 0; i < n; i++) {
      final e  = schedule[i];
      final x  = i * bw;
      // Use full bw for dense charts, leave a small gap for sparse ones
      final bwActual = bw > 4 ? bw * 0.80 : bw;

      // Highlight selected bar
      if (i == selectedIdx) {
        canvas.drawRect(Rect.fromLTWH(x, 0, bw, ch), selPaint);
      }

      final pH = (e.principalPmt / maxPayment * ch).clamp(0.0, ch);
      final iH = (e.interestPmt  / maxPayment * ch).clamp(0.0, ch - pH);
      final fH = fixed > 0 ? (fixed / maxPayment * ch).clamp(0.0, ch - pH - iH) : 0.0;

      // Draw stacked segments bottom→top
      canvas.drawRect(Rect.fromLTWH(x, ch - pH, bwActual, pH),
        Paint()..color = (i == selectedIdx) ? kG : kG.withOpacity(0.9));
      canvas.drawRect(Rect.fromLTWH(x, ch - pH - iH, bwActual, iH),
        Paint()..color = (i == selectedIdx) ? kO : kO.withOpacity(0.9));
      if (fH > 0.5) {
        canvas.drawRect(Rect.fromLTWH(x, ch - pH - iH - fH, bwActual, fH),
          Paint()..color = kFixed.withOpacity(0.85));
      }

      // Year dividers every 12 months
      if ((i + 1) % 12 == 0 && i < n - 1) {
        canvas.drawLine(Offset(x + bw, 0), Offset(x + bw, ch),
          Paint()..color = kBdr..strokeWidth = 0.6);
      }
    }
  }

  @override bool shouldRepaint(_BarPainter o) =>
    o.schedule.length != schedule.length ||
    o.selectedIdx != selectedIdx ||
    o.fixed != fixed;
}

/// Detail panel shown when a bar is tapped.
class _MonthDetail extends StatelessWidget {
  final String lc; final MonthlyEntry entry; final double fixed;
  final VoidCallback onClose;
  const _MonthDetail({required this.lc, required this.entry,
    required this.fixed, required this.onClose});
  String s(String k) => _s(lc, k);

  @override
  Widget build(BuildContext ctx) {
    final mo  = entry.id;
    final yr  = (mo - 1) ~/ 12 + 1;
    final m   = (mo - 1) % 12 + 1;
    return Container(
      color: kP.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${s('payNo')} $mo  (${s('yrs')} $yr / ${s('mo')} $m)',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kP)),
          const SizedBox(height: 6),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: _det(kG, s('prin'), fmtC(entry.principalPmt))),
              const SizedBox(width: 12),
              Expanded(child: _det(kO, s('int'), fmtC(entry.interestPmt))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              if (fixed > 0.001) ...[
                Expanded(child: _det(kFixed, s('fixed'), fmtC(fixed))),
                const SizedBox(width: 12),
              ],
              Expanded(child: _det(kSub, s('bal'), fmtC(entry.balance))),
              if (fixed <= 0.001) const Expanded(child: SizedBox.shrink()),
            ]),
          ]),
        ])),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, size: 16, color: kSub),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
      ]));
  }

  Widget _det(Color c, String label, String val) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 9, color: c, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
        Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kTxt)),
      ]);
} // Táto zatvorka uzatvára celú vašu triedu, nemeňte ju

// ══════════════════════════════════════════════════════════════
// 12. REVERSE TAB  (unchanged structure)
// ══════════════════════════════════════════════════════════════

enum _Solve { rate, duration, loan }

class _RevTab extends StatefulWidget {
  final String lc; final ValueChanged<_Xfer> onSend;
  const _RevTab({required this.lc, required this.onSend});
  @override State<_RevTab> createState() => _RevTabState();
}

class _RevTabState extends State<_RevTab> {
  _Solve _solve = _Solve.loan;
  final _pmtC  = TextEditingController(text: '500.00');
  final _rateC = TextEditingController(text: '1.59');
  final _yC    = TextEditingController(text: '20');
  final _mC    = TextEditingController(text: '240');
  final _lC    = TextEditingController(text: '90000');

  double _pmt = 500.0, _rate = 1.59, _loan = 90000.0;
  int    _mo  = 240;
  bool   _sT  = false;

  double? _resRate, _resLoan; int? _resMo;
  double? _resTotalPd, _resTotalInt;
  String? _err; bool _hasResult = false;

  @override void dispose() {
    for (final c in [_pmtC,_rateC,_yC,_mC,_lC]) c.dispose(); super.dispose();
  }

  String s(String k) => _s(widget.lc, k);
  void _syncYrs() { if(_sT)return; _sT=true; _yC.text='${_mo~/12}'; _sT=false; }
  void _fromYrs(int y) { if(_sT)return; _sT=true; _mo=y*12; _mC.text='$_mo'; _sT=false; }

  void _calc() {
    setState(() { _err=null; _hasResult=false; });
    switch (_solve) {
      case _Solve.rate:     _calcRate(); break;
      case _Solve.duration: _calcDur();  break;
      case _Solve.loan:     _calcLoan(); break;
    }
  }
  void _calcRate() {
    if (_pmt<=0||_loan<=0||_mo<=0) { _setErr(s('errPos')); return; }
    final r = Engine.revRate(pmt: _pmt, principal: _loan, months: _mo);
    if (r==null) { _setErr(s('errNone')); return; }
    _setRes(rate: r, totalPd: _pmt*_mo, principal: _loan);
  }
  void _calcDur() {
    if (_pmt<=0||_loan<=0||_rate<=0) { _setErr(s('errPos')); return; }
    final n = Engine.revMonths(pmt: _pmt, annualPct: _rate, principal: _loan);
    if (n==null) { _setErr(s('errPayLow')); return; }
    _setRes(mo: n, totalPd: _pmt*n, principal: _loan);
  }
  void _calcLoan() {
    if (_pmt<=0||_rate<=0||_mo<=0) { _setErr(s('errPos')); return; }
    final v = Engine.revLoan(pmt: _pmt, annualPct: _rate, months: _mo);
    if (v==null) { _setErr(s('errNone')); return; }
    _setRes(loan: v, totalPd: _pmt*_mo, principal: v);
  }
  void _setErr(String msg) => setState(() => _err = msg);
  void _setRes({double? rate, int? mo, double? loan,
      required double totalPd, required double principal}) {
    setState(() {
      _resRate=rate; _resMo=mo; _resLoan=loan;
      _resTotalPd=totalPd; _resTotalInt=totalPd-principal; _hasResult=true;
    });
  }
  String _solveLabel(_Solve sv) {
    switch(sv) {
      case _Solve.rate:     return s('sRate');
      case _Solve.duration: return s('sDur');
      case _Solve.loan:     return s('sLoan');
    }
  }

  @override
  Widget build(BuildContext ctx) => LayoutBuilder(builder: (ctx, con) {
    final wide = con.maxWidth >= _kBreak;
    final items = _form();
    if (!wide) return ListView(primary: false, padding: const EdgeInsets.fromLTRB(12,8,12,32), children: items);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 3,
        child: ListView(primary: false, padding: const EdgeInsets.fromLTRB(16,8,8,32), children: items)),
      Container(width: 1, color: kBdr),
      Expanded(flex: 2,
        child: _hasResult
          ? SingleChildScrollView(primary: false, padding: const EdgeInsets.fromLTRB(8,16,16,32),
              child: _RevRes(lc: widget.lc, solve: _solve,
                resRate: _resRate, resMo: _resMo, resLoan: _resLoan,
                totalPd: _resTotalPd!, totalInt: _resTotalInt!,
                onSend: () => widget.onSend(_Xfer(
                  rate:   _solve==_Solve.rate     ? _resRate : _rate,
                  amount: _solve==_Solve.loan     ? _resLoan : _loan,
                  months: _solve==_Solve.duration ? _resMo   : _mo))))
          : _Empty(_err ?? s('noData'))),
    ]);
  });

  List<Widget> _form() => [
    _rCard(s('solveFor'), Icons.tune_outlined, [
      ..._Solve.values.map((sv) => RadioListTile<_Solve>(
        title: Text(_solveLabel(sv), style: const TextStyle(fontSize: 14)),
        value: sv, groupValue: _solve, activeColor: kP, dense: true,
        contentPadding: EdgeInsets.zero,
        onChanged: (v) => setState(() { _solve=v!; _hasResult=false; _err=null; }))),
    ]),
    _rCard(s('payIn'), Icons.payments_outlined, [
      _rRow(_pmtC, null, decimal: true, onVal: (v) => _pmt=v??_pmt,
        onM: () { _pmt=(_pmt-10).clamp(1,1e6); _pmtC.text=fmtP(_pmt); },
        onP: () { _pmt+=10; _pmtC.text=fmtP(_pmt); }),
      _rSl(_pmt.clamp(1,10000), 1, 10000, null,
        (v) { _pmt=(v/10).round()*10; _pmtC.text=fmtP(_pmt); }),
    ]),
    if (_solve != _Solve.rate)
      _rCard(s('rate'), Icons.percent_outlined, [
        _rRow(_rateC, '%', decimal: true, onVal: (v) => _rate=v??_rate,
          onM: () { _rate=(_rate-0.01).clamp(0.01,50); _rateC.text=fmtP(_rate); },
          onP: () { _rate=(_rate+0.01).clamp(0.01,50); _rateC.text=fmtP(_rate); }),
        _rSl(_rate.clamp(0.01,20), 0.01, 20, 1999,
          (v) { _rate=(v*100).round()/100; _rateC.text=fmtP(_rate); }),
      ]),
    if (_solve != _Solve.duration)
      _rCard('${s('yrs')} / ${s('mo')}', Icons.schedule_outlined, [
        Row(children: [
          Expanded(child: _dCol2(s('yrs'), _yC,
            onM: () { final y=((pInt(_yC.text)??20)-1).clamp(1,50); _yC.text='$y'; _fromYrs(y); },
            onP: () { final y=((pInt(_yC.text)??20)+1).clamp(1,50); _yC.text='$y'; _fromYrs(y); },
            onVal: (v) { if(v!=null) _fromYrs(v.toInt()); })),
          const SizedBox(width: 12),
          Expanded(child: _dCol2(s('mo'), _mC,
            onM: () { _mo=(_mo-1).clamp(1,600); _mC.text='$_mo'; _syncYrs(); },
            onP: () { _mo=(_mo+1).clamp(1,600); _mC.text='$_mo'; _syncYrs(); },
            onVal: (v) { _mo=v?.toInt()??_mo; _syncYrs(); })),
        ]),
      ]),
    if (_solve != _Solve.loan)
      _rCard(s('loanAmt'), Icons.account_balance_outlined, [
        _rRow(_lC, null, onVal: (v) => _loan=v??_loan,
          onM: () { _loan=(_loan-1000).clamp(0,10e6); _lC.text='${_loan.round()}'; },
          onP: () { _loan+=1000; _lC.text='${_loan.round()}'; }),
        _rSl(_loan.clamp(0,1e6), 0, 1e6, 1000,
          (v) { _loan=(v/1000).round()*1000; _lC.text='${_loan.round()}'; }),
      ]),
    Padding(padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(width: double.infinity,
        child: ElevatedButton.icon(onPressed: _calc,
          icon: const Icon(Icons.calculate_outlined, size: 18), label: Text(s('calcBtn'))))),
    if (_err != null)
      Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: kE.withOpacity(0.07), borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kE.withOpacity(0.25))),
        child: Row(children: [
          const Icon(Icons.error_outline, color: kE, size: 16), const SizedBox(width: 8),
          Expanded(child: Text(_err!, style: const TextStyle(color: kE, fontSize: 13))),
        ])),
    if (_hasResult && !_wide(context))
      _RevRes(lc: widget.lc, solve: _solve,
        resRate: _resRate, resMo: _resMo, resLoan: _resLoan,
        totalPd: _resTotalPd!, totalInt: _resTotalInt!,
        onSend: () => widget.onSend(_Xfer(
          rate:   _solve==_Solve.rate     ? _resRate : _rate,
          amount: _solve==_Solve.loan     ? _resLoan : _loan,
          months: _solve==_Solve.duration ? _resMo   : _mo))),
  ];

  Widget _rCard(String label, IconData icon, List<Widget> ch) =>
    Card(margin: const EdgeInsets.only(bottom: 10),
      child: Padding(padding: const EdgeInsets.fromLTRB(14,12,14,8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size:15, color:kP), const SizedBox(width:6),
            Expanded(child: Text(label, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize:12, fontWeight:FontWeight.w700, color:kP))),
          ]),
          const SizedBox(height: 10), ...ch,
        ])));

  Widget _rRow(TextEditingController ctrl, String? sfx, {
    bool decimal=false, required ValueChanged<double?> onVal,
    required VoidCallback onM, required VoidCallback onP}) =>
    Row(children: [
      Expanded(child: _Fld(ctrl: ctrl, suffix: sfx, decimal: decimal, onVal: onVal)),
      const SizedBox(width: 8),
      _Btn(Icons.remove, onM), const SizedBox(width: 4), _Btn(Icons.add, onP),
    ]);

  Widget _rSl(double val, double min, double max, int? div, ValueChanged<double> cb) =>
    SizedBox(height: 32, child: Slider(value: val, min: min, max: max, divisions: div, onChanged: cb));

  Widget _dCol2(String label, TextEditingController ctrl, {
    required VoidCallback onM, required VoidCallback onP, required ValueChanged<double?> onVal}) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: kSub)), const SizedBox(height: 4),
      Row(children: [
        Expanded(child: _Fld(ctrl: ctrl, integer: true, onVal: onVal)),
        const SizedBox(width: 4),
        _Btn(Icons.remove, onM, size: 34), const SizedBox(width: 3), _Btn(Icons.add, onP, size: 34),
      ]),
    ]);
}

class _RevRes extends StatelessWidget {
  final String lc; final _Solve solve;
  final double? resRate, resLoan; final int? resMo;
  final double totalPd, totalInt; final VoidCallback onSend;
  const _RevRes({required this.lc, required this.solve,
    this.resRate, this.resMo, this.resLoan,
    required this.totalPd, required this.totalInt, required this.onSend});
  String s(String k) => _s(lc, k);

  @override
  Widget build(BuildContext ctx) {
    String mainLbl = '', mainVal = '';
    switch (solve) {
      case _Solve.rate:
        mainLbl = s('rR'); mainVal = '${fmtP(resRate ?? 0)} %'; break;
      case _Solve.duration:
        final m = resMo ?? 0;
        mainLbl = s('dR');
        mainVal = '${m ~/ 12} ${s('yrs')}  ${m % 12} ${s('mo')}'; break;
      case _Solve.loan:
        mainLbl = s('lR'); mainVal = fmtC(resLoan ?? 0); break;
    }
    return Card(margin: const EdgeInsets.only(bottom: 10), clipBehavior: Clip.hardEdge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(color: kP2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(children: [
            Text(mainLbl, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12)),
            const SizedBox(height: 6),
            Text(mainVal, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
          ])),
        Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          Row(children: [
            Expanded(child: _StatTile(s('totalPdR'), fmtC(totalPd),  kP)),
            const SizedBox(width: 10),
            Expanded(child: _StatTile(s('totalIR'),  fmtC(totalInt), kO)),
          ]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSend,
              icon: const Icon(Icons.send_outlined, size: 15),
              label: Text(s('send')),
              style: OutlinedButton.styleFrom(
                foregroundColor: kP, side: const BorderSide(color: kP),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 11)))),
        ])),
      ]));
  }
}

// ══════════════════════════════════════════════════════════════
// 13. SHARED WIDGETS
// ══════════════════════════════════════════════════════════════

class _Fld extends StatelessWidget {
  final TextEditingController ctrl;
  final String? suffix, error;
  final bool decimal, integer;
  final ValueChanged<double?> onVal;
  const _Fld({required this.ctrl, this.suffix, this.error,
    this.decimal=false, this.integer=false, required this.onVal});
  @override
  Widget build(BuildContext ctx) => TextField(
    controller: ctrl,
    keyboardType: integer
        ? const TextInputType.numberWithOptions(decimal: false)
        : const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [FilteringTextInputFormatter.allow(
        integer ? RegExp(r'\d') : RegExp(r'[\d.,]'))],
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kTxt),
    decoration: InputDecoration(
      suffixText: suffix,
      suffixStyle: const TextStyle(color: kSub, fontSize: 13),
      errorText: error),
    onChanged: (s) => onVal(pd(s)));
}

class _Btn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap; final double size;
  const _Btn(this.icon, this.onTap, {this.size=40});
  @override
  Widget build(BuildContext ctx) => Material(color: kBg, borderRadius: BorderRadius.circular(8),
    child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8),
      child: Container(width: size, height: size,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: kBdr)),
        child: Icon(icon, size: 15, color: kP))));
}

class _Empty extends StatelessWidget {
  final String msg; const _Empty(this.msg);
  @override
  Widget build(BuildContext ctx) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: kP.withOpacity(0.07), shape: BoxShape.circle),
        child: Icon(Icons.calculate_outlined, size: 48, color: kP.withOpacity(0.5))),
      const SizedBox(height: 16),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(msg, textAlign: TextAlign.center,
          style: const TextStyle(color: kSub, fontSize: 15))),
    ]));
}