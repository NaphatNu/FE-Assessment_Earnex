import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mock_data.json', () {
    late List<dynamic> traders;

    setUpAll(() {
      final file = File('assets/data/mock_data.json');
      final jsonString = file.readAsStringSync();
      traders = json.decode(jsonString) as List;
    });

    test('has exactly 18 trader entries', () {
      expect(traders, hasLength(18));
    });

    test('all id values are unique', () {
      final ids = <String>{};
      final duplicateIds = <String>{};

      for (final trader in traders) {
        final id = trader['id'] as String;
        if (ids.contains(id)) {
          duplicateIds.add(id);
        } else {
          ids.add(id);
        }
      }

      expect(duplicateIds, isEmpty,
          reason: 'Found duplicate IDs: $duplicateIds');
    });

    test('every tag belongs to the fixed set of 8 tags', () {
      final allTags = <String>{};
      final expectedTags = {
        'Top Performer',
        'Money Maker',
        'Whale Manager',
        'Most Resilient',
        'Solid Growth',
        'Most Consistent',
        'Low Leverage',
        'High Risk'
      };

      for (final trader in traders) {
        final tags = List<String>.from(trader['tags'] as List);
        allTags.addAll(tags);
      }

      expect(allTags, equals(expectedTags),
          reason: 'Unexpected tags found: ${allTags.difference(expectedTags)}');
    });

    test('every trader has between 1 and 3 tags inclusive', () {
      for (final trader in traders) {
        final tags = List<String>.from(trader['tags'] as List);
        expect(tags.length, greaterThanOrEqualTo(1));
        expect(tags.length, lessThanOrEqualTo(3));
      }
    });

    test('tag counts match expected values', () {
      final tagCounts = <String, int>{};

      // Count tags
      for (final trader in traders) {
        final tags = List<String>.from(trader['tags'] as List);
        for (final tag in tags) {
          tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
        }
      }

      final expectedTagCounts = {
        'Top Performer': 5,
        'Money Maker': 4,
        'Whale Manager': 4,
        'Most Resilient': 3,
        'Solid Growth': 4,
        'Most Consistent': 5,
        'Low Leverage': 4,
        'High Risk': 2
      };

      expect(tagCounts, equals(expectedTagCounts));
    });

    test(
        'every unordered pair of distinct tags OR-matches between 5 and 9 inclusive',
        () {
      final tagCounts = <String, int>{};
      final traderTags = <Set<String>>[];

      // Collect all trader tag sets
      for (final trader in traders) {
        final tags =
            Set<String>.from(List<String>.from(trader['tags'] as List));
        traderTags.add(tags);
        for (final tag in tags) {
          tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
        }
      }

      final allTags = tagCounts.keys.toList();
      final tagPairs = <List<String>>[];

      // Generate all unordered pairs of distinct tags
      for (int i = 0; i < allTags.length; i++) {
        for (int j = i + 1; j < allTags.length; j++) {
          tagPairs.add([allTags[i], allTags[j]]);
        }
      }

      // Check each pair
      for (final pair in tagPairs) {
        final tag1 = pair[0];
        final tag2 = pair[1];

        // Count traders matching at least one of the tags
        int matchCount = 0;
        for (final traderTagSet in traderTags) {
          if (traderTagSet.contains(tag1) || traderTagSet.contains(tag2)) {
            matchCount++;
          }
        }

        expect(matchCount, greaterThanOrEqualTo(5),
            reason:
                'Pair ($tag1, $tag2) matches only $matchCount traders, expected at least 5');
        expect(matchCount, lessThanOrEqualTo(9),
            reason:
                'Pair ($tag1, $tag2) matches $matchCount traders, expected at most 9');
      }
    });
  });
}
