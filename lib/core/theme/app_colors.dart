import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // --- GRUVBOX LIGHT THEME ---
  static const Color text = Color(0xFF3C3836); // fg
  static const Color subText1 = Color(0xFF7C6F64); // gray
  static const Color textLight = Color(0xFF7C6F64); // gray

  static const Color background = Color(0xFFFBF1C7); // bg
  static const Color surface0 = Color(0xFFEBDBB2); // bg1
  static const Color surface1 = Color(0xFFD5C4A1); // bg2

  // Accent Colors
  static const Color red = Color(0xFF9D0006);
  static const Color orange = Color(0xFFAF3A03);
  static const Color blue = Color(0xFF076678);
  static const Color purple = Color(0xFF8F3F71);
  static const Color aqua = Color(0xFF427B58);

  // Deprecated Catppuccin names mapped to Gruvbox
  static const Color flamingo = red;
  static const Color rosewater = orange;
  static const Color pink = purple;
  static const Color mauve = purple;
  static const Color lavender = blue;
  static const Color sky = blue;
  static const Color sapphire = aqua;

  // --- PRESERVED COLORS (BECASUE BACKEND  BLAH) ---
  static const Color peach = Color(0xFFFE8019);
  static const Color yellow = Color(0xFFFABD2F);
  static const Color maroon = Color(0xFFFB4934);
  static const Color green = Color(0xFFB8BB26);
  static const Color teal = Color(0xFF83A598);
  // --- END PRESERVED ---

  // --- GRUVBOX DARK THEME ---
  static const Color midnight = Color(0xFF504945); // bg
  static const Color mSurface = Color(0xFF3C3836); // bg1
  static const Color mText = Color(0xFFEBDBB2); // fg
  static const Color mSubtext0 = Color(0xFFBDAE93); // fg4

  // Accent Colors
  static const Color mRed = Color(0xFFCC241D);
  static const Color mOrange = Color(0xFFD65D0E);
  static const Color mBlue = Color(0xFF458588);
  static const Color mPurple = Color(0xFFB16286);
  static const Color mAqua = Color(0xFF689D6A);

  // Deprecated Catppuccin names mapped to Gruvbox
  static const Color mRosewater = mOrange;
  static const Color mFlamingo = mRed;
  static const Color mPink = mPurple;
  static const Color mMauve = mPurple;
  static const Color mSky = mBlue;

  // --- PRESERVED DARK COLORS (Unchanged as requested) ---
  static const Color mMaroon = Color(0xFFCC241D);
  static const Color mPeach = Color(0xFFD65D0E);
  static const Color mYellow = Color(0xFFD79921);
  static const Color mGreen = Color(0xFF89871A);
  static const Color mTeal = Color(0xFF458588);
  // --- END PRESERVED ---
  
  // Semantic Colors mapped to Gruvbox
  static const Color success = Color(0xFF98971A); // Gruvbox Green
  static const Color warning = Color(0xFFD79921); // Gruvbox Yellow
  static const Color error = Color(0xFFCC241D); // Gruvbox Red

  // Kept for compatibility if used elsewhere for white text on dark backgrounds
  static const Color base = Color(0xFFFBF1C7);

	// GRUVBOX DARK REAL
	static const Color grbd = Color(0xFF282828);

}
