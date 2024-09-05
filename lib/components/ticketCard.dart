import 'package:flutter/material.dart';

import '../model/concert.dart';
import '../model/concert_repo.dart';
import '../model/functions.dart';
import '../pages/details.dart';

class TicketCard extends StatefulWidget {
  const TicketCard({super.key, required this.concert});

  final Concert concert;

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Details(concert: widget.concert)),
        );
      },
      child: Card(
        child: SizedBox(
          height: 120,
          child: Center(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: widget.concert.imageRef != null
                        ? Image.network(widget.concert.imageRef!,
                            fit: BoxFit.cover, width: 100, height: 100)
                        : const SizedBox(),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.concert.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        convertDateToString(widget.concert.date),
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        widget.concert.location.toString(),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Ticket'),
                            content: const Text(
                                'Are you sure you want to delete this ticket?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  int? id = widget.concert.id;
                                  id != null
                                      ? ConcertRepo.deleteConcert(id)
                                      : ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Please fill all fields'),
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete_outline))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
