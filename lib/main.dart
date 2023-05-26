import 'package:flutter/cupertino.dart';
import 'package:privacy_policy_generator/copy_screen.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

const double _kItemExtent = 32.0;

//TODO: typeNames need to be implemented
const List<String> _typeNames = <String>[
  'Free',
  'Open Source',
  'commercial',
  'Premium',
  'Supported by Ads',
];

const List<String> _ownerNames = <String>[
  'Developer',
  'Company',
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAdaptiveTheme(
      light: const CupertinoThemeData(
        brightness: Brightness.light,
      ),
      dark: const CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (CupertinoThemeData theme) => CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Policy Generator',
        theme: theme,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
    print(isTextFieldEmpty);
    print(!isSwitchOn);

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
                    typeInfo: '',
                  );
                }));
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
                        typeInfo: '',
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
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
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
          Expanded(
            child: SliverFillRemaining(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () {
                      Form.maybeOf(primaryFocus!.context!)?.save();
                    },
                    child: CupertinoFormSection(
                      children: [
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Name'),
                          controller: _nameController,
                          placeholder: 'Enter your name here',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
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
                        CupertinoListTile(
                          title: const Text('Type'),
                          trailing: CupertinoButton(
                            padding: EdgeInsets.zero,
                            // Display a CupertinoPicker with list of fruits.
                            onPressed: () => _showDialog(
                              CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: _kItemExtent,
                                // This sets the initial item.
                                scrollController: FixedExtentScrollController(
                                  initialItem: _selectedType,
                                ),
                                // This is called when selected item is changed.
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
                            // This displays the selected fruit name.
                            child: Text(
                              _typeNames[_selectedType],
                              style: const TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                        ),
                        CupertinoListTile(
                          title: const Text('Owner'),
                          trailing: CupertinoButton(
                            padding: EdgeInsets.zero,
                            // Display a CupertinoPicker with list of fruits.
                            onPressed: () => _showDialog(
                              CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: _kItemExtent,
                                // This sets the initial item.
                                scrollController: FixedExtentScrollController(
                                  initialItem: _selectedOwner,
                                ),
                                // This is called when selected item is changed.
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
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Other'),
                          controller: _otherController,
                          placeholder: 'Enter your Other Providers',
                        ),
                        // CupertinoButton.filled(
                        //     onPressed: () {
                        //
                        //     },
                        //     child: const Text('Generate')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
