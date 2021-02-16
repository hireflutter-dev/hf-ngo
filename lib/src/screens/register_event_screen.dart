import 'package:Gifts/src/common/providers/events_provider.dart';
import 'package:Gifts/src/common/providers/individual_event_provider.dart';
import 'package:Gifts/src/common/providers/ngos_provider.dart';
import 'package:Gifts/src/common/widgets/build_image_url_form_field.dart';
import 'package:Gifts/src/common/widgets/build_text_form_field.dart';
import 'package:Gifts/src/screens/user_events_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'list_of_ngos_screen.dart';

class RegisterEventScreen extends StatefulWidget {
  static const routeName = '/registerEventScreen';

  @override
  _RegisterEventScreenState createState() => _RegisterEventScreenState();
}

class _RegisterEventScreenState extends State<RegisterEventScreen> {
  String ngoTitle, ngoId;
  Future<void> _refreshNgos(BuildContext context) async {
    await Provider.of<NgosProvider>(context, listen: false)
        .addNgoToEvent(ngoTitle, ngoId);
  }

  final _eventTitleFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _venueFocusNode = FocusNode();
  final _venueAddressFocusNode = FocusNode();
  final _contactMobileFocusNode = FocusNode();
  final _contactEmailFocusNode = FocusNode();
  // final _ngoTitleFocusNode = FocusNode();

  // ------
  final _eventTitleTextController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _dateTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _venueTextController = TextEditingController();
  final _venueAddressTextController = TextEditingController();
  final _contactMobileTextController = TextEditingController();
  final _contactEmailTextController = TextEditingController();
  // final _ngoIdTextController = TextEditingController();
  // final _ngoTitleTextController = TextEditingController();

  // ------

  final _form = GlobalKey<FormState>();
  // var _initValues = {
  //   'eventId': null,
  //   'eventTitle': '',
  //   'ngoId': null,
  //   'ngoTitle': '',
  //   'description': '',
  //   'imageUrl': '',
  //   'contactEmail': '',
  //   'contactMobile': '',
  //   'date': '',
  //   'venue': '',
  //   'venueAddress': '',
  // };

  var _editedEvent = IndividualEventProvider(
    eventId: null,
    eventTitle: '',
    ngoId: null,
    ngoTitle: '',
    description: '',
    imageUrl: '',
    contactEmail: '',
    contactMobile: '',
    date: '',
    venue: '',
    venueAddress: '',
  );

  // var _isInit = true;
  var _isLoading = false;
  var _next = TextInputAction.next;
  var _done = TextInputAction.done;
  var _text = TextInputType.text;
  var _multiLines = TextInputType.multiline;
  var _url = TextInputType.url;
  var _number = TextInputType.number;
  var _email = TextInputType.emailAddress;
  var _date = TextInputType.datetime;

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
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedEvent.eventId != null) {
      Provider.of<EventsProvider>(context, listen: false)
          .updateEvent(_editedEvent.eventId, _editedEvent);
    } else {
      try {
        await Provider.of<EventsProvider>(context, listen: false)
            .addEvent(_editedEvent);
      } catch (error) {
        await _errorShowDialog(context);
      }
    }
    setState(() {
      _isLoading = false;
    });

    _eventAddedShowDialog(context);
  }

  Future<dynamic> _errorShowDialog(context) {
    return showDialog<Null>(
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

  Future _eventAddedShowDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Event Added'),
        content: TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.lightBlueAccent),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                // EventDetailScreen.routeName, arguments: _editedEvent.eventId,
                UserEventsScreen.routeName,
              );
            },
            child: Text('Okay')),
      ),
    );
  }

  void _onSaved(value) {
    // CauseItem2 args = ModalRoute.of(context).settings.arguments;
    final String ngoTitle =
        Provider.of<NgosProvider>(context, listen: false).eventNgoTitle;
    final String ngoId =
        Provider.of<NgosProvider>(context, listen: false).eventNgoId;

    _editedEvent = IndividualEventProvider(
      eventId: _editedEvent.eventId,
      isFavorite: _editedEvent.isFavorite,
      eventTitle: value != null
          ? _eventTitleTextController.text
          : _editedEvent.eventTitle,
      imageUrl:
          value != null ? _imageUrlController.text : _editedEvent.imageUrl,
      date: value != null ? _dateTextController.text : _editedEvent.date,
      description: value != null
          ? _descriptionTextController.text
          : _editedEvent.description,
      venue: value != null ? _venueTextController.text : _editedEvent.venue,
      venueAddress: value != null
          ? _venueAddressTextController.text
          : _editedEvent.venueAddress,
      contactMobile: value != null
          ? _contactMobileTextController.text
          : _editedEvent.contactMobile,
      contactEmail: value != null
          ? _contactEmailTextController.text
          : _editedEvent.contactEmail,
      ngoId: ngoId,
      ngoTitle: ngoTitle,
    );
  }

  Text _title() {
    if (_editedEvent.eventId == null) {
      return Text('Create Event');
    } else {
      return Text('Edit Event');
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // CauseItem2 args = ModalRoute.of(context).settings.arguments;
    // // UserNgoItem args1 = ModalRoute.of(context).settings.arguments;
    // print('didChangeDep');
    // print(args.causeId);
    // print(args.causeTitle);
    final String ngoTitle =
        Provider.of<NgosProvider>(context, listen: false).eventNgoTitle;
    final String ngoId =
        Provider.of<NgosProvider>(context, listen: false).eventNgoId;

    print('$ngoTitle, $ngoId');

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _eventTitleTextController.dispose();
    _imageUrlController.dispose();
    _descriptionTextController.dispose();
    _dateTextController.dispose();
    _venueTextController.dispose();
    _venueAddressTextController.dispose();
    _contactMobileTextController.dispose();
    _contactEmailTextController.dispose();
    // _ngoTitleTextController.dispose();

    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _eventTitleFocusNode.dispose();
    _dateFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _venueFocusNode.dispose();
    _venueAddressFocusNode.dispose();
    _contactMobileFocusNode.dispose();
    _contactEmailFocusNode.dispose();
    // _ngoTitleFocusNode.dispose();
    // _ngoTitleFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String ngoTitle =
        Provider.of<NgosProvider>(context, listen: false).eventNgoTitle;

    return Scaffold(
      // drawer: AppDrawer(),
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshNgos(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Form(
                  key: _form,
                  child: Theme(
                    data: ThemeData(
                      inputDecorationTheme: const InputDecorationTheme(
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: ListView(
                      children: <Widget>[
                        _buildNgoTitleColumn(ngoTitle, context),
                        BuildTextFormField(
                          labelText: 'Event Name',
                          keyboardType: _text,
                          textInputAction: _next,
                          controller: _eventTitleTextController,
                          focusNode: _eventTitleFocusNode,
                          requestFocus: _imageUrlFocusNode,
                          onSavedCallback: _onSaved,
                          saveFormCallback: _saveForm,
                          isInitialValue: false,
                        ),
                        BuildImageUrlFormField(
                          labelText: 'Event Picture Url',
                          keyboardType: _url,
                          textInputAction: _next,
                          urlController: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          requestFocus: _dateFocusNode,
                          onSavedCallback: _onSaved,
                          saveFormCallback: _saveForm,
                        ),
                        BuildTextFormField(
                          labelText: 'Event Date',
                          hintText: 'DD/MM/YYYY',
                          keyboardType: _date,
                          textInputAction: _next,
                          controller: _dateTextController,
                          focusNode: _dateFocusNode,
                          requestFocus: _descriptionFocusNode,
                          onSavedCallback: _onSaved,
                          saveFormCallback: _saveForm,
                          isInitialValue: false,
                        ),
                        BuildTextFormField(
                          labelText: 'Short invite Text - 2 lines',
                          keyboardType: _multiLines,
                          textInputAction: _next,
                          controller: _descriptionTextController,
                          focusNode: _descriptionFocusNode,
                          requestFocus: _venueFocusNode,
                          onSavedCallback: _onSaved,
                          saveFormCallback: _saveForm,
                          isInitialValue: false,
                        ),
                        BuildTextFormField(
                          labelText: 'Venue Name',
                          keyboardType: _text,
                          textInputAction: _next,
                          controller: _venueTextController,
                          focusNode: _venueFocusNode,
                          requestFocus: _venueAddressFocusNode,
                          onSavedCallback: _onSaved,
                          saveFormCallback: _saveForm,
                          isInitialValue: false,
                        ),
                        BuildTextFormField(
                          labelText: 'Venue Address',
                          keyboardType: _multiLines,
                          textInputAction: _next,
                          controller: _venueAddressTextController,
                          focusNode: _venueAddressFocusNode,
                          requestFocus: _contactMobileFocusNode,
                          onSavedCallback: _onSaved,
                          saveFormCallback: _saveForm,
                          isInitialValue: false,
                        ),
                        BuildTextFormField(
                          labelText: 'Contact Mobile',
                          keyboardType: _number,
                          textInputAction: _next,
                          controller: _contactMobileTextController,
                          focusNode: _contactMobileFocusNode,
                          requestFocus: _contactEmailFocusNode,
                          onSavedCallback: _onSaved,
                          saveFormCallback: _saveForm,
                          isInitialValue: false,
                        ),
                        BuildTextFormField(
                          labelText: 'Contact Email',
                          keyboardType: _email,
                          textInputAction: _done,
                          controller: _contactEmailTextController,
                          focusNode: _contactEmailFocusNode,
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
            ),
    );
  }

  Column _buildNgoTitleColumn(String ngoTitle, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: ngoTitle == null
              ? Text(
                  'Add NGO to raise funds',
                  style: TextStyle(fontWeight: FontWeight.w700),
                )
              : Text(
                  'You are raising funds for',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: ngoTitle == null
              ? MaterialButton(
                  minWidth: double.infinity,
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    Navigator.of(context).pushNamed(ListOfNgosScreen.routeName);
                  },
                  child: Text(
                    'Add NGO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(4),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          // ngoTitle,
                          Provider.of<NgosProvider>(context, listen: false)
                              .eventNgoTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                  // : ListTile(
                  //     title: Text(
                  //       // ngoTitle,
                  //       Provider.of<NgosProvider>(context, listen: false).eventNgoTitle,
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w700,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  // subtitle: Text(
                  //   '* To change pull to refresh screen',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontStyle: FontStyle.italic,
                  //     fontSize: 10,
                  //   ),
                  // ),
                  // ),
                ),
        ),
      ],
    );
  }

//   _textForNgo() {
//     ListTile(
//       title: Text(
//         // ngoTitle,
//         Provider.of<NgosProvider>(context).eventNgoTitle,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontWeight: FontWeight.w700,
//           fontSize: 16,
//         ),
//       ),
//       subtitle: Text(
//         '* To change pull to refresh screen',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontStyle: FontStyle.italic,
//           fontSize: 10,
//         ),
//       ),
//     );
//   }
}

// BuildTextFormField(
//   initialValue: null,
//   onChanged: ngoTitle,
//   labelText:
//       'Select organization for fundraising',
//   keyboardType: null,
//   textInputAction: _done,
//   // controller: Not available as we are using initialValue,

//   focusNode: _ngoTitleFocusNode,
//   requestFocus: null,
//   onSavedCallback: _onSaved,
//   saveFormCallback: _saveForm,
//   isInitialValue: true,
// ),
