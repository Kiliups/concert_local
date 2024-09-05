import 'package:concert_ticket_local/components/ticketCard.dart';
import 'package:flutter/material.dart';
import '../model/concert.dart';
import '../model/concert_repo.dart';

class ConcertComponent extends StatelessWidget {
  const ConcertComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TicketList(concertStream: ConcertRepo.getFutureConcerts()),
          const PastConcertList(),
        ],
      ),
    );
  }
}

class TicketList extends StatelessWidget {
  final Stream<List<Concert>> concertStream;

  const TicketList({super.key, required this.concertStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: concertStream,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const Center(child: Text("No data found."));
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
                child: Text("You haven't added any Tickts yet."));
          }

          if (snapshot.hasData) {
            List<Concert> concerts = [];

            for (var concert in snapshot.data!) {
              concerts.add(concert);
            }

            return Column(
              children: [
                for (var concert in concerts)
                  TicketCard(
                    concert: concert,
                  )
              ],
            );
          }

          return const SizedBox();
        }));
  }
}

class PastConcertList extends StatefulWidget {
  const PastConcertList({super.key});

  @override
  State<PastConcertList> createState() => _PastConcertListState();
}

class _PastConcertListState extends State<PastConcertList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: const Text(
          'Past Concerts',
          style: TextStyle(fontSize: 18),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: <Widget>[
          if (_isExpanded)
            TicketList(concertStream: ConcertRepo.getPastConcerts()),
        ],
      ),
    );
  }
}
