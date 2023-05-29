import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

import 'package:flutter/cupertino.dart';
import 'package:policy_generator/copy_screen.dart';
const double _kItemExtent = 32.0;

//TODO: typeNames need to be implemented
const List<String> _typeNames = <String>[
  'Free', //0
  'Open Source', //1
  'commercial', //2
  'Premium', //3
  'Supported by Ads', //4
];

const List<String> _ownerNames = <String>[
  'Developer',
  'Company',
];
const String testDevice = '';//debug device ID
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
Admob.initialize(testDeviceIds: [testDevice]);

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness? brightness;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      });
    }
    super.didChangePlatformBrightness();
  }

  CupertinoThemeData get _lightTheme => CupertinoThemeData(
        barBackgroundColor: CupertinoColors.white.withOpacity(.2),
        brightness: Brightness.light, /* light theme settings */
      );

  CupertinoThemeData get _darkTheme => CupertinoThemeData(
        barBackgroundColor: CupertinoColors.black.withOpacity(.2),
        brightness: Brightness.dark, /* dark theme settings */
      );
 whatBrightness(){
  return brightness == Brightness.dark ? _darkTheme : _lightTheme;
}
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Policy Generator',
      theme: brightness == Brightness.dark ? _darkTheme : _lightTheme,
      home:  HomePage(brightness: brightness == Brightness.dark ? Brightness.dark : Brightness.light , ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.brightness}) : super(key: key);
final Brightness brightness;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _developerNameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _otherController;
  int _selectedType = 0;
  int _selectedOwner = 0;
  bool playService = false;
  bool firebase = false;
  bool googleAnalyticsForFirebase = false;
  bool firebaseCrashAnalytics = false;
  bool facebook = false;
  bool admob = false;
  bool unity = false;

  final adUnitId =  'ca-app-pub-3940256099942544/6300978111';//test banner ad ID

  @override
  void initState() {
    super.initState();
    _developerNameController = TextEditingController(text: '');
    _nameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _otherController = TextEditingController(text: '');
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  _showActionSheet(BuildContext context) {
    bool isTextFieldEmpty = _developerNameController.text.isEmpty;
    bool isSwitchOn = playService ||
        firebase ||
        googleAnalyticsForFirebase ||
        firebaseCrashAnalytics ||
        facebook ||
        admob ||
        unity;
    if (isTextFieldEmpty || !isSwitchOn) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Validation Error'),
          message: const Text(
              'Please make sure all text fields are filled and at least one switch is turned on.'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok '),
            ),
          ],
        ),
      );
    } else {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Pick One To Generate'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    CupertinoPageRoute<Widget>(builder: (BuildContext context) {
                  return CopyScreen(
                    title: 'Privacy Policy',
                    name: _nameController.text,
                    email: _emailController.text,
                    devName: _developerNameController.text,
                    otherInfo: _otherController.text,
                    typeInfo: _selectedType.toString(),
                  );
                },),);
              },
              child: const Text('Privacy Policy'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute<Widget>(
                    builder: (BuildContext context) {
                      return CopyScreen(
                        title: 'Terms of Use',
                        name: _nameController.text,
                        email: _emailController.text,
                        devName: _developerNameController.text,
                        otherInfo: _otherController.text,
                        typeInfo: _selectedType.toString(),
                      );
                    },
                  ),
                );
              },
              child: const Text('Terms of Use'),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _developerNameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _otherController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      child: Stack(
        fit: StackFit.loose,
        children: [
          CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                brightness: widget.brightness,
                stretch: true,
                backgroundColor: CupertinoColors.white.withOpacity(.1),
                largeTitle: const Text('Policy Generator'),
                trailing: GestureDetector(
                  onTap: () {
                    _showActionSheet(context);
                  },
                  child: const Text(
                    'Generate',
                    style: TextStyle(color: CupertinoColors.activeGreen),
                  ),
                ),
              ),
              SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: () {
                    Form.maybeOf(primaryFocus!.context!)?.save();
                  },
                  child: Column(
                    children: [
                      CupertinoFormSection(
                      children: [
                        //App Name
                        CupertinoTextFormFieldRow(
                          prefix: const Text('App Name'),
                          controller: _nameController,
                          placeholder: 'Enter your App name here',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        //Email
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Email'),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          placeholder: 'Enter your Email here',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Email';
                            }
                            return null;
                          },
                        ),
                      ],
                      ),
                      CupertinoListSection(
                        children: [
                          //Type
                          CupertinoListTile(
                            title: const Text('Type'),
                            trailing: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => _showDialog(
                                CupertinoPicker(
                                  magnification: 1.22,
                                  squeeze: 1.2,
                                  useMagnifier: true,
                                  itemExtent: _kItemExtent,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: _selectedType,
                                  ),
                                  onSelectedItemChanged: (int selectedItem) {
                                    setState(() {
                                      _selectedType = selectedItem;
                                    });
                                  },
                                  children: List<Widget>.generate(
                                      _typeNames.length, (int index) {
                                    return Center(child: Text(_typeNames[index]));
                                  }),
                                ),
                              ),
                              child: Text(
                                _typeNames[_selectedType],
                                style: const TextStyle(
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                          ),
                          //owner
                          CupertinoListTile(
                            title: const Text('Owner'),
                            trailing: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => _showDialog(
                                CupertinoPicker(
                                  magnification: 1.22,
                                  squeeze: 1.2,
                                  useMagnifier: true,
                                  itemExtent: _kItemExtent,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: _selectedOwner,
                                  ),
                                  onSelectedItemChanged: (int selectedItem) {
                                    setState(() {
                                      _selectedOwner = selectedItem;
                                    });
                                  },
                                  children: List<Widget>.generate(
                                      _ownerNames.length, (int index) {
                                    return Center(
                                        child: Text(_ownerNames[index]));
                                  }),
                                ),
                              ),
                              // This displays the selected fruit name.
                              child: Text(
                                _ownerNames[_selectedOwner],
                                style: const TextStyle(
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //Dev name
                      CupertinoTextFormFieldRow(
                        prefix: _selectedOwner == 0
                            ? const Text('Developer')
                            : const Text('Company'),
                        controller: _developerNameController,
                        placeholder: _selectedOwner == 0
                            ? 'Enter Developer Name here'
                            : 'Enter Company Name here',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),

                      //providers
                      CupertinoFormSection(
                          children: [
                            CupertinoFormRow(
                              prefix: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'images/google play service.png',
                                        height: 24.0,
                                        width: 24.0,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Text('Google Play Service'),
                                      ),
                                    ],
                                  )),
                              child: CupertinoSwitch(
                                value: playService,
                                onChanged: (bool value) {
                                  setState(() {
                                    playService = value;
                                  });
                                },
                              ),
                            ),

                            CupertinoFormRow(
                              prefix: Row(
                                children: [
                                  Image.asset(
                                    'images/firebase.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Text('Firebase'),
                                  ),
                                ],
                              ),
                              child: CupertinoSwitch(
                                value: firebase,
                                onChanged: (bool value) {
                                  setState(() {
                                    firebase = value;
                                  });
                                },
                              ),
                            ),
                            CupertinoFormRow(
                              prefix: Row(
                                children: [
                                  Image.asset(
                                    'images/firebase analytics.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Text('Google Analytics For Firebase'),
                                  ),
                                ],
                              ),
                              child: CupertinoSwitch(
                                value: googleAnalyticsForFirebase,
                                onChanged: (bool value) {
                                  setState(() {
                                    googleAnalyticsForFirebase = value;
                                  });
                                },
                              ),
                            ),
                            CupertinoFormRow(
                              prefix: Row(
                                children: [
                                  Image.asset(
                                    'images/firebase-crashlytics.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Text('Firebase CrashAnalytics'),
                                  ),
                                ],
                              ),
                              child: CupertinoSwitch(
                                value: firebaseCrashAnalytics,
                                onChanged: (bool value) {
                                  setState(() {
                                    firebaseCrashAnalytics = value;
                                  });
                                },
                              ),
                            ),
                            CupertinoFormRow(
                              prefix: Row(
                                children: [
                                  Image.asset(
                                    'images/fb.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Text('Facebook Ads'),
                                  ),
                                ],
                              ),
                              child: CupertinoSwitch(
                                value: facebook,
                                onChanged: (bool value) {
                                  setState(() {
                                    facebook = value;
                                  });
                                },
                              ),
                            ),
                            CupertinoFormRow(
                              prefix: Row(
                                children: [
                                  Image.asset(
                                    'images/google admob.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Text('Admob'),
                                  ),
                                ],
                              ),
                              child: CupertinoSwitch(
                                value: admob,
                                onChanged: (bool value) {
                                  setState(() {
                                    admob = value;
                                  });
                                },
                              ),
                            ),
                            CupertinoFormRow(
                              prefix: Row(
                                children: [
                                  Image.asset(
                                    'images/unity.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Text('Unity Ads'),
                                  ),
                                ],
                              ),
                              child: CupertinoSwitch(
                                value: unity,
                                onChanged: (bool value) {
                                  setState(() {
                                    unity = value;
                                  });
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '* if you have any other providers than listed add it below',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            CupertinoTextFormFieldRow(
                              prefix: const Text('Other'),
                              controller: _otherController,
                              placeholder: 'Enter your Other Providers',
                            ),
                            const SizedBox(height: 50.0,),
                            ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AdmobBanner(
            adUnitId: adUnitId,
            adSize: AdmobBannerSize.BANNER,
          ),),
        ],
      ),

    );
  }
}

class PrefixWidget extends StatelessWidget {
  const PrefixWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Icon(icon, color: CupertinoColors.white),
        ),
        const SizedBox(width: 15),
        Text(title)
      ],
    );
  }
}
