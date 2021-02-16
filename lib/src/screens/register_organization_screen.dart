// import 'package:Gifts/src/common/providers/causes_provider.dart';
import 'package:Gifts/src/common/widgets/app_drawer.dart';
import 'package:Gifts/src/common/widgets/build_image_url_form_field.dart';
import 'package:Gifts/src/common/widgets/build_text_form_field.dart';
import 'package:Gifts/src/common/widgets/cause_item.dart';
import 'package:Gifts/src/screens/user_ngos_screen.dart';
import 'package:flutter/material.dart';
import 'package:Gifts/src/common/providers/individual_ngo_provider.dart';
import 'package:Gifts/src/common/providers/ngos_provider.dart';
import 'package:provider/provider.dart';

class RegisterOrganizationScreen extends StatefulWidget {
  static const routeName = '/registerCauseScreen';

  @override
  _RegisterOrganizationScreenState createState() =>
      _RegisterOrganizationScreenState();
}

class _RegisterOrganizationScreenState
    extends State<RegisterOrganizationScreen> {
  final _ngoTitleFocusNode = FocusNode();
  final _causeFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _registrationCertificateUrlFocusNode = FocusNode();
  final _contactPersonFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _bankAccountNumberFocusNode = FocusNode();
  final _ifscFocusNode = FocusNode();
  final _paymentUrlFocusNode = FocusNode();

  // ------
  final _ngoTitleTextController = TextEditingController();
  final _causeTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _contactPersonTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _mobileTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _bankAccountNumberTextController = TextEditingController();
  final _ifscTextController = TextEditingController();
  final _paymentUrlTextController = TextEditingController();
  // ------
  final _imageUrlController = TextEditingController();
  final _registrationCertificateUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();
  var _editedNgo = IndividualNgo(
    id: null,
    ngoTitle: '',
    causeId: '',
    causeTitle: '',
    description: '',
    imageUrl: '',
    address: '',
    registrationCertificateUrl: '',
    contactPerson: '',
    phone: '',
    mobile: '',
    email: '',
    bankAccountNumber: '',
    ifsc: '',
    paymentUrl: '',
  );

  // var _isInit = true;
  var _isLoading = false;
  var _next = TextInputAction.next;
  var _done = TextInputAction.done;
  var _text = TextInputType.text;
  var multiLines = TextInputType.multiline;
  var _url = TextInputType.url;
  var _number = TextInputType.number;
  var _email = TextInputType.emailAddress;

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.contains('.png') &&
              !_imageUrlController.text.contains('.jpg') &&
              !_imageUrlController.text.contains('.jpeg'))) {
        return;
      }
    }
    setState(() {});
  }

  Future<void> _saveForm(context) async {
    // final _editedCause = Provider.of<CausesProvider>(context, listen: false)
    //     .findById(_editedNgo.causeId);
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedNgo.id != null) {
      Provider.of<NgosProvider>(context, listen: false)
          .updateNgo(_editedNgo.id, _editedNgo);
    } else {
      try {
        await Provider.of<NgosProvider>(context, listen: false)
            .addNgo(_editedNgo);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    // Navigator.of(context).pop();
    Navigator.of(context).pushNamed(UserNgosScreen.routeName);
  }

  void _onSaved(value) {
    CauseItem2 args = ModalRoute.of(context).settings.arguments;

    _editedNgo = IndividualNgo(
      id: _editedNgo.id,
      isFavorite: _editedNgo.isFavorite,
      ngoTitle:
          value != null ? _ngoTitleTextController.text : _editedNgo.ngoTitle,
      causeId: args.causeId,
      causeTitle: args.causeTitle,
      description: value != null
          ? _descriptionTextController.text
          : _editedNgo.description,
      address: value != null ? _addressTextController.text : _editedNgo.address,
      imageUrl: value != null ? _imageUrlController.text : _editedNgo.imageUrl,
      registrationCertificateUrl: value != null
          ? _registrationCertificateUrlController.text
          : _editedNgo.registrationCertificateUrl,
      contactPerson: value != null
          ? _contactPersonTextController.text
          : _editedNgo.contactPerson,
      phone: value != null ? _phoneTextController.text : _editedNgo.phone,
      mobile: value != null ? _mobileTextController.text : _editedNgo.mobile,
      email: value != null ? _emailTextController.text : _editedNgo.email,
      bankAccountNumber: value != null
          ? _bankAccountNumberTextController.text
          : _editedNgo.bankAccountNumber,
      ifsc: value != null ? _ifscTextController.text : _editedNgo.ifsc,
      paymentUrl: value != null
          ? _paymentUrlTextController.text
          : _editedNgo.paymentUrl,
    );
  }

  Text _title() {
    if (_editedNgo.id == null) {
      return Text('Add Organization');
    } else {
      return Text('Edit Organization');
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    _registrationCertificateUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    CauseItem2 args = ModalRoute.of(context).settings.arguments;
    // UserNgoItem args1 = ModalRoute.of(context).settings.arguments;
    print('didChangeDep');
    print(args.causeId);
    print(args.causeTitle);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _ngoTitleTextController.dispose();
    _causeTextController.dispose();
    _descriptionTextController.dispose();
    _addressTextController.dispose();
    _contactPersonTextController.dispose();
    _phoneTextController.dispose();
    _mobileTextController.dispose();
    _emailTextController.dispose();
    _bankAccountNumberTextController.dispose();
    _ifscTextController.dispose();
    _paymentUrlTextController.dispose();

    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _registrationCertificateUrlController.dispose();
    _registrationCertificateUrlFocusNode.removeListener(_updateImageUrl);
    _registrationCertificateUrlFocusNode.dispose();
    _contactPersonFocusNode.dispose();
    _phoneFocusNode.dispose();
    _mobileFocusNode.dispose();
    _emailFocusNode.dispose();
    _bankAccountNumberFocusNode.dispose();
    _ifscFocusNode.dispose();
    _ngoTitleFocusNode.dispose();
    _causeFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _addressFocusNode.dispose();
    _paymentUrlFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CauseItem2 args = ModalRoute.of(context).settings.arguments;
    // UserNgoItem args1 = ModalRoute.of(context).settings.arguments;
    print('build method');
    print(args.causeId);
    print(args.causeTitle);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: _title(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Text('Save'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                _saveForm(context);
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Form(
                key: _form,
                child: Theme(
                  data: ThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        'Cause: ${args.causeTitle}',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 16),
                      ),
                      BuildTextFormField(
                        labelText: 'Organization Name',
                        keyboardType: _text,
                        textInputAction: _next,
                        controller: _ngoTitleTextController,
                        requestFocus: _causeFocusNode,
                        focusNode: _ngoTitleFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                      BuildTextFormField(
                        labelText: 'Description',
                        keyboardType: multiLines,
                        textInputAction: _next,
                        controller: _descriptionTextController,
                        focusNode: _descriptionFocusNode,
                        requestFocus: _addressFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                      BuildTextFormField(
                        labelText: 'Address',
                        keyboardType: multiLines,
                        textInputAction: _next,
                        controller: _addressTextController,
                        focusNode: _addressFocusNode,
                        requestFocus: _imageUrlFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                      BuildImageUrlFormField(
                        labelText: 'Image Url',
                        keyboardType: _url,
                        textInputAction: _next,
                        urlController: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        requestFocus: _registrationCertificateUrlFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                      ),
                      BuildImageUrlFormField(
                        labelText: 'Registration Certificate',
                        keyboardType: _url,
                        textInputAction: _next,
                        urlController: _registrationCertificateUrlController,
                        focusNode: _registrationCertificateUrlFocusNode,
                        requestFocus: _contactPersonFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                      ),
                      BuildTextFormField(
                        labelText: 'Contact Person',
                        keyboardType: _text,
                        textInputAction: _next,
                        controller: _contactPersonTextController,
                        focusNode: _contactPersonFocusNode,
                        requestFocus: _phoneFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                      BuildTextFormField(
                        labelText: 'Phone Number',
                        keyboardType: _number,
                        textInputAction: _next,
                        controller: _phoneTextController,
                        focusNode: _phoneFocusNode,
                        requestFocus: _mobileFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                      BuildTextFormField(
                        labelText: 'Mobile Number',
                        keyboardType: _number,
                        textInputAction: _next,
                        controller: _mobileTextController,
                        focusNode: _mobileFocusNode,
                        requestFocus: _emailFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                      BuildTextFormField(
                        labelText: 'Email Address',
                        keyboardType: _email,
                        textInputAction: _next,
                        controller: _emailTextController,
                        focusNode: _emailFocusNode,
                        requestFocus: _bankAccountNumberFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                      BuildTextFormField(
                        labelText: 'Bank Account Number',
                        keyboardType: _number,
                        textInputAction: _next,
                        controller: _bankAccountNumberTextController,
                        focusNode: _bankAccountNumberFocusNode,
                        requestFocus: _ifscFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                      BuildTextFormField(
                        labelText: 'IFSC',
                        keyboardType: _text,
                        textInputAction: _next,
                        controller: _ifscTextController,
                        focusNode: _ifscFocusNode,
                        requestFocus: _paymentUrlFocusNode,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                      BuildTextFormField(
                        labelText: 'Payment Url',
                        keyboardType: _url,
                        textInputAction: _done,
                        controller: _paymentUrlTextController,
                        focusNode: _paymentUrlFocusNode,
                        requestFocus: null,
                        onSavedCallback: _onSaved,
                        saveFormCallback: _saveForm,
                        isInitialValue: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
