package Mail::SpamAssassin::Locales;

use strict;
use vars	qw{ %charsets_for_locale };

###########################################################################


# A mapping of known country codes to frequent charsets used therein.
# note that the ISO and CP charsets will already have been permitted,
# so only "unusual" charsets should be listed here.
#
# Country codes should be lowercase, charsets uppercase.
#
# A good listing is in /usr/share/config/charsets from KDE 2.2.1
#
%charsets_for_locale = (
  # Japanese
  'ja' => 'EUCJP JISX020119760 JISX020819830 JISX020819900 JISX020819970 JISX021219900 JISX021320001 JISX021320002 SHIFT_JIS SHIFTJIS ISO2022JP SJIS JIS7',
  # Korea
  'ko' => 'EUCKR EUCKR',
  # Cyrillic
  'ru' => 'KOI8R KOI8U KOI8T ISOIR111 CP1251 GEORGIANPS CP1251 PT154',
  'ka' => 'KOI8R KOI8U KOI8T ISOIR111 CP1251 GEORGIANPS CP1251 PT154',
  'tg' => 'KOI8R KOI8U KOI8T ISOIR111 CP1251 GEORGIANPS CP1251 PT154',
  'be' => 'KOI8R KOI8U KOI8T ISOIR111 CP1251 GEORGIANPS CP1251 PT154',
  'uk' => 'KOI8R KOI8U KOI8T ISOIR111 CP1251 GEORGIANPS CP1251 PT154',
  'bg' => 'KOI8R KOI8U KOI8T ISOIR111 CP1251 GEORGIANPS CP1251 PT154',
  # Thai
  'th' => 'TIS620',
  # Chinese (simplified and traditional)
  'zh' => 'GB2312 GB231219800 GB18030 GBK BIG5HKSCS BIG5 EUCTW',
);

###########################################################################

sub is_charset_ok_for_locales {
  my ($cs, @locales) = @_;

  $cs = uc $cs; $cs =~ s/[^A-Z0-9]//g;
  $cs =~ s/^3D//gs;		# broken by quoted-printable?
  study $cs;
  #warn "JMD $cs";

  # always OK (the net speaks mostly roman charsets)
  return 1 if ($cs eq 'USASCII');
  return 1 if ($cs =~ /^ISO8859/);
  return 1 if ($cs =~ /^ISO10646/);
  return 1 if ($cs =~ /^UTF/);
  return 1 if ($cs =~ /^UCS/);
  return 1 if ($cs =~ /^CP125/);
  return 1 if ($cs =~ /^WINDOWS125/);
  return 1 if ($cs eq 'IBM852');
  return 1 if ($cs =~ /^UNICODE11UTF[78]/);	# wtf? never heard of it
  return 1 if ($cs eq 'XUNKNOWN'); # added by sendmail when converting to 8bit
  return 1 if ($cs eq 'ISO');	# Magellan, sending as 'charset=iso 8859-15'. grr

  foreach my $locale (@locales) {
    if (!defined($locale) || $locale eq 'C') { $locale = 'en'; }
    $locale =~ s/^([a-z][a-z]).*$/$1/;	# zh_TW... => zh

    my $ok_for_loc = $charsets_for_locale{$locale};
    return 0 if (!defined $ok_for_loc);

    if ($ok_for_loc =~ /(?:^| )\Q${cs}\E(?:$| )/) {
      return 1;
    }
  }

  return 0;
}
