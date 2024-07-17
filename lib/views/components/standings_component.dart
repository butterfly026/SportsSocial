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
    StandingInfoModel? initialInfo = dataMockService.standingsInfoNotifier.value.isNotEmpty
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

  Widget _getStandingInfoRowHeaderItem(StandingInfoRowHeader item) {
    return Expanded(
      flex: item.flex,
      child: Column(
        children: [
          Text(item.label,
              textAlign: TextAlign.center,
              style: txtStyleBody2.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _getStandingRowHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
          color: const Color(0xFF3B3C41),
          border: Border.all(color: const Color(0xFF686E76))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var item in StandingInfoRowHeader.getStandingRowHeaders())
            _getStandingInfoRowHeaderItem(item),
        ],
      ),
    );
  }

  Widget _getStandingCellItem(
      StandingInfoRowHeader item, int rankNum, StandingRowModel cellValue) {
    String cellText = item.label == '#'
        ? (rankNum + 1).toString()
        : item.label == 'GD'
            ? (cellValue.goalsFor - cellValue.goalsAgainst).toString()
            : cellValue.getField(item.valueName!).toString();
    return Expanded(
      flex: item.flex,
      child: Column(
        children: [
          Text(cellText,
              textAlign: TextAlign.center,
              style: txtStyleBody2.copyWith(
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _getStandingRow(StandingModel standing) {
    return Column(
      children: [
        for (var standingRow in standing.rows.asMap().entries)
          Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              Container(
                decoration: BoxDecoration(
                    // color: standing['color'],
                    border:
                        Border.all(color: const Color(0xFF686E76), width: 1.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var rowHeader
                          in StandingInfoRowHeader.getStandingRowHeaders())
                        _getStandingCellItem(
                            rowHeader, standingRow.key, standingRow.value),
                    ],
                  ),
                ),
              )
            ],
          )
      ],
    );
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
          _getStandingRowHeader(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: dataMockService.filteredStandingsNotifier,
              builder: (context, standings, child) {
                return ListView.builder(
                    itemCount: standings.length,
                    itemBuilder: (context, index) {
                      var standing = standings[index];
                      return _getStandingRow(standing);
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
