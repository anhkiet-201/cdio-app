import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  const FilterBar(
      {super.key,
      required this.options,
      required this.onFilterChange,
      this.onSheetClose});

  final List<FilterOption> options;
  final Function(List<FilterOption>) onFilterChange;
  final Function()? onSheetClose;

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: BaseScrollView.horizontal(
          itemCount: widget.options.length,
          itemBuilder: (_, index) {
            return GestureDetector(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey
                        .withOpacity(widget.options[index].selected != null ? 0.5 : 0.3),
                    border: widget.options[index].selected != null ? Border.all() : null),
                child: Row(
                  children: [
                    Text(widget.options[index].label),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  showDragHandle: true,
                  builder: (BuildContext context) => _sheet(),
                ).then((_) => _onSheetHide());
              },
            );
          },
        ),
      ),
    );
  }
}

extension on _FilterBarState {
  Widget _sheet() {
    final option = widget.options[_selectedIndex];
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            option.label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const Divider(),
          Expanded(
            child: _FilterBarSelectList(
                option: option,
                onSelected: (value) {
                  widget.options[_selectedIndex].selected = value;
                  widget.onFilterChange(widget.options);
                }),
          )
        ],
      ),
    );
  }

  void _onSheetHide() {
    widget.onSheetClose?.call();
  }
}

class _FilterBarSelectList extends StatefulWidget {
  const _FilterBarSelectList(
      {super.key, required this.option, required this.onSelected});

  final FilterOption option;
  final Function(String?) onSelected;

  @override
  State<_FilterBarSelectList> createState() => _FilterBarSelectListState();
}

class _FilterBarSelectListState extends State<_FilterBarSelectList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: widget.option.options.length,
      itemBuilder: (_, index) {
        return SizedBox(
          height: 50,
          child: TextButton(
            onPressed: () {
              setState(() {});
              if(widget.option.options[index] == 'Tất cả') {
                widget.onSelected(null);
              } else {
                widget.onSelected(widget.option.options[index]);
              }
            },
            child: Text(
              widget.option.options[index],
              style: TextStyle(
                  color: widget.option.selected == widget.option.options[index]
                      ? Colors.black
                      : Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

class FilterOption {
  final String label;
  final List<String> options;
  String? selected;

  FilterOption({required this.label, required this.options});
}
