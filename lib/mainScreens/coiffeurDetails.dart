import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../mainScreens/worksFromDetails.dart';
import '../mainScreens/chatScreen.dart';
import '../mainScreens/offerScreenFromDetails.dart';
import '../mainScreens/servicesScreenFromDetails.dart';
import '../providers/reservationsProvider.dart';
import '../widgets/loader.dart';
import '../providers/moreScreenProvider.dart';
import '../providers/MessagesProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CoiffeurDetailsScreen extends StatefulWidget {
  // variable to ref screen name to routes in main.dart and Navigation
  static const routeName = 'coiffeurDetails';

  final int id;

  CoiffeurDetailsScreen({this.id});

  @override
  _CoiffeurDetailsScreenState createState() => _CoiffeurDetailsScreenState();
}

class _CoiffeurDetailsScreenState extends State<CoiffeurDetailsScreen> {
  //-----------------------------variables--------------------------------------
  int _isFav = 0;
  List<Object> _pages;
  int nIndex = 0;
  bool auth = false;
  Future fetchCoiffureDetails;
  //-------------------------------methods--------------------------------------
  void initState() {
    fetchCoiffureDetails = Provider.of<Reservations>(context, listen: false)
        .fetchCoiffeurDetails(widget.id)
        .then((coif) {
      _isFav = coif.data.fav;
      Provider.of<More>(context, listen: false).fetchFavourite().then((favs){
        _isFav = favs.data.advertisers.where((adv)=>adv.advertiserId == widget.id).toList().length;
      setState(() {});
      });
      print(_isFav);
    });
    print(':::::::id:::::::' + widget.id.toString());
    _pages = [
      /*******Screens*******/
      ServicesScreenFromDetails(
        id: widget.id,
      ),
      WorksScreenFromDetails(),
      OfferScreenFromDetails(
        id: widget.id,
      ),
    ];
    super.initState();
  }

  void _share() {
    // TODO --------------------------------------------------------------
  }

  void _favouriteIconPressed(int id) async {
    print(_isFav);
    if (_isFav == 0) {
      // setState(() {
      //   _isFav = 1;
      // });
     _isFav= (await Provider.of<Reservations>(context, listen: false)
          .makeFav(widget.id)).data.status;
        // Provider.of<Reservations>(context, listen: false)
        //     .fetchCoiffeurDetails(widget.id)
        //     .then((coiaff) {
        //   _isFav = coiaff.data.status;
        //   print('isFave is $_isFav');
          setState(() {});
       
      // });
    } else {
      // setState(() {
      //   _isFav = 0;
      // });
      print('DELETING');
       await Provider.of<More>(context, listen: false).deleteFav(id)
      .then((_) {
        _isFav = 0;
      //   Provider.of<Reservations>(context, listen: false)
      //       .fetchCoiffeurDetails(widget.id)
      //       .then((coiaff) {
      //     _isFav = coiaff.data.status;
      //     print('isFave is $_isFav');
          setState(() {});
        // });
      });
    }
    // _isFav = 1 - _isFav;
  }

  void _contactIconPressed() async {
    await Provider.of<MessagesProvider>(context, listen: false)
        .sendMessage(widget.id, ' ');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          receiverName: 'المحادثه',
          receiverId: widget.id,
        ),
      ),
    );
  }

  void getToken() async {
    String token;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      token = extractedUserData['token'];
      if (token == null) {
        auth = false;
      }
      auth = true;
    }
  }
  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    print(_isFav);
    double containerSize = MediaQuery.of(context).size.width * 0.25;
    getToken();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(235, 218, 241, 10),
          title: Text(
            'اسم المشغل',
            style: TextStyle(
              color: Color.fromRGBO(104, 57, 120, 10),
              fontSize: 20.0,
              fontFamily: 'beINNormal',
            ),
          ),
//          actions: <Widget>[
//            IconButton(
//                icon: Icon(
//                  Icons.share,
//                  color: Color.fromRGBO(104, 57, 120, 10),
//                ),
//                onPressed: _share),
//          ],
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(104, 57, 120, 10),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: FutureBuilder(
          future: fetchCoiffureDetails,
          builder: (context, dataSnapShot) {
            if (dataSnapShot.hasError) print(dataSnapShot.error);
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: ColorLoader(
                  radius: 20.0,
                  dotRadius: 5.0,
                ),
              );
            } else {
              if (dataSnapShot.error != null) {
                return Center(
                  child: Text(
                    'تحقق من اتصالك بالانترنت' + dataSnapShot.error.toString(),
                    style: TextStyle(
                      fontFamily: 'beINNormal',
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                );
              } else {
                return Consumer<Reservations>(
                  builder: (context, detail, child) => Column(
                    children: <Widget>[
                      //----------------------ClientDetails---------------------
                      Container(
                        height: 150,
                        width: double.infinity,
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                'https://mashghllkw.com/cdn/' +
                                    detail.coiffeurDetails.data.advertiserImage,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    detail.coiffeurDetails.data.advertiserName,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'beINNormal',
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            '${detail.coiffeurDetails.data.address}'));
                                    HapticFeedback.vibrate();
                                    Toast.show('تم المسخ', context);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .50,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        '${detail.coiffeurDetails.data.address}',
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          height: 1.4,
                                          color: Colors.grey,
                                          fontFamily: 'beINNormal',
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                auth
                                    ? IconButton(
                                        icon: _isFav == 1
                                            ? Image.asset(
                                                'assets/icons/fav.png',
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/icons/favore.png',
                                                fit: BoxFit.cover,
                                              ),
                                        onPressed: () => _favouriteIconPressed(
                                            detail.coiffeurDetails.data.favId),
                                      )
                                    : new Container(),
                                IconButton(
                                  icon: Image.asset(
                                    'assets/icons/speech-bubble.png',
                                    fit: BoxFit.cover,
                                  ),
                                  onPressed: _contactIconPressed,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //------------------------------TabBar----------------------------
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 80,
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          nIndex = 0;
                                        });
                                      },
                                      child: Container(
                                        width: containerSize,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            40.0,
                                          ),
                                          border: Border.all(
                                            width: 1.0,
                                            color: Color.fromRGBO(
                                                104, 57, 120, 10),
                                          ),
                                          color: nIndex != 0
                                              ? Colors.white
                                              : Color.fromRGBO(
                                                  104, 57, 120, 10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'الخدمات',
                                            style: TextStyle(
                                              color: nIndex == 0
                                                  ? Colors.white
                                                  : Color.fromRGBO(
                                                      104, 57, 120, 10),
                                              fontSize: 16.0,
                                              fontFamily: 'beINNormal',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          nIndex = 1;
                                        });
                                      },
                                      child: Container(
                                        width: containerSize,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            40.0,
                                          ),
                                          border: Border.all(
                                            width: 1.0,
                                            color: Color.fromRGBO(
                                                104, 57, 120, 10),
                                          ),
                                          color: nIndex != 1
                                              ? Colors.white
                                              : Color.fromRGBO(
                                                  104, 57, 120, 10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'اعمالى',
                                            style: TextStyle(
                                              color: nIndex == 1
                                                  ? Colors.white
                                                  : Color.fromRGBO(
                                                      104, 57, 120, 10),
                                              fontSize: 16.0,
                                              fontFamily: 'beINNormal',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          nIndex = 2;
                                        });
                                      },
                                      child: Container(
                                        width: containerSize,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            40.0,
                                          ),
                                          border: Border.all(
                                            width: 1.0,
                                            color: Color.fromRGBO(
                                                104, 57, 120, 10),
                                          ),
                                          color: nIndex != 2
                                              ? Colors.white
                                              : Color.fromRGBO(
                                                  104, 57, 120, 10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'العروض',
                                            style: TextStyle(
                                              color: nIndex == 2
                                                  ? Colors.white
                                                  : Color.fromRGBO(
                                                      104, 57, 120, 10),
                                              fontSize: 16.0,
                                              fontFamily: 'beINNormal',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: _pages[nIndex],
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
          },
        ),
      ),
    );
  }
}
