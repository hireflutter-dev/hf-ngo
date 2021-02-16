import 'package:Gifts/src/common/providers/causes_provider.dart';
import 'package:Gifts/src/common/providers/individual_cause_provider.dart';
import 'package:Gifts/src/screens/causes_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditCauseScreen extends StatefulWidget {
  static const routeName = '/addEditCauseScreen';

  @override
  _AddEditCauseScreenState createState() => _AddEditCauseScreenState();
}

class _AddEditCauseScreenState extends State<AddEditCauseScreen> {
  final _causeTitleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _causeTitleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedCause = IndividualCauseProvider(
    id: null,
    causeTitle: '',
    description: '',
    imageUrl: '',
  );

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final _causeId = ModalRoute.of(context).settings.arguments as String;

      if (_causeId != null) {
        _editedCause = Provider.of<CausesProvider>(context, listen: false)
            .findById(_causeId);

        _causeTitleTextController.text = _editedCause.causeTitle;

        _descriptionTextController.text = _editedCause.description;

        _imageUrlController.text = _editedCause.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _causeTitleTextController.dispose();
    _causeTitleFocusNode.dispose();

    _descriptionTextController.dispose();
    _descriptionFocusNode.dispose();

    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

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
    if (_editedCause.id != null) {
      Provider.of<CausesProvider>(context, listen: false)
          .updateCause(_editedCause.id, _editedCause);
    } else {
      try {
        await Provider.of<CausesProvider>(context, listen: false)
            .addCause(_editedCause);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
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
    Navigator.of(context).pushNamed(CausesOverviewScreen.routeName);
  }

  Text _title() {
    if (_editedCause.id == null) {
      return const Text('Add Cause');
    } else {
      return const Text('Edit Cause');
    }
  }

  /// Use what's needed
  // var _number = TextInputType.number;
  // var _email = TextInputType.emailAddress;
  var _next = TextInputAction.next;
  var _done = TextInputAction.done;
  var _text = TextInputType.text;
  var _multiLines = TextInputType.multiline;
  var _url = TextInputType.url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: _title(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text('Save'),
              // color: Colors.white,
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
                      _buildTextFormField(
                        context,
                        // null,// 'ngoTitle',
                        'Cause Title',
                        _causeTitleTextController,
                        _next,
                        _text,
                        _causeTitleFocusNode,
                        _causeTitleFocusNode,
                      ),
                      _buildTextFormField(
                        context,
                        // null,// 'description',
                        'Description',
                        _descriptionTextController,
                        _next,
                        _multiLines,
                        _descriptionFocusNode,
                        _imageUrlFocusNode,
                      ),
                      _buildImageUrlRow(
                        context,
                        'Image Url',
                        _imageUrlController,
                        _imageUrlFocusNode,
                        null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Row _buildImageUrlRow(
    context,
    _labelText,
    _urlController,
    _focusNode,
    _requestFocus,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _urlController.text.isEmpty
              ? Center(child: Text('Enter a URL'))
              : FittedBox(
                  child: Image.network(_urlController.text),
                  fit: BoxFit.cover,
                ),
        ),
        Expanded(
          child: _buildTextFormField(
            context,
            _labelText,
            _urlController,
            _done,
            _url,
            _focusNode,
            _requestFocus,
          ),
        ),
      ],
    );
  }

  TextFormField _buildTextFormField(
    BuildContext context,
    // initialValue,
    _labelText,
    _urlController,
    _textInputAction,
    _keyboardType,
    _focusNode,
    _requestFocus,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: _labelText,
      ),
      maxLines: _keyboardType == _multiLines ? 3 : 1,
      controller: _urlController,
      textInputAction: _textInputAction,
      keyboardType: _keyboardType,
      focusNode: _focusNode,
      onFieldSubmitted: (_) {
        if (_textInputAction == _done) {
          _saveForm(context);
        } else {
          FocusScope.of(context).requestFocus(_requestFocus);
        }
      },
      validator: (value) {
        if (_keyboardType == TextInputType.text) {
          if (value.isEmpty) {
            return 'Please enter a $_labelText';
          }
        } else if (_keyboardType == TextInputType.multiline) {
          if (value.isEmpty) {
            return 'Please enter a $_labelText';
          }

          if (value.length < 10) {
            return 'Should be at least 10 characters long';
          }
        } else if (_keyboardType == TextInputType.number) {
          if (value.isEmpty) {
            return 'Please enter a $_labelText';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          if (double.parse(value) <= 0) {
            return 'Please enter a number greater than 0';
          }
        } else if (_keyboardType == TextInputType.url) {
          if (value.isEmpty) {
            return 'Please enter an image URL';
          }

          if (value.startsWith('http') && !value.startsWith('https')) {
            return 'Please enter a valid image URL';
          }
          if (!value.contains('.png') &&
              !value.contains('.jpg') &&
              !value.contains('.jpeg')) {
            return 'Please enter a valid image URL';
          }
        }

        return null;
      },
      onSaved: (value) {
        _editedCause = IndividualCauseProvider(
          id: _editedCause.id,
          isFavorite: _editedCause.isFavorite,
          causeTitle: value != null
              ? _causeTitleTextController.text
              : _editedCause.causeTitle,
          description: value != null
              ? _descriptionTextController.text
              : _editedCause.description,
          imageUrl:
              value != null ? _imageUrlController.text : _editedCause.imageUrl,
        );
      },
    );
  }
}
