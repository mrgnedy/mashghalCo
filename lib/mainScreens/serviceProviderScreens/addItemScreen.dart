import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mashghal_co/models/allServicesDropListModel.dart';
import 'package:mashghal_co/providers/homePageProvider.dart';
import 'package:mashghal_co/widgets/loader.dart';
import '../../widgets/textFieldEditingWidget.dart';
import 'package:provider/provider.dart';
import '../../providers/homePageProvider.dart';

class AddItemScreen extends StatefulWidget {
  // variable to ref screen name to routes in main.dart and Navigation
  static const routeName = 'addItemScreen';

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  //----------------------------variables---------------------------------------
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name,
      _price,
      _description,
      _serviceType,
      type,
      _offer = '0',
      selected;
  bool _start = true;
  List<Services> info = [];
  List<String> modelSheet = [];
  bool _isLoading = false;
  bool _isOffer = false;
  String isOffer = '0';
  TextEditingController startDateCtrler = TextEditingController();
  TextEditingController endDateCtrler = TextEditingController();
  //-----------------------------methods----------------------------------------
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      Provider.of<HomePage>(context, listen: false).fetchServicesDropList();
      setState(() {
        _start = false;
      });
    });
    Provider.of<HomePage>(context, listen: false).fetchServicesDropList();
    info = Provider.of<HomePage>(context, listen: false).dropList;
    Provider.of<HomePage>(context, listen: false).dropList.forEach((i) {
      modelSheet.add(i.name);
    });
    super.initState();
  }

  void _onSwitchChanged(bool value) {
    setState(() {
      _isOffer = !_isOffer;
    });
    if (_isOffer) {
      setState(() {
        isOffer = '1';
      });
    } else {
      isOffer = '0';
    }
  }

  String btnValue;
  void _onSavedDropList(String type) {
    // selected = type;
    setState(() {
      btnValue = type;
    });
    int index = info.indexWhere((item) => item.name == type);
    _serviceType = info[index].id.toString();
    print(_serviceType);
    // type = _serviceType;
  }

  Widget _showDropDownList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'نوع الخدمة',
              style: TextStyle(
                fontFamily: 'beINNormal',
                color: Color.fromRGBO(104, 57, 120, 10),
                fontSize: 14.0,
              ),
            ),
          ),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButton(
                value: btnValue,
                iconSize: 15.0,
                elevation: 5,
                style: TextStyle(
                  fontFamily: 'beINNormal',
                  color: Color.fromRGBO(104, 57, 120, 10),
                  fontSize: 12.0,
                ),
                items: items
                    .map(
                      (value) => DropdownMenuItem(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontFamily: 'beINNormal',
                            color: Color.fromRGBO(104, 57, 120, 10),
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        value: value,
                      ),
                    )
                    .toList(),
                onChanged: _onSavedDropList,
                isExpanded: true,
                hint: Text(
                  '--اختر الخدمه--',
                  style: TextStyle(
                    color: Color.fromRGBO(104, 57, 120, 10),
                    fontSize: 14.0,
                    fontFamily: 'beINNormal',
                  ),
                ),
                iconDisabledColor: Color.fromRGBO(104, 57, 120, 10),
                iconEnabledColor: Color.fromRGBO(104, 57, 120, 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  Future<void> _addItem(provider) async {
    final formData = _formKey.currentState;
    if (formData.validate()) {
      formData.save();
      setState(() {
        _isLoading = true;
      });
      await provider.addService(
          _serviceType,
          _description,
          _name,
          _price,
          isOffer,
          _offer,
          '11pm to 11am',
          startDateCtrler.text,
          endDateCtrler.text);
      Provider.of<HomePage>(context).fetchAdvertiserServices();
      Provider.of<HomePage>(context).fetchAdvertiserOffers();
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    }
  }

  //--------------------------onSavedMethods------------------------------------
  void _onSavedFirstForm(value) {
    _name = value;
  }

  void _onSavedThirdForm(value) {
    _price = value;
  }

  void _onSavedForthForm(value) {
    _description = value;
  }

  void _onSavedFifthForm(value) {
    _offer = value;
  }

  // ------------------------------validators-----------------------------------
  String _firstValidator(value) {
    if (value.isEmpty) {
      return 'رجاء ادخل اسم الخدمه ';
    }
    return null;
  }

  String _thirdValidator(value) {
    if (value.isEmpty) {
      return 'ادخل سعر الخدمه رجاء';
    }
    return null;
  }

  String _forthValidator(value) {
    return null;
  }

  String _fifthValidator(value) {
    if (value.isEmpty) {
      return 'ادخل قيمة العرض رجاء';
    }
    return null;
  }

  //-------------------------------build----------------------------------------

  @override
  Widget build(BuildContext context) {
    return _start
        ? Center(
            child: ColorLoader(
              dotRadius: 5.0,
              radius: 15.0,
            ),
          )
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Consumer<HomePage>(
              builder: (_, homePage, child) => Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Color.fromRGBO(235, 218, 241, 10),
                  title: Text(
                    'اضافه خدمه',
                    style: TextStyle(
                      color: Color.fromRGBO(104, 57, 120, 10),
                      fontSize: 20.0,
                      fontFamily: 'beINNormal',
                    ),
                  ),
                  leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(104, 57, 120, 10),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
                body: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, right: 10.0),
                        child: _showDropDownList(modelSheet),
                      ),
                      TextFieldEditingWidget(
                        labelText: 'اسم الخدمه:',
                        initialValue: '',
                        validator: _firstValidator,
                        onSaved: _onSavedFirstForm,
                      ),
                      TextFieldEditingWidget(
                        isNumber: true,
                        labelText: 'سعر الخدمه:',
                        initialValue: '',
                        validator: _thirdValidator,
                        onSaved: _onSavedThirdForm,
                      ),
                      TextFieldEditingWidget(
                        labelText: 'الوصف:',
                        initialValue: '',
                        validator: _forthValidator,
                        onSaved: _onSavedForthForm,
                      ),
                      //-----------------------switchOffer------------------------------
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'اضافه الخدمه ضمن العروض',
                              style: TextStyle(
                                color: Color.fromRGBO(104, 57, 120, 10),
                                fontSize: 16.0,
                                fontFamily: 'beINNormal',
                              ),
                            ),
                            Spacer(),
                            Switch(
                              value: _isOffer,
                              onChanged: _onSwitchChanged,
                              activeColor: Color.fromRGBO(104, 57, 120, 10),
                            ),
                          ],
                        ),
                      ),
                      _isOffer == true
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFieldEditingWidget(
                                      labelText: 'قيمة العرض:',
                                      initialValue: '',
                                      validator: _fifthValidator,
                                      onSaved: _onSavedFifthForm,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        'تاريخ العرض:',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(104, 57, 120, 10),
                                          fontFamily: 'beINNormal',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // height: 80,
                                      child: Row(
                                        children: <Widget>[
                                          buildStartDate(),
                                          buildEndDate(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 50.0,
                            ),
                      //------------------------button----------------------------------
                      SizedBox(
                        height: 50.0,
                      ),
                      _isLoading
                          ? Container(
                              height: 60,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Center(
                                child: ColorLoader(
                                  radius: 15.0,
                                  dotRadius: 5.0,
                                ),
                              ),
                            )
                          : GestureDetector(
                              //TODO: Add time
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                _addItem(homePage);
                              },
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(104, 57, 120, 10),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'اضافه',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'beINNormal',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget buildStartDate() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          style: TextStyle(height: 1.2),
          controller: startDateCtrler,
          decoration: InputDecoration(
              hintText: 'بداية العرض',
              hintStyle:
                  TextStyle(color: Colors.grey, fontFamily: 'beINNormal'),
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.date_range,
                    color: Colors.black,
                  ),
                  onPressed: () => getStartDate(startDateCtrler)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder()),
        ),
      ),
    );
  }

  Widget buildEndDate() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          style: TextStyle(height: 1.2),
          controller: endDateCtrler,
          decoration: InputDecoration(
              hintText: 'نهاية العرض',
              hintStyle:
                  TextStyle(color: Colors.grey, fontFamily: 'beINNormal'),
              suffixIcon: Container(
                height: 50,
                child: IconButton(
                  icon: Icon(
                    Icons.date_range,
                    color: Colors.black,
                  ),
                  onPressed: () => getStartDate(endDateCtrler),
                ),
              ),
              
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder()),
        ),
      ),
    );
  }

  getStartDate(TextEditingController controller) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)),
        initialDate: DateTime.now());
    controller.text = date.toString().split(' ').first;
  }
}
