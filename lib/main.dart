import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_correction/Translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';

import 'Application.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '几何校正'),
      localizationsDelegates: [
        _localeOverrideDelegate, // 注册一个新的delegate
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        //支持的多语言
        const Locale('en', ''),
        const Locale('zh', ''),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    /// 初始化一个新的Localization Delegate，有了它，当用户选择一种新的工作语言时，可以强制初始化一个新的Translations
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);

    // 保存这个方法的指针，当用户改变语言时，我们可以调用applic.onLocaleChanged(new Locale('en',''));，通过SetState()我们可以强制App整个刷新
    applic.onLocaleChanged = onLocaleChange;
  }

  /// 改变语言时的应用刷新核心，每次选择一种新的语言时，都会创造一个新的SpecificLocalizationDelegate实例，强制Translations类刷新。
  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String barcode = "";
  var _imgPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            barcode,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          InkWell(
            child: Text(
              '二维码扫描',
              style: TextStyle(fontSize: 30, color: Colors.red),
            ),
            onTap: () {
              print("跳转二维码扫描");
              scan();
//                RouteManager.jumpPageCommon(context, QrCodePage());
            },
          ),
          GestureDetector(
            child: Container(
              child: _select_ImageView(_imgPath),
              padding: EdgeInsets.all(10),
            ),
            onTap: () {
              _showPicSelectDialog();
            },
          ),
          InkWell(
            child: Text(
              Translations.of(context).text("upload"),
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            onTap: () {
              print(Translations.of(context).text("upload"));
//              applic.onLocaleChanged(new Locale('en',''));
            },
          )
        ],
      ),
    );
  }

  /*认证图片控件*/
  Widget _select_ImageView(imgPath) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    if (imgPath == null) {
      return Image.asset(
        "assets/image/default_select.png",
        height: 200,
        width: width,
        fit: BoxFit.fill,
      );
    } else {
      return Image.file(
        imgPath,
        height: 200,
        width: width,
        fit: BoxFit.fill,
      );
    }
  }

  void _showPicSelectDialog() {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text('选择'),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text('拍照'),
              onPressed: _takePhoto,

//              {
//                _takePhoto;
//                Navigator.pop(context);
//              },
            ),
            new SimpleDialogOption(
              child: new Text('相册'),
              onPressed: _openGallery,
//              onPressed: () {
//                Navigator.of(context).pop(); //关闭对话框
//              },
            ),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imgPath = image;
    });
    print(_imgPath);
    Navigator.pop(context);
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgPath = image;
    });
    print(_imgPath);
    Navigator.pop(context);
  }

  //  扫描二维码
  Future scan() async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
      print('扫码结果: ' + barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // 未授予APP相机权限
        print('未授予APP相机权限');
      } else {
        // 扫码错误
        print('扫码错误: $e');
      }
    } on FormatException {
      // 进入扫码页面后未扫码就返回
      print('进入扫码页面后未扫码就返回');
    } catch (e) {
      // 扫码错误
      print('扫码错误: $e');
    }
  }
}
