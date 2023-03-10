// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Live2D Viewer`
  String get title {
    return Intl.message(
      'Live2D Viewer',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Games`
  String get indexTitle {
    return Intl.message(
      'Games',
      name: 'indexTitle',
      desc: '',
      args: [],
    );
  }

  /// `{section, select, destinyChild {Destiny Child} nikke {GODDESS OF VICTORY: NIKKE} girlFrontline {Girls' Frontline} azurlane {Azur Lane}}`
  String gameTitles(Object section) {
    return Intl.select(
      section,
      {
        'destinyChild': 'Destiny Child',
        'nikke': 'GODDESS OF VICTORY: NIKKE',
        'girlFrontline': 'Girls\' Frontline',
        'azurlane': 'Azur Lane',
      },
      name: 'gameTitles',
      desc: '',
      args: [section],
    );
  }

  /// `Destiny Child`
  String get destinyChild {
    return Intl.message(
      'Destiny Child',
      name: 'destinyChild',
      desc: '',
      args: [],
    );
  }

  /// `GODDESS OF VICTORY: NIKKE`
  String get nikke {
    return Intl.message(
      'GODDESS OF VICTORY: NIKKE',
      name: 'nikke',
      desc: '',
      args: [],
    );
  }

  /// `Girls' Frontline`
  String get girlFrontline {
    return Intl.message(
      'Girls\' Frontline',
      name: 'girlFrontline',
      desc: '',
      args: [],
    );
  }

  /// `Azur Lane`
  String get azurlane {
    return Intl.message(
      'Azur Lane',
      name: 'azurlane',
      desc: '',
      args: [],
    );
  }

  /// `reload`
  String get reload {
    return Intl.message(
      'reload',
      name: 'reload',
      desc: '',
      args: [],
    );
  }

  /// `confirm`
  String get confirm {
    return Intl.message(
      'confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Request Error`
  String get requestError {
    return Intl.message(
      'Request Error',
      name: 'requestError',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get dialogTitleError {
    return Intl.message(
      'Error',
      name: 'dialogTitleError',
      desc: '',
      args: [],
    );
  }

  /// `Animations`
  String get tooltipShowAnimation {
    return Intl.message(
      'Animations',
      name: 'tooltipShowAnimation',
      desc: '',
      args: [],
    );
  }

  /// `Clothes`
  String get tooltipShowSkins {
    return Intl.message(
      'Clothes',
      name: 'tooltipShowSkins',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get tooltipShowActions {
    return Intl.message(
      'Actions',
      name: 'tooltipShowActions',
      desc: '',
      args: [],
    );
  }

  /// `Zoom`
  String get tooltipZoom {
    return Intl.message(
      'Zoom',
      name: 'tooltipZoom',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get tooltipSpeedPlay {
    return Intl.message(
      'Speed',
      name: 'tooltipSpeedPlay',
      desc: '',
      args: [],
    );
  }

  /// `Devtool`
  String get tooltipDevtool {
    return Intl.message(
      'Devtool',
      name: 'tooltipDevtool',
      desc: '',
      args: [],
    );
  }

  /// `Loop Playback`
  String get tooltipLoopPlay {
    return Intl.message(
      'Loop Playback',
      name: 'tooltipLoopPlay',
      desc: '',
      args: [],
    );
  }

  /// `Play & Record`
  String get tooltipPlayAndRecord {
    return Intl.message(
      'Play & Record',
      name: 'tooltipPlayAndRecord',
      desc: '',
      args: [],
    );
  }

  /// `Expressions`
  String get tooltipShowExpressions {
    return Intl.message(
      'Expressions',
      name: 'tooltipShowExpressions',
      desc: '',
      args: [],
    );
  }

  /// `Motions`
  String get tooltipShowMotions {
    return Intl.message(
      'Motions',
      name: 'tooltipShowMotions',
      desc: '',
      args: [],
    );
  }

  /// `Snapshot`
  String get tooltipSnapshot {
    return Intl.message(
      'Snapshot',
      name: 'tooltipSnapshot',
      desc: '',
      args: [],
    );
  }

  /// `Set expression & snapshot`
  String get tooltipSnapshotWithExpession {
    return Intl.message(
      'Set expression & snapshot',
      name: 'tooltipSnapshotWithExpession',
      desc: '',
      args: [],
    );
  }

  /// `Spring skin`
  String get tooltipSpringSkin {
    return Intl.message(
      'Spring skin',
      name: 'tooltipSpringSkin',
      desc: '',
      args: [],
    );
  }

  /// `SD Model`
  String get tooltipSD {
    return Intl.message(
      'SD Model',
      name: 'tooltipSD',
      desc: '',
      args: [],
    );
  }

  /// `Live2D`
  String get tooltipLive2D {
    return Intl.message(
      'Live2D',
      name: 'tooltipLive2D',
      desc: '',
      args: [],
    );
  }

  /// `filter`
  String get tooltipFilter {
    return Intl.message(
      'filter',
      name: 'tooltipFilter',
      desc: '',
      args: [],
    );
  }

  /// `Force reload`
  String get forceReload {
    return Intl.message(
      'Force reload',
      name: 'forceReload',
      desc: '',
      args: [],
    );
  }

  /// `Soul Carta`
  String get soulCarta {
    return Intl.message(
      'Soul Carta',
      name: 'soulCarta',
      desc: '',
      args: [],
    );
  }

  /// `Child`
  String get child {
    return Intl.message(
      'Child',
      name: 'child',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filterTitle {
    return Intl.message(
      'Filter',
      name: 'filterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get formLabelName {
    return Intl.message(
      'Name',
      name: 'formLabelName',
      desc: '',
      args: [],
    );
  }

  /// `Rarity`
  String get formLabelRarity {
    return Intl.message(
      'Rarity',
      name: 'formLabelRarity',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get formLabelType {
    return Intl.message(
      'Type',
      name: 'formLabelType',
      desc: '',
      args: [],
    );
  }

  /// `Nationality`
  String get formLabelNationality {
    return Intl.message(
      'Nationality',
      name: 'formLabelNationality',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get buttonCancel {
    return Intl.message(
      'Cancel',
      name: 'buttonCancel',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get buttonSubmit {
    return Intl.message(
      'Submit',
      name: 'buttonSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get buttonReset {
    return Intl.message(
      'Reset',
      name: 'buttonReset',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
