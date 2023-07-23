import 'package:flutter/material.dart';

import 'news_message.dart';

class CreateNewsScreen extends StatefulWidget {
  final String channelTitle;

  const CreateNewsScreen({Key? key, required this.channelTitle})
      : super(key: key);

  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _textController;
  late TextEditingController _sourceController;
  late TextEditingController _linkController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _textController = TextEditingController();
    _sourceController = TextEditingController();
    _linkController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _sourceController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to show the confirmation dialog
  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Publication'),
          content: Text(
            'Are you sure you want to publish the news to ${widget.channelTitle}?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  // Function to save the news
  void _publishNews() async {
    String title = _titleController.text;
    String text = _textController.text;
    DateTime date = _selectedDate;
    String source = _sourceController.text;
    String link = _linkController.text;

    NewsMessage newsMessage = NewsMessage(
        title: title, text: text, source: source, link: link, date: date);

    print(newsMessage);
    // TODO: save news-feed on the backend

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.channelTitle} - Create Feed'),
      ),
      body: Builder(
          // Use the Builder widget to create a new context where the ScaffoldMessenger can be accessed
          builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _textController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Text',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Text is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                          ),
                          child: Text(
                            '${_selectedDate.toLocal()}'.split(' ')[0],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _sourceController,
                  decoration: const InputDecoration(
                    labelText: 'Source',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Source is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _linkController,
                  decoration: const InputDecoration(
                    labelText: 'Link',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Link is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Validate the form
          if (_formKey.currentState!.validate()) {
            // If the form is valid, show the confirmation dialog
            bool? confirmed = await _showConfirmationDialog();

            // If the user confirmed, publish the news
            if (confirmed != null && confirmed) {
              _publishNews();
            }
          }
        },
        child: const Icon(Icons.publish),
      ),
    );
  }
}
