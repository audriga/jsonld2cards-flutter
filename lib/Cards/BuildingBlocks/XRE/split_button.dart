library split_button;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/sml_app_context.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef SplitButtonCallback = Function(String option);
class ForwardButton extends StatefulWidget {
  final SplitButtonCallback onTap;

  const ForwardButton({super.key, required this.onTap});

  @override
  State<ForwardButton> createState() => _ForwardButtonState();
}

class _ForwardButtonState extends State<ForwardButton> {
  late final Future<List<String>>? _forwardAddresses = getForwardAddresses();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _forwardAddresses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SplitButton(options: snapshot.data ?? [], onTap: widget.onTap);
        } else {
          return Container();
        }
      },
    );
  }

  Future<List<String>>? getForwardAddresses() {
    var forwardAddressesFunc = globalSMLAppContext?.forwardEmailAddresses;
    if (forwardAddressesFunc != null) {
      return forwardAddressesFunc();
    }
    return null;
  }
}

class SplitButton extends StatefulWidget {
  final SplitButtonCallback onTap;
  final List<String> options;

  const SplitButton({super.key, required this.onTap, required this.options});

  @override
  State<SplitButton> createState() => _SplitButtonState();
}

class _SplitButtonState extends State<SplitButton> {
  late String? dropdownValue = widget.options.firstOrNull;
  late List<String> addresses = widget.options;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.forward_to_inbox),
        if (dropdownValue != null)
          TextButton(
              onPressed: () => widget.onTap(dropdownValue!),
              child: Text(dropdownValue!)),
        addresses.isNotEmpty
            ? MenuBar(
                children: [
                  SubmenuButton(
                    menuChildren: addresses
                        .map<MenuItemButton>((v) => MenuItemButton(
                              child: Text(v),
                              onPressed: () {
                                setState(() {
                                  dropdownValue = v;
                                });
                              },
                            ))
                        .toList(),
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              )
            : TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l!.errorTitleNoTargetsConfigured),
                      content: Text(l!.noTargetsConfiguredMessage),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              globalSMLAppContext!.reloadContacts!();
                              var freshAddresses = await globalSMLAppContext!
                                  .forwardEmailAddresses!();
                              if (context.mounted) {
                                Navigator.pop(context, 'Ok');
                              }
                              if (freshAddresses.isNotEmpty) {
                                setState(() {
                                  addresses = freshAddresses;
                                  dropdownValue = addresses.first;
                                });
                              }
                            },
                            child: Text(l!.reloadContacts)),
                        TextButton(
                            onPressed: () => Navigator.pop(context, 'Ok'),
                            child: Text(l!.ok))
                      ],
                    ),
                  );
                },
                child: Text(l!.forwardButtonLabel),
              ),
        // DropdownMenu(
        //
        //   onSelected: (String? value){
        //     setState(() {
        //       dropdownValue = value!;
        //     });
        //   },
        //   dropdownMenuEntries: widget.options.map<DropdownMenuEntry<String>>((String value) {
        //     return DropdownMenuEntry<String>(
        //       value: value,
        //       // child: Text(value),
        //       // labelWidget: TextButton(onPressed: (){}, child: Text(value)),
        //       label: value,
        //     );
        //   }).toList(),
        //
        // ),
      ],
    );
  }
}
