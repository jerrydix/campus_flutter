import 'package:campus_flutter/providers_get_it.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTextField extends ConsumerStatefulWidget {
  const SearchTextField({super.key, required this.textEditingController});

  final TextEditingController textEditingController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchTextFieldState();
}

class _SearchTextFieldState extends ConsumerState<SearchTextField> {
  bool showIcon = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.padding),
      child: TextField(
        controller: widget.textEditingController,
        onChanged: (searchString) {
          ref.read(searchViewModel).triggerSearchAfterUpdate(searchString);
          setState(() {
            showIcon = widget.textEditingController.value.text.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          hintText: context.localizations.search,
          suffixIcon: showIcon
              ? GestureDetector(
                  onTap: () {
                    ref.read(searchViewModel).clear();
                    widget.textEditingController.clear();
                    setState(() {
                      showIcon = false;
                    });
                  },
                  child: const Icon(Icons.clear),
                )
              : null,
        ),
      ),
    );
  }
}
