import 'dart:io';
import 'package:concert_ticket_local/model/concert.dart';
import 'package:concert_ticket_local/model/db_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ConcertRepo {
  static final DatabaseRepo dbRepo = DatabaseRepo();

  static Future<void> addConcert(String name, DateTime date, String location,
      File? ticket, String? imageUrl) async {
    final db = await dbRepo.database;

    final directory = await getApplicationDocumentsDirectory();
    String? ticketPath;
    if (ticket != null) {
      final ticketFileName = ticket.path.split('/').last;
      final localTicketPath = '${directory.path}/tickets/$ticketFileName';
      final localTicketFile =
          await File(localTicketPath).create(recursive: true);
      await ticket.copy(localTicketFile.path);
      ticketPath = localTicketFile.path;
    }

    Concert concert = Concert(name, date, location, ticketPath, imageUrl);
    await db.insert(
      DatabaseRepo.CONCERT_TABLE,
      concert.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Stream<List<Concert>> getFutureOrPastConcerts(bool isFuture) async* {
    //TODO Stream vs Future with reload after delete
    final db = await dbRepo.database;
    String where = isFuture ? 'date >= ?' : 'date <= ?';

    while (true) {
      // Infinite loop to keep the stream open
      final List<Map<String, Object?>> concertMaps = await db.query(
        DatabaseRepo.CONCERT_TABLE,
        where: where,
        whereArgs: [DateTime.now().millisecondsSinceEpoch],
      );

      // Emit the list of concerts as stream data
      yield [
        for (final {
              'id': id as int,
              'name': name as String,
              'date': date as int,
              'location': location as String,
              'ticketRef': ticketRef as String?,
              'imageRef': imageRef as String?
            } in concertMaps)
          Concert.id(id, name, DateTime.fromMillisecondsSinceEpoch(date),
              location, ticketRef, imageRef),
      ];

      // Wait before checking for new data again (e.g., every 10 seconds)
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  static getPastConcerts() {
    return getFutureOrPastConcerts(false);
  }

  static getFutureConcerts() {
    return getFutureOrPastConcerts(true);
  }

  static deleteConcert(int id) async {
    final db = await dbRepo.database;
    await db.delete(
      DatabaseRepo.CONCERT_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
