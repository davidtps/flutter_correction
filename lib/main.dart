import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '几何校正'),
    );
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
              "上传",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            onTap: () {
              print("上传");
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
