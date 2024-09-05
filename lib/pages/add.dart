import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../components/dropDownSearch.dart';
import '../components/imageAppBar.dart';
import '../model/concert_repo.dart';
import '../model/functions.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  String _name = '';
  DateTime? _date;
  String _location = '';
  File? _ticket;
  String? _imageUrl;
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void safeArtistCallback(Map<String, dynamic> artist) {
    if (artist['image'] != null) _imageUrl = artist['image'];
    _name = artist['name'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ImageAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.add_card,
                  size: 56,
                ),
                Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Text(
                      'Add a Concert Ticket',
                      style: TextStyle(fontSize: 24),
                    )),
              ],
            ),
            imageUrl: _imageUrl,
          ),
          SliverFillRemaining(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropDownSearch(safeArtistCallback: safeArtistCallback),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: GestureDetector(
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)));
                              if (date != null) {
                                final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        const TimeOfDay(hour: 19, minute: 0));
                                if (time != null) {
                                  final DateTime dateTime = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute);
                                  setState(() {
                                    _date = dateTime;
                                  });
                                }
                              }
                            },
                            child: TextField(
                              controller: TextEditingController(
                                  text: _date == null
                                      ? ''
                                      : convertDateToString(_date!)),
                              enabled: false,
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.grey),
                                // Text color
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                hintText: 'Date',
                              ),
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: TextField(
                          controller: _locationController,
                          onChanged: (String value) {
                            setState(() {
                              _location = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            hintText: 'Location',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();
                          if (result != null) {
                            setState(() {
                              _ticket = File(result.files.single.path!);
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withOpacity(0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: Center(
                                child: _ticket == null
                                    ? const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.upload),
                                          Text('Add Ticket'),
                                        ],
                                      )
                                    : Text(_ticket!.path.split('/').last,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(fontSize: 16)),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_name.isNotEmpty &&
                              _location.isNotEmpty &&
                              _date != null) {
                            ConcertRepo.addConcert(_name, _date!, _location,
                                    _ticket, _imageUrl)
                                .then((value) => {
                                      //added concert
                                      Navigator.pop(context)
                                    })
                                .catchError((error) => {
                                      //error
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("An error occurred"),
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 1),
                                        ),
                                      )
                                    });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
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
