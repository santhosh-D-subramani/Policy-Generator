import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CopyScreen extends StatefulWidget {
  const CopyScreen(
      {Key? key,
      required this.title,
      required this.name,
      required this.email,
      required this.devName,
      required this.otherInfo,
      required this.typeInfo})
      : super(key: key);
  final String title;
  final String name;
  final String email;
  final String devName;
  final String otherInfo;
  final String typeInfo;

  @override
  State<CopyScreen> createState() => _CopyScreenState();
}

class _CopyScreenState extends State<CopyScreen> {
  late TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    _updateParagraph();
    super.initState();
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Copied'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  whatType(String theType) {
    if (theType == 'Free') {
      return 'Free';
    } else if (theType == 'Open Source') {}
  }

  void _updateParagraph() {
    setState(() {
      final String name = widget.name;
      final String email = widget.email;
      final String devName = widget.devName;
      final String otherInfo = widget.otherInfo;
      final String title = widget.title;
      final String type = whatType(widget.typeInfo);
      String paragraph = '';

      if (title == 'Privacy Policy') {
        paragraph =
            'Create an app $name as an app Free. This app was released by $devName. It is free of charge and is intended for use as is. This page is used to inform users of this app about our policies and what information we collect if anyone decides to use our app.\n\n'
            'If you choose to use this application, you agree to give us permission to collect and use information in connection with this policy. The personal information we collect is used to provide and improve the Service. We will not share your information with anyone except as described in this Privacy Policy.\n\n'
            'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which can be accessed in Filak unless otherwise specified in this Privacy Policy.\n\n'
            'Information collection and use\n\n'
            'For a better experience, while using our Services, we may ask you to provide us with certain personally identifiable information. The information we request from you will be kept on your device and we do not collect it in any way.\n\n'
            'This app uses third party services that may collect some of your information that is used to identify you.\n\n'
            'Below are links to the privacy policy of third-party service providers used in this app:\n'
            'Google Play Services\n'
            'Admob\n'
            'Google Analytics for Firebase\n'
            'Firebase Crashlytics\n'
            'Facebook\n'
            'Unity\n'
            '$otherInfo\n\n'
            'Data recording\n\n'
            'We want to inform you that when you use this app, if there is an error in the app, we collect data and information (through third party products) on your phone and this process is called data logging. This Log Data may include information such as your device\'s Internet Protocol (IP) address, device name, operating system version, the configuration of the Application when you use it, the time and date of your use of the Application, and other statistics.\n\n'
            'Cookies\n\n'
            'Cookies are files that contain a small amount of data that are commonly used as anonymous unique identifiers. They are sent to your browser from the websites you visit and are stored on your device\'s internal memory. Application $name does not use "cookies" explicitly. However, the app may use code or a third-party service that uses "cookies" to collect information and improve their services. You have a choice to either accept or decline these cookies and to know when a cookie is sent to your device. If you choose to decline our cookies, you may not be able to use some parts of this Service.\n\n'
            'Service providers\n\n'
            'We may employ third party companies and individuals for the following reasons:\n'
            'To facilitate our service to you in our applications;\n'
            'to provide services on our behalf;\n'
            'To carry out services related to the service we fast for you in our applications; or\n'
            'To help us analyze how our Service is used. App users must $name\n'
            'To know that third party servers used in this application have access to your personal information. The reason is to carry out the tasks assigned to them on our behalf. However, they are obligated not to disclose or use this information for any other purpose.\n\n'
            'Safety\n\n'
            'We appreciate your trust in providing us with your personal information, so we are moving towards using commercially acceptable means to protect it. But remember that no method of transmission over the Internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.\n\n'
            'Links to other sites\n\n'
            'This application may contain links to other websites. If you click on a third party link, you will be directed to that site. Note that these external websites are not operated by us. Therefore, I strongly advise you to review the privacy policy of these websites. We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services contained in this Application.\n\n'
            'Children\'s privacy\n\n'
            'We do not deal in these services with anyone under the age of 13. We do not collect personally identifiable information from children under the age of 13. If we discover that a child under the age of 13 has provided us with personal information, we immediately delete it from our servers. If you are a parent or guardian and you are aware that your child has provided us with their personal information, please contact us so that we can take necessary action.\n\n'
            'Changes to this Privacy Policy\n\n'
            'We may update our Privacy Policy at any time. Therefore, we advise you to review this page periodically to be aware of new changes in our policy. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately upon being posted on this page.\n\n'
            'Contact us\n\n'
            'If you have any questions or suggestions about our privacy policy, please do not hesitate to contact us.\n'
            '$devName\n'
            '$email\n';
      } else if (title == 'Terms of Use') {
        paragraph =
            'By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to $devName.\n\n'
            '$name $devName is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.\n\n'
            'The $name app stores and processes personal data that you have provided to us, in order to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the miz app won’t work properly or at all.\n\n'
            'The app does use third party services that declare their own Terms and Conditions.\n\n'
            'Terms and Conditions of third party service providers used by the app are bound to owners.\n'
            'Google Play Services\n'
            'Admob\n'
            'Google Analytics for Firebase\n'
            'Firebase Crashlytics\n'
            'Facebook\n'
            'Unity\n'
            '$otherInfo\n\n'
            'You should be aware that there are certain things that $name $devName will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, or provided by your mobile network provider, but $name $devName cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.\n\n'
            'If you’re using the app outside of an area with Wi-Fi, you should remember that your terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.\n\n'
            'Along the same lines, $name $devName cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, $name $devName cannot accept responsibility.\n\n'
            'With respect to $name $devName’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavour to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. $name $devName accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.\n\n'
            'At some point, we may wish to update the app. The app is currently available on Android – the requirements for system(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. $name $devName does not promise that it will always update the app so that it is relevant to you and/or works with the Android version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.\n\n'
            'Changes to This Terms and Conditions:\n\n'
            'We may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms and Conditions on this page.\n\n'
            'These terms and conditions are effective as of 25-04-2023.\n\n'
            'Contact Us:'
            'If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at $email.';
      }

      _textEditingController.text = paragraph;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            backgroundColor: CupertinoColors.systemGroupedBackground,
            border: Border(
              bottom: BorderSide(
                color: brightness == Brightness.light
                    ? CupertinoColors.black
                    : CupertinoColors.white,
              ),
            ),
            middle: const Text('Generated Content'),
            largeTitle: Text(widget.title),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: CupertinoTextField(
                    controller: _textEditingController,
                    readOnly: false,
                    maxLines: null,
                  ),
                ),
                const SizedBox(height: 16.0),
                CupertinoButton(
                  child: const Text('Copy'),
                  onPressed: () {
                    //ClipboardData(text: _textEditingController.text);
                    Clipboard.setData(
                            ClipboardData(text: _textEditingController.text))
                        .then((value) => _showAlertDialog(context));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
