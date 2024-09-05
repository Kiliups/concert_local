import 'package:flutter/material.dart';
import '../model/spotify_repo.dart';

class DropDownSearch extends StatefulWidget {
  Function safeArtistCallback;

  DropDownSearch({super.key, required this.safeArtistCallback});

  @override
  State<DropDownSearch> createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<DropDownSearch> {
  final TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> artists = [];

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (event) {
        setState(() {
          artists = [];
        });
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: TextField(
              controller: _nameController,
              onChanged: (String value) async {
                if (value.length >= 2) {
                  artists = await SpotifyRepo.searchArtist(value);
                } else {
                  artists = [];
                }
                var artist = {'name': value, 'image': null};
                widget.safeArtistCallback(artist);
                setState(() {});
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                hintText: 'Artist Name',
              ),
            ),
          ),
          Column(
              children: artists
                  .map((artist) => GestureDetector(
                        onTap: () {
                          widget.safeArtistCallback(artist);
                          _nameController.text = artist['name'];
                          artists = [];
                          setState(() {});
                        },
                        child: Card(
                          child: SizedBox(
                            height: 60,
                            child: Center(
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: artist['image'] != null
                                          ? Image.network(artist['image']!,
                                              fit: BoxFit.cover,
                                              width: 50,
                                              height: 50)
                                          : const SizedBox(),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          artist['name'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList()),
        ],
      ),
    );
  }
}
