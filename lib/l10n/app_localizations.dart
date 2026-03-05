import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('tr')
  ];

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// A programmer greetingg
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Header of app in intro area
  ///
  /// In en, this message translates to:
  /// **'KiWi - Habit App'**
  String get appHeader;

  /// Add Your First Habit area
  ///
  /// In en, this message translates to:
  /// **'Add Your First Habit'**
  String get addYourFirstHabitButton;

  /// Already have a KiWi account? area
  ///
  /// In en, this message translates to:
  /// **'Already have a KiWi account?'**
  String get allreadyHaveKiwiButton;

  /// todayText area
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayText;

  /// Energize your life
  ///
  /// In en, this message translates to:
  /// **'Energize your life'**
  String get introFirstScreen;

  /// Create your workout goals that will boost your life energy with 🥝.
  ///
  /// In en, this message translates to:
  /// **'Create your workout goals that will boost your life energy with 🥝.'**
  String get introFirstScreenDetail;

  /// Remove Stress from Your Life
  ///
  /// In en, this message translates to:
  /// **'Remove Stress from Your Life'**
  String get introSecondScreen;

  /// Make your plans and take a break from the stress of life with 🥝
  ///
  /// In en, this message translates to:
  /// **'Make your plans and take a break from the stress of life with 🥝'**
  String get introSecondScreenDetail;

  /// Focus on Your Personal Development
  ///
  /// In en, this message translates to:
  /// **'Focus on Your Personal Development'**
  String get introThirdScreen;

  /// Streamline your life and achieve your goals with 🥝.
  ///
  /// In en, this message translates to:
  /// **'Streamline your life and achieve your goals with 🥝.'**
  String get introThirdScreenDetail;

  /// Learn Regular Habits
  ///
  /// In en, this message translates to:
  /// **'Learn Regular Habits'**
  String get introFourthScreen;

  /// Build positive habits into your life with 🥝.
  ///
  /// In en, this message translates to:
  /// **'Build positive habits into your life with 🥝.'**
  String get introFourthScreenDetail;

  /// Choose Your Habits
  ///
  /// In en, this message translates to:
  /// **'Choose Your Habits'**
  String get chooseYourHabits;

  /// Continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Or
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get orButton;

  /// Define Your Habit
  ///
  /// In en, this message translates to:
  /// **'Define Your Habit'**
  String get defineYourHabit;

  /// Habit Name
  ///
  /// In en, this message translates to:
  /// **'Habit Name'**
  String get habitName;

  /// Add to habits
  ///
  /// In en, this message translates to:
  /// **'Add to habits'**
  String get addToHabits;

  /// Habit List
  ///
  /// In en, this message translates to:
  /// **'Habit List'**
  String get habitList;

  /// Habit Details
  ///
  /// In en, this message translates to:
  /// **'Habit Details'**
  String get habitDetails;

  /// goalText
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goalText;

  /// inADay
  ///
  /// In en, this message translates to:
  /// **'in a day'**
  String get inADay;

  /// everyDay
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// nextButton
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// previousButton
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousButton;

  /// finishButton
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishButton;

  /// signIn
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Exit
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitButton;

  /// cancelButton
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// deleteHabit
  ///
  /// In en, this message translates to:
  /// **'Delete Habit'**
  String get deleteHabit;

  /// deleteAccount
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// addNewHabit
  ///
  /// In en, this message translates to:
  /// **'Add New Habit'**
  String get addNewHabit;

  /// Sorry, you don't have a KiWi account
  ///
  /// In en, this message translates to:
  /// **'Sorry, you don\'t have a KiWi account'**
  String get dontHaveKiwiAccount;

  /// deleteAccountConfirm
  ///
  /// In en, this message translates to:
  /// **'If you continue, you will lose your habits. Are you sure?'**
  String get deleteAccountConfirm;

  /// reallyAsk
  ///
  /// In en, this message translates to:
  /// **'Really?👀'**
  String get reallyAsk;

  /// continueWith
  ///
  /// In en, this message translates to:
  /// **'Continue with'**
  String get continueWith;

  /// quickNotificationAdd
  ///
  /// In en, this message translates to:
  /// **'Add A Quick Notification'**
  String get quickNotificationAdd;

  /// quickNotificationTextLabel
  ///
  /// In en, this message translates to:
  /// **'Quick Notification Name'**
  String get quickNotificationTextLabel;

  /// scheduleNotification
  ///
  /// In en, this message translates to:
  /// **'Schedule Notification'**
  String get scheduleNotification;

  /// reminderNotificationLabel
  ///
  /// In en, this message translates to:
  /// **' time😎'**
  String get reminderNotificationLabel;

  /// healthLabel
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthLabel;

  /// sportLabel
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get sportLabel;

  /// studyLabel
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get studyLabel;

  /// artLabel
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get artLabel;

  /// financeLabel
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeLabel;

  /// socialLabel
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get socialLabel;

  /// quitABadHabitLabel
  ///
  /// In en, this message translates to:
  /// **'Quit a Bad Habit'**
  String get quitABadHabitLabel;

  /// You should have at least one habit
  ///
  /// In en, this message translates to:
  /// **'You should have at least one habit '**
  String get youShouldOneHabit;

  /// Yoga
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get yoga;

  /// meditation
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get meditation;

  /// drinkWater
  ///
  /// In en, this message translates to:
  /// **'Drink Water'**
  String get drinkWater;

  /// sleepWell
  ///
  /// In en, this message translates to:
  /// **'Sleep Well'**
  String get sleepWell;

  /// walk
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walk;

  /// pushUp
  ///
  /// In en, this message translates to:
  /// **'Push Up'**
  String get pushUp;

  /// run
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get run;

  /// swim
  ///
  /// In en, this message translates to:
  /// **'Swim'**
  String get swim;

  /// readABook
  ///
  /// In en, this message translates to:
  /// **'Read a Book'**
  String get readABook;

  /// learnEnglish
  ///
  /// In en, this message translates to:
  /// **'Learn English'**
  String get learnEnglish;

  /// mathExercise
  ///
  /// In en, this message translates to:
  /// **'Math Exercise'**
  String get mathExercise;

  /// repeatToday
  ///
  /// In en, this message translates to:
  /// **'Repeat Today'**
  String get repeatToday;

  /// playGuitar
  ///
  /// In en, this message translates to:
  /// **'Play Guitar'**
  String get playGuitar;

  /// painting
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get painting;

  /// playPiano
  ///
  /// In en, this message translates to:
  /// **'Play Piano'**
  String get playPiano;

  /// dance
  ///
  /// In en, this message translates to:
  /// **'Dance'**
  String get dance;

  /// savingMoney
  ///
  /// In en, this message translates to:
  /// **'Saving Money'**
  String get savingMoney;

  /// checkStocks
  ///
  /// In en, this message translates to:
  /// **'Check Stocks'**
  String get checkStocks;

  /// donate
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// checkCurrencies
  ///
  /// In en, this message translates to:
  /// **'Check Currencies'**
  String get checkCurrencies;

  /// cinema
  ///
  /// In en, this message translates to:
  /// **'Cinema'**
  String get cinema;

  /// meetWithFriends
  ///
  /// In en, this message translates to:
  /// **'Meet With Friends'**
  String get meetWithFriends;

  /// theater
  ///
  /// In en, this message translates to:
  /// **'Theater'**
  String get theater;

  /// playGames
  ///
  /// In en, this message translates to:
  /// **'Play Games'**
  String get playGames;

  /// quitSmoking
  ///
  /// In en, this message translates to:
  /// **'Quit Smoking'**
  String get quitSmoking;

  /// quitEatingSnacks
  ///
  /// In en, this message translates to:
  /// **'Quit Eating Snacks'**
  String get quitEatingSnacks;

  /// quitAlcohol
  ///
  /// In en, this message translates to:
  /// **'Quit Alcohol'**
  String get quitAlcohol;

  /// stopSwearing
  ///
  /// In en, this message translates to:
  /// **'Stop Swearing'**
  String get stopSwearing;

  /// warning
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// willLoseYourData
  ///
  /// In en, this message translates to:
  /// **'You will lose your habits data, please sign up before leave.'**
  String get willLoseYourData;

  /// swipeLabel
  ///
  /// In en, this message translates to:
  /// **'Swipe'**
  String get swipeLabel;

  /// plsPickALoginMethod
  ///
  /// In en, this message translates to:
  /// **'Please pick a login method'**
  String get plsPickALoginMethod;

  /// Support By Watching Ads
  ///
  /// In en, this message translates to:
  /// **'Support By Watching Ads'**
  String get supportUs;

  /// cantDeleteAllHabits
  ///
  /// In en, this message translates to:
  /// **'You can\'t delete all your habits.'**
  String get cantDeleteAllHabits;

  /// My Challenges tab label
  ///
  /// In en, this message translates to:
  /// **'My Challenges'**
  String get myChallenguesTab;

  /// Discover tab label
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTab;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// Join challenge button
  ///
  /// In en, this message translates to:
  /// **'Join Challenge'**
  String get joinChallenge;

  /// Leave challenge button
  ///
  /// In en, this message translates to:
  /// **'Leave Challenge'**
  String get leaveChallenge;

  /// Check in today button
  ///
  /// In en, this message translates to:
  /// **'Check In Today'**
  String get checkInToday;

  /// Already checked in today message
  ///
  /// In en, this message translates to:
  /// **'Checked in today!'**
  String get alreadyCheckedIn;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String daysLeft(int count);

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'{count} participants'**
  String participants(int count);

  /// Leaderboard label
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// Create challenge button
  ///
  /// In en, this message translates to:
  /// **'Create Challenge'**
  String get createChallenge;

  /// Challenge title field label
  ///
  /// In en, this message translates to:
  /// **'Challenge Title'**
  String get challengeTitle;

  /// Challenge description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get challengeDescription;

  /// Duration field label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Daily goal field label
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// Check-in success message
  ///
  /// In en, this message translates to:
  /// **'Check-in complete!'**
  String get checkInSuccess;

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakLabel(int count);

  /// Sign out button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Total points label
  ///
  /// In en, this message translates to:
  /// **'KiWi Points'**
  String get totalPoints;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No badges yet message
  ///
  /// In en, this message translates to:
  /// **'No badges yet'**
  String get noBadgesYet;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// Sign up page title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpTitle;

  /// Google login button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginWithGoogle;

  /// Apple login button
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get loginWithApple;

  /// Email login button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginWithEmail;

  /// No account prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Already have account prompt
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyAccount;

  /// Sign up button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
