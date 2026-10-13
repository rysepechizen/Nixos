{ settings, ... }:
{
  time.timeZone = settings.timeZone;
  i18n.defaultLocale = settings.locale;
}
