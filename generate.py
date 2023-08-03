#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Generates the Neo Comic Mono font files based on Comic Shanns font.

Based on:
- monospacifier: https://github.com/cpitclaudel/monospacifier/blob/master/monospacifier.py
- YosemiteAndElCapitanSystemFontPatcher: https://github.com/dtinth/YosemiteAndElCapitanSystemFontPatcher/blob/master/bin/patch

"""

import os
import re
import sys

# reload(sys)
# sys.setdefaultencoding('UTF8')

import fontforge
import psMat
import unicodedata

def height(font):
    return float(font.capHeight)

def adjust_height(source, template, scale):
    source.selection.all()
    source.transform(psMat.scale(height(template) / height(source)))
    for attr in ['ascent', 'descent',
                'hhea_ascent', 'hhea_ascent_add',
                'hhea_linegap',
                'hhea_descent', 'hhea_descent_add',
                'os2_winascent', 'os2_winascent_add',
                'os2_windescent', 'os2_windescent_add',
                'os2_typoascent', 'os2_typoascent_add',
                'os2_typodescent', 'os2_typodescent_add',
                ]:
        setattr(source, attr, getattr(template, attr))
    source.transform(psMat.scale(scale))

font = fontforge.open('vendor/comic-shanns.otf')

# Modify charasters not implemented in Comic Shans v2
new = fontforge.open('neo-font.otf')
font.mergeFonts(new)

ref = fontforge.open('vendor/cousine.ttf')

for glyph in font.glyphs():
    uni = glyph.unicode
    category = unicodedata.category(chr(uni)) if 0 <= uni <= sys.maxunicode else None
    if glyph.width > 0 and category not in ['Mn', 'Mc', 'Me']:
        width = 510
        if glyph.width != width:
            delta = width - glyph.width
            glyph.left_side_bearing = int(round(glyph.left_side_bearing + delta / 2))
            glyph.right_side_bearing = int(round(glyph.right_side_bearing + delta - glyph.left_side_bearing))
            glyph.width = width


font.familyname = 'Neo Comic Mono'
font.version = '0.0.1'
font.comment = 'https://github.com/jptrzy/neo-comic-mono-font'
font.copyright = 'https://raw.githubusercontent.com/jptrzy/neo-comic-mono-font/master/LICENSE'

adjust_height(font, ref, 0.875)
font.sfnt_names = [] # Get rid of 'Prefered Name' etc.
font.fontname = 'NeoComicMono'
font.fullname = 'Neo Comic Mono'
font.generate('build/NeoComicMono.ttf')

font.selection.all()
font.fontname = 'NeoComicMono-Bold'
font.fullname = 'Neo Comic Mono Bold'
font.weight = 'Bold'
font.changeWeight(32, "LCG", 0, 0, "squish")
font.generate('build/NeoComicMono-Bold.ttf')
