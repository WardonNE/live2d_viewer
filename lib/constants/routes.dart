class Routes {
  static const index = '/';
  static const destinyChild = 'destiny-child';
  static const destinyChildCharacterDetail = 'destiny-child/character-detail';
  static const destinyChildSoulCartaDetail = 'destiny-child/soul-carta-detail';

  static const nikke = 'nikke';
  static const nikkeCharacters = 'nikke/characters';
  static const nikkeCharacterDetail = 'nikke/character-detail';

  static const girlFrontline = 'girl-frontline';
  static const girlFrontlineCharacters = 'girl-frontline/characters';
  static const girlFrontlineCharacterDetail = 'girl-frontline/character-detail';

  static const azurlane = 'azurlane';
  static const azurlaneCharacters = 'azurlane/characters';
  static const azurlaneCharacterDetail = 'azurlane/character-detail';

  static List<String> all() {
    return [
      index,
      destinyChild,
      destinyChildCharacterDetail,
      destinyChildSoulCartaDetail,
      nikke,
      nikkeCharacters,
      nikkeCharacterDetail,
      girlFrontline,
      girlFrontlineCharacters,
      girlFrontlineCharacterDetail,
      azurlane,
      azurlaneCharacters,
      azurlaneCharacterDetail,
    ];
  }
}
