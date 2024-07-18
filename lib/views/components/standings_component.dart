import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/standings_model.dart';
import 'package:sport_social_mobile_mock/services/data_mock_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';
import 'package:sport_social_mobile_mock/views/components/dropdown.dart';

class StandingsWidget extends StatefulWidget {
  const StandingsWidget({super.key});

  @override
  StandingsWidgetState createState() => StandingsWidgetState();
}

class StandingsWidgetState extends State<StandingsWidget> {
  final dataMockService = ServiceLocator.get<DataMockService>();
  final TextStyle txtStyleBody2 =
      const TextStyle(fontSize: 10, letterSpacing: 0.2, color: Colors.white);
  List<StandingSeasonInfoModel> seasons = [];
  StandingSeasonInfoModel? _selectedSeason;

  @override
  void initState() {
    super.initState();
    StandingInfoModel? initialInfo =
        dataMockService.standingsInfoNotifier.value.isNotEmpty
            ? dataMockService.standingsInfoNotifier.value[0]
            : null;
    if (initialInfo != null) {
      seasons = initialInfo.seasons;
      _selectedSeason = seasons.isNotEmpty ? seasons[0] : null;
      dataMockService.getStandingBySeasonId(_selectedSeason!.id);
    }
  }

  Widget _getStandingInfoDropdown(List<StandingInfoModel> infoList) {
    return Expanded(
      flex: 2,
      child: CustomDropdownMenu(
        items: infoList,
        selectedItem: infoList.isNotEmpty ? infoList[0] : null,
        labelFieldName: 'name',
        onChanged: (dynamic value) {
          setState(() {
            if (value != null) {
              seasons = value?.seasons ?? [];
              _selectedSeason = seasons.isNotEmpty ? seasons[0] : null;
              dataMockService.getStandingBySeasonId(_selectedSeason!.id);
            }
          });
        },
      ),
    );
  }

  Widget _getSeasonsDropdown() {
    return Expanded(
      flex: 1,
      child: CustomDropdownMenu(
        items: seasons,
        selectedItem: _selectedSeason,
        labelFieldName: 'yearTitle',
        onChanged: (dynamic value) {
          _selectedSeason = value;
          dataMockService.getStandingBySeasonId(_selectedSeason!.id);
        },
      ),
    );
  }

  Widget _getStandingInfoRowHeaderItem(StandingRowHeader item) {
    return Column(
      children: [
        Text(item.label,
            textAlign: TextAlign.center,
            style: txtStyleBody2.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<DataColumn2> _getStandingColumns() {
    List<DataColumn2> lstCols = [];
    for (var item in StandingRowHeader.getHeaders()) {
      lstCols.add(DataColumn2(
          size: item.flex == 1 ? ColumnSize.S : ColumnSize.L,
          label: _getStandingInfoRowHeaderItem(item)));
    }
    return lstCols;
  }

  Widget _getStandingCellItem(
      StandingRowHeader item, int rankNum, StandingRowModel cellValue) {
    String cellText = item.label == '#'
        ? (rankNum + 1).toString()
        : item.label == 'GD'
            ? (cellValue.goalsFor - cellValue.goalsAgainst).toString()
            : cellValue.getField(item.valueName!).toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(cellText,
              textAlign: TextAlign.center,
              style: txtStyleBody2.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  List<DataRow2> _getStandingRows(List<StandingRowModel> standingRows) {
    var spaceRow = DataRow2(
      specificRowHeight: 6,
      cells: StandingRowHeader.getHeaders().map((header) {
        return const DataCell(SizedBox(height: 8.0));
      }).toList(),
    );

    List<DataRow2> rows = [];

    for (var standingRow in standingRows) {
      int idx = standingRows.indexOf(standingRow);

      rows.add(spaceRow);

      rows.add(DataRow2(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF686E76),
            width: 1.0,
          ),
        ),
        cells: [
          for (var rowHeader in StandingRowHeader.getHeaders())
            DataCell(_getStandingCellItem(rowHeader, idx, standingRow)),
        ],
      ));
    }
    return rows;
  }

  Widget _getStandingTable(List<StandingRowModel> rows) {
    return DataTable2(
        columnSpacing: 0,
        fixedTopRows: 1,
        horizontalMargin: 6,
        headingRowHeight: 18,
        dividerThickness: 0,
        dataRowHeight: null,
        headingRowDecoration: BoxDecoration(
            color: const Color(0xFF3B3C41),
            border: Border.all(color: const Color(0xFF686E76))),
        minWidth: 300,
        columns: _getStandingColumns(),
        rows: _getStandingRows(rows));
    // return Table(
    //   columnWidths: _getColumnWidths(),
    //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    //   children: [
    //     ..._getStandingRows(rows),
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: dataMockService.standingsInfoNotifier,
              builder: (context, infoList, child) {
                return Row(
                  children: [
                    _getStandingInfoDropdown(infoList),
                    const SizedBox(width: 8.0),
                    _getSeasonsDropdown(),
                  ],
                );
              }),
          const SizedBox(height: 12.0),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: dataMockService.filteredStandingsNotifier,
              builder: (context, standings, child) {
                List<StandingRowModel> rows = [];
                for (var standing in standings) {
                  rows.addAll(standing.rows);
                }
                return Flexible(
                    fit: FlexFit.tight, child: _getStandingTable(rows));
              },
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class StandingRowHeader {
  final String label;
  final String? valueName;
  final int flex;
  const StandingRowHeader(
      {required this.label, required this.flex, this.valueName});
  StandingRowHeader.fromJson(Map<String, dynamic> json)
      : this(
            label: json['label'],
            flex: json['flex'],
            valueName: json['valueName']);
  static List<StandingRowHeader> getHeaders() {
    return [
      const StandingRowHeader(
        label: '#',
        valueName: 'id',
        flex: 1,
      ),
      const StandingRowHeader(
        label: 'Teams',
        valueName: 'teamDisplayName',
        flex: 3,
      ),
      const StandingRowHeader(
        label: 'MP',
        valueName: 'matchesPlayed',
        flex: 1,
      ),
      const StandingRowHeader(
        label: 'W',
        valueName: 'wins',
        flex: 1,
      ),
      const StandingRowHeader(
        label: 'D',
        valueName: 'draws',
        flex: 1,
      ),
      const StandingRowHeader(
        label: 'L',
        valueName: 'losses',
        flex: 1,
      ),
      const StandingRowHeader(
        label: 'GF',
        valueName: 'goalsFor',
        flex: 1,
      ),
      const StandingRowHeader(
        label: 'GA',
        valueName: 'goalsAgainst',
        flex: 1,
      ),
      const StandingRowHeader(
        label: 'GD',
        valueName: 'goalsAgainst',
        flex: 1,
      ),
      const StandingRowHeader(
        label: 'Pts',
        valueName: 'points',
        flex: 1,
      ),
      const StandingRowHeader(
        label: 'FORM',
        valueName: 'form',
        flex: 2,
      ),
    ];
  }
}
